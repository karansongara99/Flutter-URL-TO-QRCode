import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import './AboutScreen.dart';
import './QRResultScreen.dart';
import './HistoryScreen.dart';
import './FeedbackScreen.dart';
import '../Database/db_helper.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  TextEditingController urlController = TextEditingController();
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    history = await DBHelper.getHistory();
    setState(() {});
  }

  Future<void> _storeHistory() async {
    String enteredText = urlController.text.trim();
    if (enteredText.isNotEmpty && !history.contains(enteredText)) {
      await DBHelper.insertHistory(enteredText);
      _loadHistory();
    }
  }

  void _navigateToHistoryScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          history: history,
          onSelect: (selectedUrl) {
            setState(() {
              urlController.text = selectedUrl;
            });
          },
        ),
      ),
    );

    if (result == "clear") {
      await DBHelper.clearHistory();
      _loadHistory();
    }
  }

  void _shareQRCode() {
    String textToShare = urlController.text.trim();
    if (textToShare.isNotEmpty) {
      Share.share("Check out this link: $textToShare");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a URL to share.")),
      );
    }
  }

  void _handleMenuSelection(String value) {
    if (value == "about") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUsScreen()),
      );
    } else if (value == "feedback") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedbackScreen()),
      );
    } else if (value == "share app") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Share App feature coming soon!")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _navigateToHistoryScreen,
            tooltip: "View Search History",
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareQRCode,
            tooltip: "Share QR Code",
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "about",
                  child: ListTile(
                    leading: Icon(Icons.info, color: Colors.deepPurple),
                    title: Text("About Us"),
                  ),
                ),
                PopupMenuItem(
                  value: "feedback",
                  child: ListTile(
                    leading: Icon(Icons.feedback, color: Colors.deepPurple),
                    title: Text("Feedback"),
                  ),
                ),
                PopupMenuItem(
                  value: "share app",
                  child: ListTile(
                    leading: Icon(Icons.share, color: Colors.deepPurple),
                    title: Text("Share App"),
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Generate Your QR Code",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                hintText: 'e.g. https://example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.link, color: Colors.deepPurple),
              ),
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.isNotEmpty) {
                  _storeHistory();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QRResultScreen(qrData: urlController.text),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Generate QR Code',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
