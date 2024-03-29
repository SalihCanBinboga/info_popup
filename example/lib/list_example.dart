import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

class ListExample extends StatelessWidget {
  const ListExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Example'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 120,
          cacheExtent: 10000,
          itemBuilder: (_, int index) {
            return ListTile(
              title: Text('Item $index'),
              leading: const InfoPopupWidget(
                contentTitle: 'Lorem ipsum dolor sit amet',
                dismissTriggerBehavior:
                    PopupDismissTriggerBehavior.onTapContent,
                child: Icon(Icons.info),
              ),
            );
          },
        ),
      ),
    );
  }
}
