// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analysisHash() => r'60356ff5730723dc18dfa481dd1bc5ff248fffbb';

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

/// Legacy provider for backward compatibility
///
/// Copied from [analysis].
@ProviderFor(analysis)
const analysisProvider = AnalysisFamily();

/// Legacy provider for backward compatibility
///
/// Copied from [analysis].
class AnalysisFamily extends Family<AsyncValue<AnalysisResponseModel?>> {
  /// Legacy provider for backward compatibility
  ///
  /// Copied from [analysis].
  const AnalysisFamily();

  /// Legacy provider for backward compatibility
  ///
  /// Copied from [analysis].
  AnalysisProvider call({
    required String thought,
    required int anxietyLevel,
  }) {
    return AnalysisProvider(
      thought: thought,
      anxietyLevel: anxietyLevel,
    );
  }

  @override
  AnalysisProvider getProviderOverride(
    covariant AnalysisProvider provider,
  ) {
    return call(
      thought: provider.thought,
      anxietyLevel: provider.anxietyLevel,
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
  String? get name => r'analysisProvider';
}

/// Legacy provider for backward compatibility
///
/// Copied from [analysis].
class AnalysisProvider
    extends AutoDisposeFutureProvider<AnalysisResponseModel?> {
  /// Legacy provider for backward compatibility
  ///
  /// Copied from [analysis].
  AnalysisProvider({
    required String thought,
    required int anxietyLevel,
  }) : this._internal(
          (ref) => analysis(
            ref as AnalysisRef,
            thought: thought,
            anxietyLevel: anxietyLevel,
          ),
          from: analysisProvider,
          name: r'analysisProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$analysisHash,
          dependencies: AnalysisFamily._dependencies,
          allTransitiveDependencies: AnalysisFamily._allTransitiveDependencies,
          thought: thought,
          anxietyLevel: anxietyLevel,
        );

  AnalysisProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.thought,
    required this.anxietyLevel,
  }) : super.internal();

  final String thought;
  final int anxietyLevel;

  @override
  Override overrideWith(
    FutureOr<AnalysisResponseModel?> Function(AnalysisRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnalysisProvider._internal(
        (ref) => create(ref as AnalysisRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        thought: thought,
        anxietyLevel: anxietyLevel,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AnalysisResponseModel?> createElement() {
    return _AnalysisProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalysisProvider &&
        other.thought == thought &&
        other.anxietyLevel == anxietyLevel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, thought.hashCode);
    hash = _SystemHash.combine(hash, anxietyLevel.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AnalysisRef on AutoDisposeFutureProviderRef<AnalysisResponseModel?> {
  /// The parameter `thought` of this provider.
  String get thought;

  /// The parameter `anxietyLevel` of this provider.
  int get anxietyLevel;
}

class _AnalysisProviderElement
    extends AutoDisposeFutureProviderElement<AnalysisResponseModel?>
    with AnalysisRef {
  _AnalysisProviderElement(super.provider);

  @override
  String get thought => (origin as AnalysisProvider).thought;
  @override
  int get anxietyLevel => (origin as AnalysisProvider).anxietyLevel;
}

String _$analysisCacheHash() => r'a12815f7dd8732c0288a646ce8a2c7b6e01d1e78';

abstract class _$AnalysisCache
    extends BuildlessAsyncNotifier<AnalysisResponseModel?> {
  late final String thought;
  late final int anxietyLevel;

  FutureOr<AnalysisResponseModel?> build({
    required String thought,
    required int anxietyLevel,
  });
}

/// Analysis provider with pre-fetching support
/// Keep alive to cache results during minigame
///
/// Copied from [AnalysisCache].
@ProviderFor(AnalysisCache)
const analysisCacheProvider = AnalysisCacheFamily();

/// Analysis provider with pre-fetching support
/// Keep alive to cache results during minigame
///
/// Copied from [AnalysisCache].
class AnalysisCacheFamily extends Family<AsyncValue<AnalysisResponseModel?>> {
  /// Analysis provider with pre-fetching support
  /// Keep alive to cache results during minigame
  ///
  /// Copied from [AnalysisCache].
  const AnalysisCacheFamily();

  /// Analysis provider with pre-fetching support
  /// Keep alive to cache results during minigame
  ///
  /// Copied from [AnalysisCache].
  AnalysisCacheProvider call({
    required String thought,
    required int anxietyLevel,
  }) {
    return AnalysisCacheProvider(
      thought: thought,
      anxietyLevel: anxietyLevel,
    );
  }

  @override
  AnalysisCacheProvider getProviderOverride(
    covariant AnalysisCacheProvider provider,
  ) {
    return call(
      thought: provider.thought,
      anxietyLevel: provider.anxietyLevel,
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
  String? get name => r'analysisCacheProvider';
}

/// Analysis provider with pre-fetching support
/// Keep alive to cache results during minigame
///
/// Copied from [AnalysisCache].
class AnalysisCacheProvider
    extends AsyncNotifierProviderImpl<AnalysisCache, AnalysisResponseModel?> {
  /// Analysis provider with pre-fetching support
  /// Keep alive to cache results during minigame
  ///
  /// Copied from [AnalysisCache].
  AnalysisCacheProvider({
    required String thought,
    required int anxietyLevel,
  }) : this._internal(
          () => AnalysisCache()
            ..thought = thought
            ..anxietyLevel = anxietyLevel,
          from: analysisCacheProvider,
          name: r'analysisCacheProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$analysisCacheHash,
          dependencies: AnalysisCacheFamily._dependencies,
          allTransitiveDependencies:
              AnalysisCacheFamily._allTransitiveDependencies,
          thought: thought,
          anxietyLevel: anxietyLevel,
        );

  AnalysisCacheProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.thought,
    required this.anxietyLevel,
  }) : super.internal();

  final String thought;
  final int anxietyLevel;

  @override
  FutureOr<AnalysisResponseModel?> runNotifierBuild(
    covariant AnalysisCache notifier,
  ) {
    return notifier.build(
      thought: thought,
      anxietyLevel: anxietyLevel,
    );
  }

  @override
  Override overrideWith(AnalysisCache Function() create) {
    return ProviderOverride(
      origin: this,
      override: AnalysisCacheProvider._internal(
        () => create()
          ..thought = thought
          ..anxietyLevel = anxietyLevel,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        thought: thought,
        anxietyLevel: anxietyLevel,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<AnalysisCache, AnalysisResponseModel?>
      createElement() {
    return _AnalysisCacheProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalysisCacheProvider &&
        other.thought == thought &&
        other.anxietyLevel == anxietyLevel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, thought.hashCode);
    hash = _SystemHash.combine(hash, anxietyLevel.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AnalysisCacheRef on AsyncNotifierProviderRef<AnalysisResponseModel?> {
  /// The parameter `thought` of this provider.
  String get thought;

  /// The parameter `anxietyLevel` of this provider.
  int get anxietyLevel;
}

class _AnalysisCacheProviderElement
    extends AsyncNotifierProviderElement<AnalysisCache, AnalysisResponseModel?>
    with AnalysisCacheRef {
  _AnalysisCacheProviderElement(super.provider);

  @override
  String get thought => (origin as AnalysisCacheProvider).thought;
  @override
  int get anxietyLevel => (origin as AnalysisCacheProvider).anxietyLevel;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
