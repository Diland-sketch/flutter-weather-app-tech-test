import 'package:fpdart/fpdart.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';

abstract interface class IEventsRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents(String location);
}