import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../models/address.dart';
import '../../../models/place_suggestion.dart';
import '../../../models/suggestion.dart';
import '../../maps_services/map_requests.dart';
import '../app_data.dart';

class LocationPickerData with ChangeNotifier {
  Address? _pickedLocation;
  TextEditingController? _controller;
  String? _session;
  List<Suggestion>? _placeSuggestions;
  Suggestion? _selectedSuggestion;
  List<String> skibbleChefCountries = ['Canada', 'Nigeria'];


  Address? get pickedLocation => _pickedLocation;
  Suggestion? get selectedSuggestion => _selectedSuggestion;


  TextEditingController? get textController => _controller;
  List<Suggestion>? get placeSuggestions => _placeSuggestions;


  init() {
    _controller = TextEditingController(text: _selectedSuggestion != null ? '${_selectedSuggestion!.title}, ${_selectedSuggestion!.subTitle}' : '');
    _session = Uuid().v4();
    _placeSuggestions = [];
  }


  void reset() {
    _pickedLocation = null;
    _controller?.dispose();
    _placeSuggestions = [];
    notifyListeners();
  }

  void set createInviteAddress(Address address) {
    _pickedLocation = address;
    notifyListeners();
  }


  void set pickedLocation(Address? address) {
    _pickedLocation = address;
    notifyListeners();
  }

  void set pickedLocationWithoutNotify(Address? address) {
    _pickedLocation = address;
  }

  void set selectedSuggestion(Suggestion? placeSuggestion) {
    _selectedSuggestion = placeSuggestion;
    notifyListeners();
  }

  void getPlaceSuggestions(String pattern, BuildContext context) async {
    try {
      if(pattern.trim().length > 1) {
        var result = await GoogleMapsService().getPlaceSuggestions(pattern, _session!, type: ['restaurant', 'bar', 'cafe'], address: context.read<AppData>().userCurrentLocation);
        // var result = await GoogleMapsService().getPlaceSuggestions(pattern, _session!);
        _placeSuggestions = result;
        notifyListeners();
      }
    }
    catch(e) {}
  }
}