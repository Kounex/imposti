package com.kounex.imposti

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import com.google.ai.client.generativeai.GenerativeModel
import org.json.JSONObject
import com.google.ai.client.generativeai.type.BlockThreshold
import com.google.ai.client.generativeai.type.HarmCategory
import com.google.ai.client.generativeai.type.SafetySetting

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.kounex.imposti/intelligence"

    companion object {
        private const val SESSION_INSTRUCTIONS = """
            You are a helpful assistant for a family-friendly word guessing game.
            You generate category lists of common, everyday items.
            Keep items to 1 word if possible, but use 2-3 words when necessary for full context (e.g., full names for people).
            Format each item in Title Case (e.g. 'John Doe', not ALL CAPS).
            Include a good mix of popular and lesser-known examples.
            Always respond with valid JSON only, no extra text or markdown.
        """
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "generateList") {
                val description = call.argument<String>("description")
                val languageCode = call.argument<String>("language") ?: "en"
                val language = if (languageCode == "de") "German" else "English"
                val existingItems = call.argument<List<String>>("existingItems") ?: emptyList()

                if (description != null) {
                    generateCategory(description, language, existingItems, result)
                } else {
                    result.error("INVALID_ARGS", "Description required", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun generateCategory(description: String, language: String, existingItems: List<String>, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                // NOTE: To use Gemini Nano (On-Device), the device must support AICore (e.g. Pixel 8 Pro, S24).
                // If using Cloud (Gemini Pro/Flash), you need an API Key.
                // REPLACE "YOUR_API_KEY" with a valid key from Google AI Studio.
                val apiKey = "YOUR_API_KEY" 
                
                val modelName: String
                val effectiveKey: String

                if (apiKey == "YOUR_API_KEY" || apiKey.isEmpty()) {
                    // No key provided -> Attempt On-Device (Gemini Nano)
                    modelName = "gemini-nano"
                    effectiveKey = "" 
                } else {
                    // Key provided -> Use Cloud (Gemini Flash)
                    modelName = "gemini-1.5-flash"
                    effectiveKey = apiKey
                }

                val model = GenerativeModel(
                    modelName = modelName, 
                    apiKey = effectiveKey,
                    safetySettings = listOf(
                        SafetySetting(HarmCategory.HARASSMENT, BlockThreshold.NONE),
                        SafetySetting(HarmCategory.HATE_SPEECH, BlockThreshold.NONE),
                        SafetySetting(HarmCategory.SEXUALLY_EXPLICIT, BlockThreshold.NONE),
                        SafetySetting(HarmCategory.DANGEROUS_CONTENT, BlockThreshold.NONE)
                    ),
                    systemInstruction = com.google.ai.client.generativeai.type.content {
                        text(SESSION_INSTRUCTIONS)
                    }
                )

                // Prompt aligned with iOS/macOS — concise with a seed for variety
                val seed = (1..99999).random()
                val exclusion = if (existingItems.isNotEmpty()) {
                    " CRITICAL: DO NOT include any of these exact items: ${existingItems.joinToString(", ")}."
                } else ""
                
                val prompt = """
                    Create a category list of $description in $language. Variation: $seed.
                    Respond as JSON: {"title": "creative title", "items": ["Item1", "Item2"], "emoji": "🎯"}.
                    Include exactly 10 distinct items (1-3 words each).$exclusion
                """.trimIndent()

                val response = model.generateContent(prompt)
                val text = response.text

                if (text != null) {
                    val parsed = parseJSONResponse(text)
                    if (parsed != null) {
                        result.success(parsed)
                    } else {
                        result.error("PARSE_ERROR", "Failed to parse AI response as JSON", null)
                    }
                } else {
                    result.error("NO_CONTENT", "Model returned empty text", null)
                }
            } catch (e: Exception) {
                result.error("GENERATION_FAILED", e.localizedMessage, null)
            }
        }
    }

    // Helper — aligned with iOS/macOS parseJSONResponse
    private fun parseJSONResponse(text: String): Map<String, Any>? {
        return try {
            val cleanText = text
                .replace("```json", "")
                .replace("```", "")
                .trim()
            
            val json = JSONObject(cleanText)
            
            val itemsArray = json.getJSONArray("items")
            val itemsList = mutableListOf<String>()
            for (i in 0 until itemsArray.length()) {
                itemsList.add(itemsArray.getString(i))
            }

            mapOf(
                "title" to json.getString("title"),
                "items" to itemsList,
                "emoji" to json.getString("emoji")
            )
        } catch (e: Exception) {
            null
        }
    }
}
