import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

class ListExample extends StatelessWidget {
  const ListExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 120,
        itemBuilder: (_, int index) {
          return ListTile(
            title: Text('Item $index'),
            leading: const InfoPopupWidget(
              contentTitle: 'Lorem ipsum dolor sit amet',
              child: Icon(Icons.info),
            ),
          );
        },
      ),
    );
  }
}
