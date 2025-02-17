import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '/widgets/back_button_with_title.dart';

class FirstAidDetailPage extends StatefulWidget {
  final String title;
  final String videoUrl;
  final String steps;

  const FirstAidDetailPage({
    Key? key,
    required this.title,
    required this.videoUrl,
    required this.steps,
  }) : super(key: key);

  @override
  _FirstAidDetailPageState createState() => _FirstAidDetailPageState();
}

class _FirstAidDetailPageState extends State<FirstAidDetailPage> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize WebViewController and handle loading state
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              isLoading = true; // Show loading when a page starts loading
            });
          },
          onPageFinished: (_) {
            setState(() {
              isLoading = false; // Hide loading when page finishes loading
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.videoUrl));  // Use the videoUrl passed to the page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),  // Increased height for better space
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Add padding to avoid camera area overlap
            child: BackButtonWithTitle(title: widget.title),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Section
              if (widget.videoUrl.isNotEmpty)
                Container(
                  height: 400,  // Set a fixed height for the video
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey[200],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: WebViewWidget(controller: _controller),
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                )
              else
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'No video available.',
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              const SizedBox(height: 24.0), // Space for steps section

              // Steps Section
              const Text(
                'Steps:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.steps,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
