import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';

import '../../../../models/hive_adapters/geopoint_adapter.dart';

class MeetsLocalStorage {

  static final MeetsLocalStorage _instance = MeetsLocalStorage._internal();
  late final Box<dynamic> _meetBox;

  static String boxName = 'meetsBox';
  static const String _draftMeet = 'draftMeet';

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory MeetsLocalStorage() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  MeetsLocalStorage._internal() {
    // initialization logic
    _meetBox = Hive.box<dynamic>(boxName);
  }

  static Future<void> init() async {
    Hive.registerAdapter<Map<String, dynamic>>(MyMapAdapter());
    Hive.registerAdapter<GeoPoint>(GeoPointAdapter());

    await Hive.openBox<dynamic>(boxName);
  }

  T? _getValue<T>(dynamic key, {T? defaultValue}) => _meetBox.get(key, defaultValue: defaultValue) as T?;


  Future<void> clearBox() async => await _meetBox.clear();

  //private setter method to help hide the keys
  Future<void> _setValue<T>(dynamic key, T? value) => _meetBox.put(key, value);

  Map<String, dynamic>? getDraftMeet()  {
       var value = _getValue(_draftMeet,);

       if(value != null) {
         return value.cast<String, dynamic>();
       }
       return null;
  }
  Future<void> setDraftMeet(SkibbleMeet? value) => _setValue(_draftMeet, value?.toMap());
}


class MyMapAdapter extends TypeAdapter<Map<String, dynamic>> {
  @override
  final int typeId = 0; // You can choose any unique non-negative integer for typeId.

  @override
  Map<String, dynamic> read(BinaryReader reader) {
    int length = reader.readByte();
    return Map.fromIterables(
      List.generate(length, (_) => reader.readString()!),
      List.generate(length, (_) => reader.read()),
    );
  }

  @override
  void write(BinaryWriter writer, Map<String, dynamic> map) {
    writer.writeByte(map.length);
    map.forEach((key, value) {
      writer.writeString(key);
      writer.write(value);
    });
  }
}