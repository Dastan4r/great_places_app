import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places_provider.dart';
import './add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<PlacesProvider>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<PlacesProvider>(
                child: const Center(
                  child: Text('Got no places yet, start adding some!'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.getListOfPlaces.isEmpty
                    ? ch as Widget
                    : ListView.builder(
                        itemCount: greatPlaces.getListOfPlaces.length,
                        itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  greatPlaces.getListOfPlaces[i].image,
                                ),
                              ),
                              title: Text(greatPlaces.getListOfPlaces[i].title),
                              onTap: () {
                                // Go to detail page ...
                              },
                            ),
                      ),
              ),
      ),
    );
  }
}
