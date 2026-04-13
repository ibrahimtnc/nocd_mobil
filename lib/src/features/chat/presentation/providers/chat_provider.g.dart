// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatHash() => r'bc877cf3ec4d63d519831f4a08130cacbd3c4069';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Chat extends BuildlessAutoDisposeNotifier<ChatState> {
  late final AnalysisResponseModel? previousAnalysis;

  ChatState build({
    required AnalysisResponseModel? previousAnalysis,
  });
}

/// Chat provider
///
/// Copied from [Chat].
@ProviderFor(Chat)
const chatProvider = ChatFamily();

/// Chat provider
///
/// Copied from [Chat].
class ChatFamily extends Family<ChatState> {
  /// Chat provider
  ///
  /// Copied from [Chat].
  const ChatFamily();

  /// Chat provider
  ///
  /// Copied from [Chat].
  ChatProvider call({
    required AnalysisResponseModel? previousAnalysis,
  }) {
    return ChatProvider(
      previousAnalysis: previousAnalysis,
    );
  }

  @override
  ChatProvider getProviderOverride(
    covariant ChatProvider provider,
  ) {
    return call(
      previousAnalysis: provider.previousAnalysis,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatProvider';
}

/// Chat provider
///
/// Copied from [Chat].
class ChatProvider extends AutoDisposeNotifierProviderImpl<Chat, ChatState> {
  /// Chat provider
  ///
  /// Copied from [Chat].
  ChatProvider({
    required AnalysisResponseModel? previousAnalysis,
  }) : this._internal(
          () => Chat()..previousAnalysis = previousAnalysis,
          from: chatProvider,
          name: r'chatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$chatHash,
          dependencies: ChatFamily._dependencies,
          allTransitiveDependencies: ChatFamily._allTransitiveDependencies,
          previousAnalysis: previousAnalysis,
        );

  ChatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.previousAnalysis,
  }) : super.internal();

  final AnalysisResponseModel? previousAnalysis;

  @override
  ChatState runNotifierBuild(
    covariant Chat notifier,
  ) {
    return notifier.build(
      previousAnalysis: previousAnalysis,
    );
  }

  @override
  Override overrideWith(Chat Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatProvider._internal(
        () => create()..previousAnalysis = previousAnalysis,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        previousAnalysis: previousAnalysis,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Chat, ChatState> createElement() {
    return _ChatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatProvider && other.previousAnalysis == previousAnalysis;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, previousAnalysis.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatRef on AutoDisposeNotifierProviderRef<ChatState> {
  /// The parameter `previousAnalysis` of this provider.
  AnalysisResponseModel? get previousAnalysis;
}

class _ChatProviderElement
    extends AutoDisposeNotifierProviderElement<Chat, ChatState> with ChatRef {
  _ChatProviderElement(super.provider);

  @override
  AnalysisResponseModel? get previousAnalysis =>
      (origin as ChatProvider).previousAnalysis;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
