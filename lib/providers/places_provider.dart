import 'package:flutter/foundation.dart';
import 'dart:io';

import '../models/place_model.dart';
import '../helpers/db_helper.dart';

class PlacesProvider with ChangeNotifier {
  List<PlaceModel> _placesList = [];

  var items;

  List<PlaceModel> get getListOfPlaces => [..._placesList];

  void addPlace(String title, File image) {
    final newPlace = PlaceModel(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: null,
    );

    _placesList.add(newPlace);

    notifyListeners();

    DBHelper.insertData(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path.toString(),
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final listPlaces = await DBHelper.getData('user_places');

    if(listPlaces.isNotEmpty) {
      _placesList = listPlaces.map((item) {
        return PlaceModel(
          id: item['id'],
          image: File(item['image']),
          title: item['title'],
          location: null,
        );
      }).toList();

      notifyListeners();
    }
  }
}
