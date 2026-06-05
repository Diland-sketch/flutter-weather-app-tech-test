// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsRepositoryHash() => r'9aeefaaf1ef52b0b6b87acf92c49ef3c87c5dfc3';

/// See also [eventsRepository].
@ProviderFor(eventsRepository)
final eventsRepositoryProvider =
    AutoDisposeProvider<IEventsRepository>.internal(
  eventsRepository,
  name: r'eventsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EventsRepositoryRef = AutoDisposeProviderRef<IEventsRepository>;
String _$eventsNotifierHash() => r'9eec1330e489492f8186a6026a1c715c79a7ae63';

/// See also [EventsNotifier].
@ProviderFor(EventsNotifier)
final eventsNotifierProvider = AutoDisposeAsyncNotifierProvider<EventsNotifier,
    List<EventEntity>>.internal(
  EventsNotifier.new,
  name: r'eventsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventsNotifier = AutoDisposeAsyncNotifier<List<EventEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
