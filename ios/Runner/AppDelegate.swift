import Flutter
import UIKit

#if canImport(FoundationModels)
import FoundationModels
#endif

// Define the structured output type for the on-device LLM.
// The @Generable macro handles schema generation automatically.
#if canImport(FoundationModels)
@available(iOS 26.0, *)
@Generable(description: "A category with a title, list of items, and an emoji")
struct CategoryResult {
    @Guide(description: "A creative title for this list in the requested language")
    var title: String
    
    @Guide(description: "Exactly 10 distinct items (use 1 word typically, but up to 3 for full names or clarity)")
    var items: [String]
    
    @Guide(description: "A single emoji that represents this category")
    var emoji: String
}
#endif

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        
        let aiChannel = FlutterMethodChannel(
            name: "com.kounex.imposti/intelligence",
            binaryMessenger: engineBridge.applicationRegistrar.messenger()
        )
        
        aiChannel.setMethodCallHandler({ [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            if call.method == "generateList" {
                guard let args = call.arguments as? [String: Any],
                      let promptText = args["description"] as? String else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Description required", details: nil))
                    return
                }
                
                let languageCode = args["language"] as? String ?? "en"
                let language = languageCode == "de" ? "German" : "English"
                let existingItems = args["existingItems"] as? [String] ?? []
                
                self?.generateCategory(description: promptText, language: language, existingItems: existingItems, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    // MARK: - iOS 26 On-Device Generative AI
    
    private static let sessionInstructions = """
    You are a helpful assistant for a family-friendly word guessing game. \
    You generate category lists of common, everyday items. \
    Keep items to 1 word if possible, but use 2-3 words when necessary for full context (e.g., full names for people). \
    Format each item in Title Case (e.g. 'John Doe', not ALL CAPS). \
    Include a good mix of popular and lesser-known examples.
    """
    
    func generateCategory(description: String, language: String, existingItems: [String], result: @escaping FlutterResult) {
        #if canImport(FoundationModels)
        
        guard #available(iOS 26.0, *) else {
            result(FlutterError(code: "UNSUPPORTED", message: "Requires iOS 26+", details: nil))
            return
        }
        
        Task {
            // 1. Check model availability
            let model = SystemLanguageModel.default
            guard model.availability == .available else {
                result(FlutterError(
                    code: "UNSUPPORTED",
                    message: "On-device model not available. Ensure Apple Intelligence is enabled.",
                    details: nil
                ))
                return
            }
            
            // 2. Build the prompt — a unique seed encourages variety across generations
            let seed = Int.random(in: 1...99999)
            var prompt = "Create a category list of \(description) in \(language). Variation: \(seed)."
            
            if !existingItems.isEmpty {
                let itemsList = existingItems.joined(separator: ", ")
                prompt += " CRITICAL: DO NOT include any of these exact items: \(itemsList)."
            }
            
            // 3. Try structured output first (type-safe via @Generable)
            do {
                let session = LanguageModelSession(
                    model: model,
                    instructions: Self.sessionInstructions
                )
                
                let response = try await session.respond(
                    to: prompt,
                    generating: CategoryResult.self
                )
                
                let generated = response.content
                result([
                    "title": generated.title,
                    "items": generated.items,
                    "emoji": generated.emoji
                ] as [String: Any])
                return
                
            } catch let error as LanguageModelSession.GenerationError {
                switch error {
                case .guardrailViolation(_), .decodingFailure(_):
                    // Fall through to plain text fallback
                    break
                default:
                    result(FlutterError(code: "GENERATION_FAILED", message: error.localizedDescription, details: nil))
                    return
                }
            } catch {
                result(FlutterError(code: "GENERATION_FAILED", message: error.localizedDescription, details: nil))
                return
            }
            
            // 4. Fallback: plain text generation + JSON parsing
            do {
                let fallbackSession = LanguageModelSession(
                    model: model,
                    instructions: """
                    \(Self.sessionInstructions) \
                    Always respond with valid JSON only, no extra text or markdown.
                    """
                )
                
                var fallbackPrompt = """
                Create a category list of \(description) in \(language). \
                Respond as JSON: {"title": "creative title", "items": ["Item1", "Item2"], "emoji": "🎯"}. \
                Include exactly 10 distinct items (1-3 words each).
                """
                
                if !existingItems.isEmpty {
                    let itemsList = existingItems.joined(separator: ", ")
                    fallbackPrompt += " CRITICAL: DO NOT include any of these exact items: \(itemsList)."
                }
                
                let response = try await fallbackSession.respond(to: fallbackPrompt)
                
                guard let parsed = Self.parseJSONResponse(response.content) else {
                    result(FlutterError(code: "PARSE_ERROR", message: "Failed to parse AI response as JSON", details: nil))
                    return
                }
                
                result(parsed)
                
            } catch let error as LanguageModelSession.GenerationError {
                if case .guardrailViolation(_) = error {
                    result(FlutterError(code: "GUARDRAIL_VIOLATION", message: "Content was flagged by on-device safety filter. Please try a different description.", details: nil))
                } else {
                    result(FlutterError(code: "GENERATION_FAILED", message: error.localizedDescription, details: nil))
                }
            } catch {
                result(FlutterError(code: "GENERATION_FAILED", message: error.localizedDescription, details: nil))
            }
        }
        
        #else
        result(FlutterError(code: "UNSUPPORTED", message: "Built without iOS 26 FoundationModels SDK", details: nil))
        #endif
    }
    
    // MARK: - Helpers
    
    private static func parseJSONResponse(_ text: String) -> [String: Any]? {
        let mdFence = String(repeating: "`", count: 3)
        let cleaned = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\(mdFence)json", with: "")
            .replacingOccurrences(of: mdFence, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = cleaned.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let title = json["title"] as? String,
              let items = json["items"] as? [String],
              let emoji = json["emoji"] as? String
        else { return nil }
        
        return [
            "title": title,
            "items": items,
            "emoji": emoji
        ]
    }
}