// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_cache.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class EventCache extends _EventCache
    with RealmEntity, RealmObjectBase, RealmObject {
  EventCache(
    String id,
    String type,
    String datetime,
    double latitude,
    double longitude,
    double distance,
    bool isFavorite,
    String location, {
    String? description,
    double? size,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'datetime', datetime);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'distance', distance);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'size', size);
    RealmObjectBase.set(this, 'isFavorite', isFavorite);
    RealmObjectBase.set(this, 'location', location);
  }

  EventCache._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String get datetime =>
      RealmObjectBase.get<String>(this, 'datetime') as String;
  @override
  set datetime(String value) => RealmObjectBase.set(this, 'datetime', value);

  @override
  double get latitude =>
      RealmObjectBase.get<double>(this, 'latitude') as double;
  @override
  set latitude(double value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  double get longitude =>
      RealmObjectBase.get<double>(this, 'longitude') as double;
  @override
  set longitude(double value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  double get distance =>
      RealmObjectBase.get<double>(this, 'distance') as double;
  @override
  set distance(double value) => RealmObjectBase.set(this, 'distance', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  double? get size => RealmObjectBase.get<double>(this, 'size') as double?;
  @override
  set size(double? value) => RealmObjectBase.set(this, 'size', value);

  @override
  bool get isFavorite => RealmObjectBase.get<bool>(this, 'isFavorite') as bool;
  @override
  set isFavorite(bool value) => RealmObjectBase.set(this, 'isFavorite', value);

  @override
  String get location =>
      RealmObjectBase.get<String>(this, 'location') as String;
  @override
  set location(String value) => RealmObjectBase.set(this, 'location', value);

  @override
  Stream<RealmObjectChanges<EventCache>> get changes =>
      RealmObjectBase.getChanges<EventCache>(this);

  @override
  Stream<RealmObjectChanges<EventCache>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<EventCache>(this, keyPaths);

  @override
  EventCache freeze() => RealmObjectBase.freezeObject<EventCache>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'type': type.toEJson(),
      'datetime': datetime.toEJson(),
      'latitude': latitude.toEJson(),
      'longitude': longitude.toEJson(),
      'distance': distance.toEJson(),
      'description': description.toEJson(),
      'size': size.toEJson(),
      'isFavorite': isFavorite.toEJson(),
      'location': location.toEJson(),
    };
  }

  static EJsonValue _toEJson(EventCache value) => value.toEJson();
  static EventCache _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'type': EJsonValue type,
        'datetime': EJsonValue datetime,
        'latitude': EJsonValue latitude,
        'longitude': EJsonValue longitude,
        'distance': EJsonValue distance,
        'isFavorite': EJsonValue isFavorite,
        'location': EJsonValue location,
      } =>
        EventCache(
          fromEJson(id),
          fromEJson(type),
          fromEJson(datetime),
          fromEJson(latitude),
          fromEJson(longitude),
          fromEJson(distance),
          fromEJson(isFavorite),
          fromEJson(location),
          description: fromEJson(ejson['description']),
          size: fromEJson(ejson['size']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(EventCache._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, EventCache, 'EventCache', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('datetime', RealmPropertyType.string),
      SchemaProperty('latitude', RealmPropertyType.double),
      SchemaProperty('longitude', RealmPropertyType.double),
      SchemaProperty('distance', RealmPropertyType.double),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('size', RealmPropertyType.double, optional: true),
      SchemaProperty('isFavorite', RealmPropertyType.bool),
      SchemaProperty('location', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
