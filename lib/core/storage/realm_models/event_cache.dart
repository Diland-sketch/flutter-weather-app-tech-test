import 'package:realm/realm.dart';

part 'event_cache.realm.dart';

@RealmModel()
class _EventCache {
  @PrimaryKey()
  late String id;

  late String type;
  late String datetime;
  late double latitude;
  late double longitude;
  late double distance;
  late String? description;
  late double? size;
  late bool isFavorite;
  late String location;
}