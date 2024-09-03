import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Widgets To Image',
        theme: ThemeData(primarySwatch: Colors.green),
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String imageURL =
      'https://media.licdn.com/dms/image/v2/D4D22AQGnsyfjI-bFew/feedshare-shrink_800/feedshare-shrink_800/0/1724177973449?e=1727913600&v=beta&t=QpeKtqYuH4Ta_KyzimTM2Lp9lvNizlfxYXl7qPHwBJ0';

  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;

  Future<void> shareImage(Uint8List imageBytes) async {
    try {
      // Write the image bytes to a file
      final file = XFile.fromData(
        imageBytes,
        mimeType: 'image/png',
        name: 'shared_image.png',
      );

      // Share the image file using share_plus
      await Share.shareXFiles([file], text: 'Check out this Product!');
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Share Card'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "The Card",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            WidgetsToImage(
              controller: controller,
              child: cardWidget(imageURL),
            ),
            const SizedBox(height: 20),
            const Text(
              "Image URL",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              initialValue: imageURL,
              decoration:
                  const InputDecoration(hintText: 'Enter image url here'),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: (value) {
                setState(() {
                  imageURL = value;
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.ios_share),
          onPressed: () async {
            final bytes = await controller.capture();
            setState(() {
              this.bytes = bytes;
            });
            await shareImage(this.bytes!);
          },
        ),
      );

  Widget cardWidget(String imageURL) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageURL,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Product name goes here",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "other stuff, or however we manage the card layout later! ",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget buildImage(Uint8List bytes) => Image.memory(bytes);
}
