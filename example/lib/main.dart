import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InfoPopupPage(),
    );
  }
}

class InfoPopupPage extends StatefulWidget {
  const InfoPopupPage({super.key});

  @override
  State<InfoPopupPage> createState() => _InfoPopupPageState();
}

class _InfoPopupPageState extends State<InfoPopupPage> {
  InfoPopupController? infoPopupTextController;
  InfoPopupController? infoPopupCustomWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (infoPopupTextController != null) {
                  infoPopupTextController!.show();
                }
              },
              child: InfoPopupWidget(
                onControllerCreated: (InfoPopupController controller) {
                  infoPopupTextController = controller;
                },
                arrowTheme: const InfoPopupArrowTheme(
                    arrowDirection: ArrowDirection.down, color: Colors.pink),
                infoText: 'This is a popup',
                child: const Text('Info Popup Info Text Example'),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                if (infoPopupCustomWidgetController != null) {
                  infoPopupCustomWidgetController!.show();
                }
              },
              child: InfoPopupWidget(
                onControllerCreated: (InfoPopupController controller) {
                  infoPopupCustomWidgetController = controller;
                },
                arrowTheme: const InfoPopupArrowTheme(
                  color: Colors.black87,
                ),
                infoWidget: Container(
                  width: context.screenWidth * .8,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'This is a custom widget',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: const Text('Info Popup Custom Widget Example'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
