// import 'dart:convert';
// import 'package:devops/dashboard_api/dashboard_api.dart';
// import 'package:devops/screens/add%20_sprintPlan.dart';
// import 'package:devops/screens/login.dart';
// import 'package:devops/services/services.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SprintDashboardPage extends StatefulWidget {
//   final List<SprintPlan> sprint;

//   SprintDashboardPage({super.key, required this.sprint});

//   @override
//   State<SprintDashboardPage> createState() => _SprintDashboardPageState();
// }

// class _SprintDashboardPageState extends State<SprintDashboardPage> {
//   int? selectedSprintId;
//   List<SprintPlan> filteredSprintPlans = [];
//   List<SprintPlan> sprintPlans = [];
//   List<Project> project = [];
//   bool isLoading = false;
//   String? errorMessage;
//   double totalEstimationTime = 0.0;
//   double totalSpentTime = 0.0;
//   String userId = '';
//   String? userName;
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     sprintPlanList();
//     getUserName();
//     projectlist();
//   }

//   Future<void> getUserName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       token = prefs.getString('access_token');
//     });
//     print(token);
//   }

//   String getProjectName(String? projectId) {
//     Project? matchedProject;
//     for (int i = 0; i < project.length; i++) {
//       if (project[i].id.toString() == projectId) {
//         matchedProject = project[i];
//         break;
//       }
//     }
//     return matchedProject?.projectName ?? "Unknown";
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
//                   MaterialPageRoute(builder: (context) =>  const LoginScreen()),
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

//   Future<void> projectlist() async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://dev-devops.haroob.com/api/project-list'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data != null) {
//           final parsedData = Welcome1.fromJson(data);
//           if (parsedData.projects != null && parsedData.projects!.isNotEmpty) {
//             setState(() {
//               project = parsedData.projects!;
//             });
//           } else {
//             setState(() {
//               errorMessage = "No projects available.";
//             });
//           }
//         } else {
//           setState(() {
//             errorMessage = "Response data is null.";
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage =
//               "Failed to fetch project list. Status: ${response.statusCode}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "An error occurred: $e";
//       });
//     }
//   }

//   Future<void> sprintPlanList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString('userID')!;

//     try {
//       final response = await http.post(
//         Uri.parse('https://dev-devops.haroob.com/api/sprintplan-list'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${token ?? ''}'
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data != null) {
//           final parsedData = Welcome.fromJson(data);

//           if (parsedData.sprintPlans.isNotEmpty) {
//             setState(() {
//               // Filter sprint plans for the current user
//               sprintPlans = parsedData.sprintPlans
//                   .where((sprint) => sprint.userId == int.parse(userId))
//                   .toList();

//               userName = sprintPlans[0].user!.firstName!;

//               totalEstimationTime = _calculateTotalTime(
//                 sprintPlans,
//                 (sprint) => sprint.estimationTime,
//               );
//               totalSpentTime = _calculateTotalTime(
//                 sprintPlans,
//                 (sprint) => sprint.spentTime,
//               );
//               selectedSprintId = sprintPlans.first.sprintId;
//               filteredSprintPlans =
//                   _filterSprintPlansBySprintId(selectedSprintId!);
//               errorMessage = null;
//             });
//           } else {
//             setState(() {
//               errorMessage = "No sprint plans available.";
//             });
//           }
//         } else {
//           setState(() {
//             errorMessage = "Response data is null.";
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage =
//               "Failed to fetch sprint plans. Status: ${response.statusCode}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = "An error occurred: $e";
//       });
//     } finally {
//       setState(() {
//         isLoading = true;
//       });
//     }
//   }

//   List<SprintPlan> _filterUserSprintPlans(List<SprintPlan> plans) {
//     return plans.where((sprint) => sprint.userId == int.parse(userId)).toList();
//   }

//   List<SprintPlan> _filterSprintPlansBySprintId(int sprintId) {
//     return sprintPlans.where((plan) => plan.sprintId == sprintId).toList();
//   }

//   double _calculateTotalTime(
//     List<SprintPlan> plans,
//     String? Function(SprintPlan) timeExtractor,
//   ) {
//     return plans.fold(
//       0.0,
//       (sum, sprint) =>
//           sum + (double.tryParse(timeExtractor(sprint) ?? '0') ?? 0.0),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
//     // Group sprint plans by sprintId
//     final groupedSprintPlans = sprintPlans.fold<Map<int, List<SprintPlan>>>(
//       {},
//       (grouped, sprint) {
//         if (sprint.sprintId != null) {
//           grouped[sprint.sprintId!] = grouped[sprint.sprintId!] ?? [];
//         }
//         grouped[sprint.sprintId]!.add(sprint);
//         return grouped;
//       },
//     );
//     return Scaffold(
//       backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
//       body: SafeArea(
//         child: isLoading
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "loading...",
//                       style: TextStyle(
//                         color:
//                             isDarkMode ? Colors.white : const Color(0xFF1E1E1E),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const CircularProgressIndicator(
//                       color: Colors.teal,
//                     ),
//                   ],
//                 ),
//               )
//             : errorMessage != null
//                 ? Center(
//                     child: Text(
//                       errorMessage!,
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                     ),
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.only(
//                               left: 17, top: 10, bottom: 15),
//                           child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Welcome $userName!",
//                                       style: TextStyle(
//                                         fontSize: 25,
//                                         fontWeight: FontWeight.bold,
//                                         color: isDarkMode
//                                             ? Colors.white
//                                             : const Color(0xFF1E1E1E),
//                                       ),
//                                     ),
//                                     PopupMenuButton<int>(
                                    
//                                       icon: Icon(
//                                         Icons.menu,
//                                         color: isDarkMode
//                                             ? Colors.white
//                                             : const Color(0xFF1E1E1E),
//                                       ),
                                      
//                                       onSelected: (value) {
//                                         if (value == 0) {
//                                           // Switch theme mode
//                                           themeProvider.toggleTheme();
//                                           final snackBarMessage =
//                                               themeProvider.themeMode ==
//                                                       ThemeMode.light
//                                                   ? 'Switched to Light Mode'
//                                                   : 'Switched to Dark Mode';
                                                  
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             SnackBar(
//                                               content: Text(snackBarMessage),
//                                               duration:
//                                                   const Duration(seconds: 1),
//                                             ),
//                                           );
//                                         } else if (value == 1) {
//                                           // Logout
//                                           _showLogoutDialog(context);
//                                         }
//                                       },
//                                       itemBuilder: (context) => [
//                                         PopupMenuItem<int>(
                                    
//                                           value: 0,
//                                           child: Row(
//                                             children: [
//                                               Icon(
//                                                 themeProvider.themeMode ==
//                                                         ThemeMode.light
//                                                     ? Icons.dark_mode
//                                                     : Icons.light_mode,
//                                                 color: isDarkMode
//                                                     ? Colors.white
//                                                     : const Color(0xFF1E1E1E),
//                                               ),
//                                               const SizedBox(width: 10),
//                                               Text(
//                                                 themeProvider.themeMode ==
//                                                         ThemeMode.light
//                                                     ? 'Switch to Dark Mode'
//                                                     : 'Switch to Light Mode',
//                                               ),
                                              
//                                             ],
//                                           ),
//                                         ),
//                                         const PopupMenuDivider(),
//                                         const PopupMenuItem<int>(
                                        
//                                           value: 1,
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.logout,
//                                                   color: Colors.red),
//                                               SizedBox(width: 10),
//                                               Text('Logout',
//                                                   style: TextStyle(
//                                                       color: Colors.red)),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ]))),
//                       const SizedBox(height: 10),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Total Estimation Time Card
//                             Container(
//                               width: 150,
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                               color: isDarkMode
//                                     ? const Color.fromARGB(255, 45, 50, 55)
//                                     : const Color.fromARGB(255, 241, 235, 235),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Total Est Time",
//                                       style: TextStyle(
//                                         color: isDarkMode
//                                   ? Colors.white70
//                                   : const Color(0xFF1B1F23),
//                             )),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     "${totalEstimationTime.toStringAsFixed(0)} Hrs", // Remove decimals
//                                     style: const TextStyle(
//                                         fontSize: 28,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.teal),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // Total Spent Time Card
//                             Container(
//                               width: 150,
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: isDarkMode
//                                     ? const Color.fromARGB(255, 45, 50, 55)
//                                     : const Color.fromARGB(255, 241, 235, 235),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Total Spent Time",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: isDarkMode
//                                             ? Colors.white70
//                                             : const Color(0xFF1B1F23),
//                                       )),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     "${totalSpentTime.toStringAsFixed(0)} Hrs", // Remove decimals
//                                     style: const TextStyle(
//                                         fontSize: 28,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.red),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       Container(
//                           width: 360,
//                           decoration:  BoxDecoration(
//                              color: isDarkMode
//                                     ? const Color.fromARGB(255, 45, 50, 55)
//                                     : const Color.fromARGB(255, 241, 235, 235),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(21),
//                               topRight: Radius.circular(21),
//                             ),
//                           ),
//                           child: Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 21, right: 250, top: 10),
//                               child: DropdownButtonFormField<int>(
//                                 decoration: const InputDecoration(
                                  
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 0, vertical: 0),
//                                 ),
//                                 value: selectedSprintId,
//                                 dropdownColor: isDarkMode
//                                     ? const Color.fromARGB(255, 45, 50, 55)
//                                     : Colors.grey[200],
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 16),
//                                 isDense: true,
//                                 icon:  Padding(
//                                   padding: EdgeInsets.zero,
//                                   child: Icon(
//                                     Icons.arrow_drop_down,
//                                     size: 24,
//                                     color: isDarkMode
//                                   ? Colors.white70
//                                   : const Color(0xFF1B1F23),
                            
//                                   ),
//                                 ),
//                                 items: (groupedSprintPlans.keys.toList()
//                                       ..sort()) // Sort sprint IDs in ascending order
//                                     .map((sprintId) => DropdownMenuItem<int>(
//                                           value: sprintId,
//                                           child: Text("Sprint $sprintId",style: TextStyle(  color: isDarkMode
//                                   ? Colors.white70
//                                   : const Color(0xFF1B1F23),
//                             ),),
//                                         ))
//                                     .toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedSprintId = value!;
//                                     filteredSprintPlans =
//                                         _filterSprintPlansBySprintId(
//                                             selectedSprintId!);

//                                     // Recalculate the total estimation and spent time
//                                     totalEstimationTime = _calculateTotalTime(
//                                       filteredSprintPlans,
//                                       (sprint) => sprint.estimationTime,
//                                     );
//                                     totalSpentTime = _calculateTotalTime(
//                                       filteredSprintPlans,
//                                       (sprint) => sprint.spentTime,
//                                     );
//                                   });
//                                 },
//                               ))),
//                       Expanded(
//                         child: Container(
//                           decoration:  BoxDecoration(
//                             color: isDarkMode
//                                     ? const Color.fromARGB(255, 45, 50, 55)
//                                     : const Color.fromARGB(255, 241, 235, 235),
//                           ),
//                           child: Scrollbar(
                            
//                             interactive: true,
//                             thumbVisibility: true,
//                             trackVisibility: true,
//                             thickness: 15,
//                             child: ListView.builder(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 12),
//                               itemCount: filteredSprintPlans.length,
//                               itemBuilder: (context, index) {
//                                 final sprintPlan = filteredSprintPlans[index];
//                                 final ticketNo = sprintPlan.ticketNo ?? "N/A";
//                                 final estimationTime =
//                                     sprintPlan.estimationTime ?? "N/A";
//                                 final spentTime = sprintPlan.spentTime ?? "N/A";
//                                 final status = sprintPlan.status ?? "N/A";
//                                 final projectName =
//                                     getProjectName(sprintPlan.projectId);

//                                 return Container(
//                                   margin: const EdgeInsets.only(bottom: 16),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         margin: const EdgeInsets.only(
//                                             left: 5, right: 12),
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.teal,
//                                         ),
//                                         child: Icon(
//                                           status == "Completed"
//                                               ? Icons.check
//                                               : Icons.info_outline,
//                                           color: Colors.white,
//                                           size: 28,
//                                         ),
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "#$ticketNo",
//                                             style:  TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               color: isDarkMode
//                                   ? Colors.white70
//                                   : const Color(0xFF1B1F23),
                            
//                                             ),
//                                           ),
//                                           Text(
//                                             projectName,
//                                             style:  TextStyle(
//                                                 fontSize: 14,
//                                                 color: isDarkMode
//                                   ? Colors.white70
//                                   : const Color(0xFF1B1F23),
//                                             )
//                                           ),
//                                         ],
//                                       ),
//                                       const Spacer(),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: [
//                                           Text(
//                                             "$estimationTime Hrs",
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.teal,
//                                             ),
//                                           ),
//                                           Text(
//                                             "$spentTime Hrs",
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.red,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final res = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const AddSprintPlanScreen()));
//           if (res['refresh']) {
//             print('refresh' + "${res}");
//             await sprintPlanList();
//             setState(() {});
//           }
//         },
//         backgroundColor: Colors.teal,
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 30,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//     );
//   }
// }
