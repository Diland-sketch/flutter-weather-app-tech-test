// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_cache.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class WeatherCache extends _WeatherCache
    with RealmEntity, RealmObjectBase, RealmObject {
  WeatherCache(
    String id,
    String resolvedAddress,
    String timezone,
    double latitude,
    double longitude,
    String daysJson,
    DateTime cachedAt, {
    double? currentTemp,
    double? currentFeelsLike,
    double? currentHumidity,
    double? currentWindSpeed,
    String? currentConditions,
    String? currentIcon,
    String? currentDatetime,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'resolvedAddress', resolvedAddress);
    RealmObjectBase.set(this, 'timezone', timezone);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'currentTemp', currentTemp);
    RealmObjectBase.set(this, 'currentFeelsLike', currentFeelsLike);
    RealmObjectBase.set(this, 'currentHumidity', currentHumidity);
    RealmObjectBase.set(this, 'currentWindSpeed', currentWindSpeed);
    RealmObjectBase.set(this, 'currentConditions', currentConditions);
    RealmObjectBase.set(this, 'currentIcon', currentIcon);
    RealmObjectBase.set(this, 'currentDatetime', currentDatetime);
    RealmObjectBase.set(this, 'daysJson', daysJson);
    RealmObjectBase.set(this, 'cachedAt', cachedAt);
  }

  WeatherCache._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get resolvedAddress =>
      RealmObjectBase.get<String>(this, 'resolvedAddress') as String;
  @override
  set resolvedAddress(String value) =>
      RealmObjectBase.set(this, 'resolvedAddress', value);

  @override
  String get timezone =>
      RealmObjectBase.get<String>(this, 'timezone') as String;
  @override
  set timezone(String value) => RealmObjectBase.set(this, 'timezone', value);

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
  double? get currentTemp =>
      RealmObjectBase.get<double>(this, 'currentTemp') as double?;
  @override
  set currentTemp(double? value) =>
      RealmObjectBase.set(this, 'currentTemp', value);

  @override
  double? get currentFeelsLike =>
      RealmObjectBase.get<double>(this, 'currentFeelsLike') as double?;
  @override
  set currentFeelsLike(double? value) =>
      RealmObjectBase.set(this, 'currentFeelsLike', value);

  @override
  double? get currentHumidity =>
      RealmObjectBase.get<double>(this, 'currentHumidity') as double?;
  @override
  set currentHumidity(double? value) =>
      RealmObjectBase.set(this, 'currentHumidity', value);

  @override
  double? get currentWindSpeed =>
      RealmObjectBase.get<double>(this, 'currentWindSpeed') as double?;
  @override
  set currentWindSpeed(double? value) =>
      RealmObjectBase.set(this, 'currentWindSpeed', value);

  @override
  String? get currentConditions =>
      RealmObjectBase.get<String>(this, 'currentConditions') as String?;
  @override
  set currentConditions(String? value) =>
      RealmObjectBase.set(this, 'currentConditions', value);

  @override
  String? get currentIcon =>
      RealmObjectBase.get<String>(this, 'currentIcon') as String?;
  @override
  set currentIcon(String? value) =>
      RealmObjectBase.set(this, 'currentIcon', value);

  @override
  String? get currentDatetime =>
      RealmObjectBase.get<String>(this, 'currentDatetime') as String?;
  @override
  set currentDatetime(String? value) =>
      RealmObjectBase.set(this, 'currentDatetime', value);

  @override
  String get daysJson =>
      RealmObjectBase.get<String>(this, 'daysJson') as String;
  @override
  set daysJson(String value) => RealmObjectBase.set(this, 'daysJson', value);

  @override
  DateTime get cachedAt =>
      RealmObjectBase.get<DateTime>(this, 'cachedAt') as DateTime;
  @override
  set cachedAt(DateTime value) => RealmObjectBase.set(this, 'cachedAt', value);

  @override
  Stream<RealmObjectChanges<WeatherCache>> get changes =>
      RealmObjectBase.getChanges<WeatherCache>(this);

  @override
  Stream<RealmObjectChanges<WeatherCache>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<WeatherCache>(this, keyPaths);

  @override
  WeatherCache freeze() => RealmObjectBase.freezeObject<WeatherCache>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'resolvedAddress': resolvedAddress.toEJson(),
      'timezone': timezone.toEJson(),
      'latitude': latitude.toEJson(),
      'longitude': longitude.toEJson(),
      'currentTemp': currentTemp.toEJson(),
      'currentFeelsLike': currentFeelsLike.toEJson(),
      'currentHumidity': currentHumidity.toEJson(),
      'currentWindSpeed': currentWindSpeed.toEJson(),
      'currentConditions': currentConditions.toEJson(),
      'currentIcon': currentIcon.toEJson(),
      'currentDatetime': currentDatetime.toEJson(),
      'daysJson': daysJson.toEJson(),
      'cachedAt': cachedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(WeatherCache value) => value.toEJson();
  static WeatherCache _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'resolvedAddress': EJsonValue resolvedAddress,
        'timezone': EJsonValue timezone,
        'latitude': EJsonValue latitude,
        'longitude': EJsonValue longitude,
        'daysJson': EJsonValue daysJson,
        'cachedAt': EJsonValue cachedAt,
      } =>
        WeatherCache(
          fromEJson(id),
          fromEJson(resolvedAddress),
          fromEJson(timezone),
          fromEJson(latitude),
          fromEJson(longitude),
          fromEJson(daysJson),
          fromEJson(cachedAt),
          currentTemp: fromEJson(ejson['currentTemp']),
          currentFeelsLike: fromEJson(ejson['currentFeelsLike']),
          currentHumidity: fromEJson(ejson['currentHumidity']),
          currentWindSpeed: fromEJson(ejson['currentWindSpeed']),
          currentConditions: fromEJson(ejson['currentConditions']),
          currentIcon: fromEJson(ejson['currentIcon']),
          currentDatetime: fromEJson(ejson['currentDatetime']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(WeatherCache._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, WeatherCache, 'WeatherCache', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('resolvedAddress', RealmPropertyType.string),
      SchemaProperty('timezone', RealmPropertyType.string),
      SchemaProperty('latitude', RealmPropertyType.double),
      SchemaProperty('longitude', RealmPropertyType.double),
      SchemaProperty('currentTemp', RealmPropertyType.double, optional: true),
      SchemaProperty('currentFeelsLike', RealmPropertyType.double,
          optional: true),
      SchemaProperty('currentHumidity', RealmPropertyType.double,
          optional: true),
      SchemaProperty('currentWindSpeed', RealmPropertyType.double,
          optional: true),
      SchemaProperty('currentConditions', RealmPropertyType.string,
          optional: true),
      SchemaProperty('currentIcon', RealmPropertyType.string, optional: true),
      SchemaProperty('currentDatetime', RealmPropertyType.string,
          optional: true),
      SchemaProperty('daysJson', RealmPropertyType.string),
      SchemaProperty('cachedAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
