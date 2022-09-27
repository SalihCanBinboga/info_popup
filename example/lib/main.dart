import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

void main() => runApp(const MyApp());

const Key infoPopupTextExampleKey = Key('info_popup_text_example');
const String infoPopupTextExampleText = 'This is a popup';

const Key infoPopupCustomExampleKey = Key('info_popup_custom_example');
const String infoPopupCustomExampleText = 'This is a custom widget';

const Key infoPopupLongTextExampleKey = Key('info_popup_long_text_example');
const String infoPopupLongTextExampleText = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Enim lobortis scelerisque fermentum dui faucibus in ornare quam viverra. Consectetur adipiscing elit ut aliquam purus sit. Nisl vel pretium lectus quam. Et odio pellentesque diam volutpat commodo. Diam vulputate ut pharetra sit amet aliquam id diam maecenas. Malesuada fames ac turpis egestas. Et sollicitudin ac orci phasellus egestas tellus rutrum. Pretium lectus quam id leo in. Semper risus in hendrerit gravida. Nullam ac tortor vitae purus faucibus ornare suspendisse sed. Non tellus orci ac auctor. Quis risus sed vulputate odio ut enim blandit.
\n
Nullam eget felis eget nunc lobortis mattis aliquam faucibus purus. Aenean et tortor at risus viverra adipiscing at in. Augue eget arcu dictum varius duis at consectetur. Est pellentesque elit ullamcorper dignissim cras. At consectetur lorem donec massa sapien faucibus et. Sit amet venenatis urna cursus eget. Dignissim cras tincidunt lobortis feugiat vivamus. Eget arcu dictum varius duis at. Aenean pharetra magna ac placerat. Enim nec dui nunc mattis enim ut tellus elementum. Laoreet suspendisse interdum consectetur libero. Tellus mauris a diam maecenas sed enim. Tortor posuere ac ut consequat semper viverra nam libero. Tellus molestie nunc non blandit massa.
''';

const Key infoPopupArrowGapExampleKey = Key('info_popup_arrow_gap_example');
const String infoPopupArrowGapExampleText = infoPopupLongTextExampleText;

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
  InfoPopupController? infoPopupLongTextController;
  InfoPopupController? infoPopupArrowGapController;

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
              key: infoPopupTextExampleKey,
              behavior: HitTestBehavior.translucent,
              child: InfoPopupWidget(
                onControllerCreated: (InfoPopupController controller) {
                  infoPopupTextController = controller;
                },
                arrowTheme: const InfoPopupArrowTheme(
                  arrowDirection: ArrowDirection.down,
                  color: Colors.pink,
                ),
                infoText: infoPopupTextExampleText,
                child: const Text('Info Popup Info Text Example'),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              key: infoPopupCustomExampleKey,
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
                  arrowDirection: ArrowDirection.down,
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
                      infoPopupCustomExampleText,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: const Text('Info Popup Custom Widget Example'),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              key: infoPopupLongTextExampleKey,
              onTap: () {
                if (infoPopupLongTextController != null) {
                  infoPopupLongTextController!.show();
                }
              },
              child: InfoPopupWidget(
                onControllerCreated: (InfoPopupController controller) {
                  infoPopupLongTextController = controller;
                },
                arrowTheme: const InfoPopupArrowTheme(
                  color: Colors.pink,
                ),
                infoText: infoPopupLongTextExampleText,
                child: const Text('Info Popup Long Info Text Example'),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              key: infoPopupArrowGapExampleKey,
              onTap: () {
                if (infoPopupArrowGapController != null) {
                  infoPopupArrowGapController!.show();
                }
              },
              child: InfoPopupWidget(
                onControllerCreated: (InfoPopupController controller) {
                  infoPopupArrowGapController = controller;
                },
                arrowTheme: const InfoPopupArrowTheme(
                  color: Colors.pink,
                  arrowGap: 50,
                ),
                infoText: infoPopupLongTextExampleText,
                child: const Text('Info Popup Arrow Gap Example'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
