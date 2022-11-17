import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

import 'list_example.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const InfoPopupWidget(
                arrowTheme: InfoPopupArrowTheme(
                  arrowDirection: ArrowDirection.down,
                  color: Colors.pink,
                ),
                contentTitle: infoPopupTextExampleText,
                child: Text('Info Popup Info Text Example'),
              ),
              const SizedBox(height: 30),
              InfoPopupWidget(
                arrowTheme: const InfoPopupArrowTheme(
                  color: Colors.black87,
                  arrowDirection: ArrowDirection.down,
                ),
                dismissTriggerBehavior: PopupDismissTriggerBehavior.manuel,
                customContent: Container(
                  width: context.screenWidth * .8,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: const <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          infoPopupCustomExampleText,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                child: const Text('Info Popup Custom Widget Example'),
              ),
              const SizedBox(height: 30),
              const InfoPopupWidget(
                arrowTheme: InfoPopupArrowTheme(
                  color: Colors.pink,
                ),
                contentTitle: infoPopupLongTextExampleText,
                child: Text('Info Popup Long Info Text Example'),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (_) {
                      return Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * .5,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: const <Widget>[
                                InfoPopupWidget(
                                  contentTitle: infoPopupLongTextExampleText,
                                  child: Icon(
                                    Icons.info,
                                    color: Colors.pink,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Info Popup Inside Bottom Sheet Example'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: const Text('Bottom Sheet Inside Example'),
              ),
              const SizedBox(height: 30),
              const InfoPopupWidget(
                contentTitle: 'Info Popup Icon Examplee',
                arrowTheme: InfoPopupArrowTheme(
                  color: Colors.pink,
                ),
                child: Icon(
                  Icons.info,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 30),
              const InfoPopupWidget(
                contentOffset: Offset(0, 30),
                contentTitle: infoPopupArrowGapExampleText,
                child: Text('Info Popup Arrow Gap Example'),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) {
                        return const ListExample();
                      },
                    ),
                  );
                },
                behavior: HitTestBehavior.translucent,
                child: const Text('List Example'),
              ),
              const SizedBox(height: 30),
              const InfoPopupWidget(
                enableHighlight: true,
                contentTitle: 'This is a HighLighted Info Popup',
                child: Text('HighLighted Info Popup Example'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
