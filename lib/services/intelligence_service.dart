// lib/services/intelligence_service.dart
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:imposti/models/category/category.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:uuid/uuid.dart';

enum IntelligenceErrorType {
  /// (iOS/Android) Device or OS version not supported.
  unsupported,

  /// (iOS/Android) Generic failure during generation (network, timeout, API error).
  generationFailed,

  /// (Android only) JSON parsing failed. iOS handles this via macro underlying error.
  parseError,

  /// (iOS/Android) Missing parameters.
  invalidArgs,

  /// (Android only) Model returned empty text.
  noContent,

  /// (iOS only) On-device safety filter flagged the content.
  guardrailViolation,

  /// Catch-all for other errors.
  unknown;

  String get friendlyMessage => switch (this) {
    IntelligenceErrorType.unsupported =>
      'Device or OS version not supported for AI features.',
    IntelligenceErrorType.generationFailed =>
      'Failed to generate content. Please try again.',
    IntelligenceErrorType.parseError => 'Received invalid data format from AI.',
    IntelligenceErrorType.invalidArgs =>
      'Internal error: Missing required parameters.',
    IntelligenceErrorType.noContent => 'AI returned an empty response.',
    IntelligenceErrorType.guardrailViolation =>
      'Content was flagged by the safety filter. Please try a different description.',
    IntelligenceErrorType.unknown => 'An unknown error occurred.',
  };

  static IntelligenceErrorType fromCode(String code) {
    return switch (code) {
      'UNSUPPORTED' => IntelligenceErrorType.unsupported,
      'GENERATION_FAILED' => IntelligenceErrorType.generationFailed,
      'PARSE_ERROR' => IntelligenceErrorType.parseError,
      'INVALID_ARGS' => IntelligenceErrorType.invalidArgs,
      'NO_CONTENT' => IntelligenceErrorType.noContent,
      'GUARDRAIL_VIOLATION' => IntelligenceErrorType.guardrailViolation,
      _ => IntelligenceErrorType.unknown,
    };
  }
}

class IntelligenceException implements Exception {
  final IntelligenceErrorType type;
  final String message;
  final dynamic originalError;

  IntelligenceException(this.type, this.message, [this.originalError]);

  @override
  String toString() => 'IntelligenceException: $type - $message';
}

class IntelligenceService {
  static const MethodChannel _channel = MethodChannel(
    'com.kounex.imposti/intelligence',
  );

  /// Requests the native layer to generate a category based on the description.
  ///
  /// [languageCode] should be 'en' or 'de'.
  /// [existingItems] is an optional list of items the LLM should avoid
  /// generating, useful for subsequent generations to prevent duplicates.
  /// Returns a [Category] object or throws an [IntelligenceException].
  static Future<Category> generateCategory(
    String description, {
    String? languageCode,
    List<String>? existingItems,
  }) async {
    try {
      languageCode ??=
          Hive.box(
            HiveKey.settings.name,
          ).get(HiveSettingsKey.languageCode.name) ??
          'en';

      final Map<String, dynamic> args = {
        'description': description,
        'language': languageCode,
      };

      if (existingItems != null && existingItems.isNotEmpty) {
        args['existingItems'] = existingItems;
      }

      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'generateList',
        args,
      );

      final title = result['title'] as String;
      final items =
          List<String>.from(result['items'] as List).map((item) {
            if (item.isEmpty) return item;
            return item
                .trim()
                .split(RegExp(r'\s+'))
                .map((word) {
                  if (word.isEmpty) return word;
                  return word[0].toUpperCase() +
                      word.substring(1).toLowerCase();
                })
                .join(' ');
          }).toList();
      final emoji = result['emoji'] as String;

      // Create a unique ID for the new category
      final uuid = const Uuid().v4();

      return Category(
        uuid: uuid,
        name: {languageCode!: title},
        base: false,
        emojiUnicode: emoji,
        words: {languageCode: items},
      );
    } on PlatformException catch (e) {
      final type = IntelligenceErrorType.fromCode(e.code);

      throw IntelligenceException(type, e.message ?? type.friendlyMessage, e);
    } catch (e) {
      throw IntelligenceException(
        IntelligenceErrorType.unknown,
        'Unexpected error: $e',
        e,
      );
    }
  }
}
