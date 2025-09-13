import 'package:flutter/material.dart';
import 'package:rdcli/rdcli.dart';
import 'package:shared_objects/shared_objects.dart';

/// The main screen.
class MainScreen extends StatefulWidget {
  /// Creates a new [MainScreen].
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _debugInfo = '';
  bool _isDownloading = false;

  final _apiKeyController = TextEditingController();
  final _magnetLinkController = TextEditingController();
  final _downloadLinkController = TextEditingController();

  final _apiKeySharedObject = SharedString('api_key');
  final _magnetLinkSharedObject = SharedString('magnet_link');
  final _downloadLinkSharedObject = SharedString('download_link');

  Future<void> _download() async {
    final rdcli = Rdcli(
      apiKey: _apiKeyController.text,
      magnet: _magnetLinkController.text,
    );

    await _apiKeySharedObject.set(_apiKeyController.text);
    await _magnetLinkSharedObject.set(_magnetLinkController.text);

    setState(() {
      _isDownloading = true;
    });

    String? link;
    try {
      link = await rdcli.downloadLink();

      _debugInfo = 'Done!';
    } on RdcliException catch (e, stacktrace) {
      link = 'Error!';

      _debugInfo = '$e\n$stacktrace';
    }

    _downloadLinkController.text = link;

    await _downloadLinkSharedObject.set(_downloadLinkController.text);

    setState(() {
      _isDownloading = false;
    });
  }

  Future<void> _setUpSharedObjects() async {
    _apiKeyController.text = await _apiKeySharedObject.get() ?? '';
    _magnetLinkController.text = await _magnetLinkSharedObject.get() ?? '';
    _downloadLinkController.text = await _downloadLinkSharedObject.get() ?? '';
  }

  @override
  void initState() {
    super.initState();
    _setUpSharedObjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  enabled: !_isDownloading,
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    hintText: 'Real-Debrid API Key',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  enabled: !_isDownloading,
                  controller: _magnetLinkController,
                  decoration: const InputDecoration(
                    hintText: 'Magnet Link',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: FilledButton(
                  onPressed: !_isDownloading ? _download : null,
                  child: !_isDownloading
                      ? const Text('Download')
                      : const Text('Downloading...'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextFormField(
                  readOnly: true,
                  controller: _downloadLinkController,
                  decoration: const InputDecoration(
                    hintText: 'Download Link',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        _debugInfo,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
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
