import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/features/events/data/datasources/events_local_datasource.dart';
import 'package:weather_app/features/events/data/datasources/events_remote_datasource_impl.dart';
import 'package:weather_app/features/events/data/repositories/events_repository_impl.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/events/domain/repositories/i_events_repository.dart';

part 'events_provider.g.dart';

@riverpod
IEventsRepository eventsRepository(EventsRepositoryRef ref) {
  return EventsRepositoryImpl(
    remote: EventsRemoteDatasourceImpl(ref.read(apiClientProvider)),
    local: EventsLocalDataSourceImpl(),
    connectivity: ref.read(connectivityServiceProvider),
  );
}

@riverpod
class EventsNotifier extends _$EventsNotifier {
  @override
  FutureOr<List<EventEntity>> build() => [];

  Future<void> loadEvents(String location) async {
    state = const AsyncLoading();

    final result = await ref
        .read(eventsRepositoryProvider)
        .getEvents(location);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (events) => AsyncData(events),
    );
  }
}