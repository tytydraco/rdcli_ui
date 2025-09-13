import 'package:flutter/material.dart';
import 'package:rdcli/rdcli.dart';

/// The main screen.
class MainScreen extends StatefulWidget {
  /// Creates a new [MainScreen].
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var isDownloading = false;

  final apiKeyController = TextEditingController();
  final magnetLinkController = TextEditingController();
  final downloadLinkController = TextEditingController();

  Future<void> _download() async {
    final rdcli = Rdcli(
      apiKey: apiKeyController.text,
      magnet: magnetLinkController.text,
    );

    setState(() {
      isDownloading = true;
    });

    final link = await rdcli.downloadLink();
    downloadLinkController.text = link;

    setState(() {
      isDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  enabled: !isDownloading,
                  controller: apiKeyController,
                  decoration: const InputDecoration(
                    hintText: 'Real-Debrid API Key',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  enabled: !isDownloading,
                  controller: magnetLinkController,
                  decoration: const InputDecoration(
                    hintText: 'Magnet Link',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: FilledButton(
                  onPressed: !isDownloading ? _download : null,
                  child: !isDownloading
                      ? const Text('Download')
                      : const Text('Downloading...'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  readOnly: true,
                  controller: downloadLinkController,
                  decoration: const InputDecoration(
                    hintText: 'Download Link',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
