import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, String>> historyItems = [
    {
      'date': '2024-08-30',
      'details': 'Consultation',
      'result': 'Positive',
      'notes': 'Patient showed improvement.'
    },
    {
      'date': '2024-08-15',
      'details': 'Routine Checkup',
      'result': 'Normal',
      'notes': 'No issues found.'
    },
    {
      'date': '2024-08-15',
      'details': 'Routine Checkup',
      'result': 'Normal',
      'notes': 'No issues found.'
    },
    // Add more items here
  ];

  List<Map<String, String>> filteredItems = [];
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    filteredItems = historyItems; // Initialize with the full list
    searchController = TextEditingController();
    searchController.addListener(() {
      filterItems();
    });
  }

  void filterItems() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = historyItems.where((item) {
        final date = item['date']?.toLowerCase() ?? '';
        final details = item['details']?.toLowerCase() ?? '';
        final result = item['result']?.toLowerCase() ?? '';
        final notes = item['notes']?.toLowerCase() ?? '';
        return date.contains(query) ||
               details.contains(query) ||
               result.contains(query) ||
               notes.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Test History',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF0F0F0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(FontAwesomeIcons.search), // FontAwesome search icon
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ${item['date']}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Details: ${item['details']}',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Result: ${item['result']}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: item['result'] == 'Positive' ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Notes: ${item['notes']}',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
