#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;       // 0, 1
uniform float u_time;            // 2
uniform vec2 u_center;           // 3, 4
uniform vec2 u_box_size;         // 5, 6
uniform float u_border_radius;   // 7
uniform float u_max_spread;      // 8
uniform vec4 u_color;            // 9, 10, 11, 12
uniform float u_intensity;       // 13
uniform float u_fill_center;     // 14  (0.0 = edge only, 1.0 = fill inside)

out vec4 fragColor;

// Signed Distance Field for a rounded box.
float sdRoundRect(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

void main() {
    vec2 uv = FlutterFragCoord().xy;
    vec2 p = uv - u_center;

    // SDF distance to box edge (negative inside, positive outside)
    vec2 half_size = u_box_size * 0.5;
    float d = sdRoundRect(p, half_size, u_border_radius);

    // Skip inside pixels unless fillCenter is enabled.
    if (d <= 0.0 && u_fill_center < 0.5) {
        fragColor = vec4(0.0);
        return;
    }

    float norm_dist = d / u_max_spread;

    if (norm_dist > 1.2) {
        fragColor = vec4(0.0);
        return;
    }

    // ------------------------------------------------------------------
    // Soft glow variations.
    //
    // Instead of spatial waves (which create spikes), we modulate the
    // glow INTENSITY with just 2-3 slow, broad blobs that drift around
    // the perimeter. The blobs are driven by the angle to the box center
    // and the pixel's position clamped to the nearest edge.
    //
    // Think of it as 2-3 soft spotlights slowly orbiting the button.
    // ------------------------------------------------------------------

    float angle = atan(p.y, p.x);

    // Nearest point on box edge → smooth perimeter coordinate
    vec2 edge_pt = clamp(p, -half_size, half_size);
    float perim = (edge_pt.x + edge_pt.y) * 0.005;

    // Slow, broad brightness blobs (integer multipliers only — non-integers
    // cause a visible seam at the atan discontinuity on the left edge)
    float glow1 = sin(angle * 1.0 + u_time * 1.2 + perim) * 0.5 + 0.5;
    float glow2 = sin(angle * 2.0 - u_time * 0.9 + perim * 2.0) * 0.5 + 0.5;
    float glow3 = cos(angle * 3.0 + u_time * 0.7) * 0.5 + 0.5;

    // Blend the blobs into a smooth intensity multiplier (range ~0.4 to 1.0)
    float variation = 0.4 + 0.6 * (glow1 * 0.4 + glow2 * 0.35 + glow3 * 0.25);

    // The inner ~30% of the spread is a guaranteed full-intensity core.
    // Variation only kicks in past that, ramping from 1.0 → variation value.
    float core_zone = smoothstep(0.0, 0.35, norm_dist); // 0 at edge, 1 past 35%
    float intensity = mix(1.0, variation, core_zone);

    // ------------------------------------------------------------------
    // Aura gradient — smooth outward emission
    // ------------------------------------------------------------------
    float aura = 1.0 - clamp(norm_dist, 0.0, 1.0);

    // Soft exponential falloff
    aura = pow(aura, 2.0);

    // Clean fade at outer boundary
    aura *= smoothstep(1.0, 0.2, norm_dist);

    // Apply the drifting intensity variation
    aura *= intensity;

    // Gentle breathing pulse
    float pulse = 0.88 + 0.12 * sin(u_time * 2.0);
    aura *= pulse;

    // Apply overall intensity
    aura *= u_intensity;

    // Premultiplied alpha for Flutter
    fragColor = vec4(u_color.rgb * aura, aura);
}