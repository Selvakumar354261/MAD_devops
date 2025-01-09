// import 'package:devops/screens/add%20_sprintPlan.dart';
// import 'package:devops/screens/login.dart';
// import 'package:devops/services/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:devops/screens/home/dashboard.dart';
// import 'package:devops/screens/home/sprint_barChart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SprintDashboard extends StatefulWidget {
//   const SprintDashboard({super.key});

//   @override
//   State<SprintDashboard> createState() => _SprintDashboardState();
// }

// class _SprintDashboardState extends State<SprintDashboard> {
//   final PageController _pageController = PageController(initialPage: 0);
//   int _currentPage = 0;

//   Future<void> sprintlist() async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://dev-devops.haroob.com/api/sprintplan-list'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//       } else {}
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     }
//   }

//   final List<int> estimatedTimes = [5, 8, 7, 6];
//   final List<int> spentTimes = [4, 6, 5, 4];

//   int getTotalEstimatedTime() {
//     return estimatedTimes.fold(0, (total, current) => total + current);
//   }

//   int getTotalSpentTime() {
//     return spentTimes.fold(0, (total, current) => total + current);
//   }

  // void _showLogoutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       final themeProvider = Provider.of<ThemeProvider>(context);
  //       final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
  //       return AlertDialog(
  //         backgroundColor:
  //             isDarkMode ? const Color.fromARGB(255, 44, 44, 45) : Colors.white,
  //         title: Text(
  //           'Confirm Logout',
  //           style: TextStyle(
  //               color: isDarkMode ? Colors.white : const Color(0xFF1B1F23)),
  //         ),
  //         content: Text('Are you sure you want to log out?',
  //             style: TextStyle(
  //                 color: isDarkMode ? Colors.white : const Color(0xFF1B1F23))),
  //         actions: <Widget>[
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('Cancel',
  //                   style: TextStyle(
  //                       color: isDarkMode
  //                           ? Colors.white
  //                           : const Color(0xFF1B1F23)))),
  //           TextButton(
  //             onPressed: () async {
  //               SharedPreferences prefs = await SharedPreferences.getInstance();
  //               await prefs.setBool('isLoggedIn', false);
  //               await prefs.remove('email');
  //               await prefs.remove('password');
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => const LoginScreen()),
  //               );
  //             },
  //             child: const Text(
  //               'Logout',
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
//     return Scaffold(
//       backgroundColor: isDarkMode ? const Color(0xFF1B1F23) : Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Welcome Ajith",
//                     style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: isDarkMode
//                             ? Colors.white
//                             : const Color(0xFF1B1F23)),
//                   ),
//                   Row(
//                     children: [
//                       Tooltip(
//                         message: themeProvider.themeMode == ThemeMode.light
//                             ? 'Switch to Dark Mode'
//                             : 'Switch to Light Mode',
//                         child: IconButton(
//                           icon: Icon(
//                             themeProvider.themeMode == ThemeMode.light
//                                 ? Icons.dark_mode
//                                 : Icons.light_mode,
//                           ),
//                           onPressed: () {
//                             themeProvider.toggleTheme();
//                             final snackBarMessage =
//                                 themeProvider.themeMode == ThemeMode.light
//                                     ? 'Switched to Light Mode'
//                                     : 'Switched to Dark Mode';
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Center(
//                                   child: Text(
//                                     snackBarMessage,
//                                     style: TextStyle(
//                                         color: isDarkMode
//                                             ? const Color(0xFF1B1F23)
//                                             : Colors.white),
//                                   ),
//                                 ),
//                                 behavior: SnackBarBehavior.floating,
//                                 margin: const EdgeInsets.only(
//                                     bottom: 5, left: 30, right: 30),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 backgroundColor: themeProvider.themeMode ==
//                                         ThemeMode.light
//                                     ? const Color.fromARGB(255, 241, 235, 235)
//                                     : Colors.black,
//                                 duration: const Duration(seconds: 1),
//                                 elevation: 0,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.logout),
//                         onPressed: () async {
//                           _showLogoutDialog(context);
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 150,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isDarkMode
//                           ? const Color.fromARGB(255, 45, 50, 55)
//                           : const Color.fromARGB(255, 241, 235, 235),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Total Est Time",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 color: isDarkMode
//                                     ? Colors.white70
//                                     : const Color(0xFF1B1F23))),
//                         const SizedBox(height: 8),
//                         Text("${getTotalEstimatedTime()} ",
//                             style: const TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.teal)),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: 150,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isDarkMode
//                           ? const Color.fromARGB(255, 45, 50, 55)
//                           : const Color.fromARGB(255, 241, 235, 235),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Total Spent Time",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: isDarkMode
//                                   ? Colors.white70
//                                   : const Color(0xFF1B1F23),
//                             )),
//                         const SizedBox(height: 8),
//                         Text("${getTotalSpentTime()} ",
//                             style: const TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.red)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//             // Navigation Dots
//             Container(
//               decoration: BoxDecoration(
//                 color: isDarkMode
//                     ? const Color.fromARGB(255, 36, 37, 38)
//                     : const Color.fromARGB(255, 241, 235, 235),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(21),
//                   topRight: Radius.circular(21),
//                 ),
//               ),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         IconButton(
//                           iconSize: 19,
//                           onPressed: () {},
//                           icon: const Icon(Icons.arrow_back),
//                           color: isDarkMode
//                               ? Colors.white70
//                               : const Color(0xFF1B1F23),
//                         ),
//                         Text(
//                           " Sprint 36",
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                             color: isDarkMode
//                                 ? Colors.white70
//                                 : const Color(0xFF1B1F23),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 9, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: isDarkMode
//                               ? const Color(0xFF1B1F23)
//                               : Colors.white70,
//                           border: Border.all(
//                             color: isDarkMode
//                                 ? const Color(0xFF1B1F23)
//                                 : Colors.white70,
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                                 color: isDarkMode
//                                     ? const Color(0xFF1B1F23)
//                                     : Colors.white70.withOpacity(0.3),
//                                 spreadRadius: 2,
//                                 blurStyle: BlurStyle.inner,
//                                 blurRadius: 3,
//                                 offset: const Offset(0, 1)),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 _pageController.animateToPage(
//                                   0,
//                                   duration: const Duration(milliseconds: 300),
//                                   curve: Curves.easeInOut,
//                                 );
//                               },
//                               child: Icon(
//                                 Icons.circle,
//                                 color: _currentPage == 0
//                                     ? Colors.teal
//                                     : Colors.white70,
//                                 size: 10,
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 _pageController.animateToPage(
//                                   1,
//                                   duration: const Duration(milliseconds: 300),
//                                   curve: Curves.easeInOut,
//                                 );
//                               },
//                               child: Icon(
//                                 Icons.circle,
//                                 color: _currentPage == 1
//                                     ? Colors.teal
//                                     : Colors.white70,
//                                 size: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ]),
//             ),

//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (int page) {
//                   setState(() {
//                     _currentPage = page;
//                   });
//                 },
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   SprintDashboardPage(
//                     sprint: [],
//                   ),
//                   SprintOverviewPage(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//            final res = await Navigator.push(context,
//               MaterialPageRoute(builder: (context) => AddSprintPlanScreen()));
//               if(res['refresh']){
//                 // Call get sprint plan list method
//               }
//         },
//         backgroundColor: Colors.teal,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Icon(
//           Icons.add,
//           color: isDarkMode ? const Color(0xFF1B1F23) : Colors.white70,
//           size: 30,
//         ),
//       ),
//     );a
//   }
// }

// import 'package:devops/screens/login.dart';
// import 'package:devops/services/services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// void main() {
//   runApp(FeedbackApp());
// }

// class FeedbackApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'User Feedback',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: FeedbackScreen(),
//     );
//   }
// }

// class FeedbackScreen extends StatefulWidget {
//   @override
//   _FeedbackScreenState createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();

//   List<Map<String, String>> _feedbackList = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadFeedback();
//   }

//   Future<void> _loadFeedback() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? feedbackData = prefs.getString('feedback');
//     if (feedbackData != null) {
//       setState(() {
//         _feedbackList = List<Map<String, String>>.from(jsonDecode(feedbackData));
//       });
//     }
//   }

//   Future<void> _saveFeedback() async {
//     if (_formKey.currentState!.validate()) {
//       Map<String, String> newFeedback = {
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'message': _messageController.text,
//       };

//       setState(() {
//         _feedbackList.add(newFeedback);
//       });

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('feedback', jsonEncode(_feedbackList));

//       _nameController.clear();
//       _emailController.clear();
//       _messageController.clear();

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Feedback submitted successfully!'),
//       ));
//     }
//   }
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final themeProvider = Provider.of<ThemeProvider>(context);
//         final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
//         return AlertDialog(
//           backgroundColor:
//               isDarkMode ? const Color.fromARGB(255, 44, 44, 45) : Colors.white,
//           title: Text(
//             'Confirm Logout',
//             style: TextStyle(
//                 color: isDarkMode ? Colors.white : const Color(0xFF1B1F23)),
//           ),
//           content: Text('Are you sure you want to log out?',
//               style: TextStyle(
//                   color: isDarkMode ? Colors.white : const Color(0xFF1B1F23))),
//           actions: <Widget>[
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel',
//                     style: TextStyle(
//                         color: isDarkMode
//                             ? Colors.white
//                             : const Color(0xFF1B1F23)))),
//             TextButton(
//               onPressed: () async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 await prefs.setBool('isLoggedIn', false);
//                 await prefs.remove('email');
//                 await prefs.remove('password');
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                 );
//               },
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Feedback'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(labelText: 'Name'
//                     ,),
                    
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(labelText: 'Email'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _messageController,
//                     decoration: InputDecoration(labelText: 'Feedback Message'),
//                     maxLines: 3,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your feedback message';
//                       }
//                       return null;
//                     },
//                   ),
//                   IconButton(
//                         icon: const Icon(Icons.logout),                        onPressed: () async {
//                           _showLogoutDialog(context);
//                        },
//                  ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: _saveFeedback,
//                     child: Text('Submit'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Expanded(
//               child: _feedbackList.isEmpty
//                   ? Center(child: Text('No feedback submitted yet.'))
//                   : ListView.builder(
//                       itemCount: _feedbackList.length,
//                       itemBuilder: (context, index) {
//                         final feedback = _feedbackList[index];
//                         return Card(
//                           margin: EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             title: Text(feedback['name'] ?? ''),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(feedback['email'] ?? ''),
//                                 SizedBox(height: 4.0),
//                                 Text(feedback['message'] ?? ''),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
