
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Feedback',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FeedbackScreen(),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  List<Map<String, String>> _feedbackList = [];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
    _getCurrentLocation();
  }

  Future<void> _loadFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? feedbackData = prefs.getString('feedback');
    if (feedbackData != null) {
      setState(() {
        _feedbackList = List<Map<String, String>>.from(jsonDecode(feedbackData));
      });
    }
  }

  // Get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle if location services are not enabled
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      // Handle permission denial
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _saveFeedback() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> newFeedback = {
        'name': _nameController.text,
        'email': _emailController.text,
        'message': _messageController.text,
        'location': _currentPosition != null
            ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}'
            : 'Location not available',
      };

      setState(() {
        _feedbackList.add(newFeedback);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('feedback', jsonEncode(_feedbackList));

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Feedback submitted successfully!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Feedback Message',
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your feedback message';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveFeedback,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _feedbackList.isEmpty
                  ? Center(child: Text('No feedback submitted yet.'))
                  : ListView.builder(
                      itemCount: _feedbackList.length,
                      itemBuilder: (context, index) {
                        final feedback = _feedbackList[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(feedback['name'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(feedback['email'] ?? ''),
                                SizedBox(height: 4.0),
                                Text(feedback['message'] ?? ''),
                                SizedBox(height: 4.0),
                                Text('Location: ${feedback['location']}'),
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
}
