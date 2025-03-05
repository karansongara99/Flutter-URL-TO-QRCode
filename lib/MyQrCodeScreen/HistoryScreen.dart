import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import '../Database/db_helper.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> history;
  final Function(String) onSelect;

  HistoryScreen({required this.history, required this.onSelect});

  // Function to open link in browser
  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open the link: $url");
    }
  }

  // Confirmation dialog to clear history
  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Clear History"),
          content: Text("Are you sure you want to delete all history?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel button
              child: Text("Cancel", style: TextStyle(color: Colors.black87)),
            ),
            TextButton(
              onPressed: () async {
                await DBHelper.clearHistory();
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, "clear"); // Go back to previous screen
              },
              child: Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmClearHistory(context),
            tooltip: "Clear History",
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: DBHelper.getHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No history available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.link, color: Colors.deepPurple),
                title: Text(
                  snapshot.data![index],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                ),
                onTap: () {
                  String selectedUrl = snapshot.data![index];
                  _openLink(selectedUrl); // Open the link in browser
                },
              );
            },
          );
        },
      ),
    );
  }
}
