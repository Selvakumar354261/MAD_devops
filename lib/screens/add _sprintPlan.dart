import 'dart:convert';
import 'package:devops/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Project1 {
  final int id;
  final String ticketNo;
  final String projectName;
  final int estimationTime;
  String? spentTime;

  Project1({
    required this.id,
    required this.ticketNo,
    required this.projectName,
    required this.estimationTime,
    this.spentTime,
  });
}

class AddSprintPlanScreen extends StatefulWidget {
  const AddSprintPlanScreen({super.key});

  @override
  State<AddSprintPlanScreen> createState() => _AddSprintPlanState();
}
class _AddSprintPlanState extends State<AddSprintPlanScreen> {
  String? selectedSprint;
  String? selectedProject;
  final TextEditingController ticketNumberController = TextEditingController();
  final TextEditingController estimationTimeController =
      TextEditingController();
      final _formKey = GlobalKey<FormState>();
 
  List<Map<String, dynamic>> sprintList = [];
  List<Map<String, dynamic>> projectList = [];
  bool isLoadingSprint = true;
  bool isLoadingProject = true;
 
  String? token;
  @override
  void initState() {
    super.initState();
    fetchSprintList();
    fetchProjectList();
    getUserName();
  }
 
  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('access_token');
    });
    print(token);
  }
 
  Future<void> fetchSprintList() async {
    final url = Uri.parse('https://dev-devops.haroob.com/api/sprint-list');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        setState(() {
          sprintList = (data['sprint'] as List)
              .map((item) => {
                    'id': item['id'],
                    'name': item['name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load sprint list');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching sprint list: $error')),
      );
    } finally {
      setState(() {
        isLoadingSprint = false;
      });
    }
  }
 
  Future<void> fetchProjectList() async {
    final url = Uri.parse('https://dev-devops.haroob.com/api/project-list');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          projectList = (data['projects'] as List)
              .map((item) => {'id': item['id'], 'name': item['project_name']})
              .toList();
        });
      } else {
        throw Exception('Failed to load project list');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching project list: $error')),
      );
    } finally {
      setState(() {
        isLoadingProject = false;
      });
    }
  }
 
  Future<void> submitSprintPlan() async {
    if (selectedSprint == null ||
        selectedProject == null ||
        ticketNumberController.text.isEmpty ||
        estimationTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required."),
        ),
      );
      return;
    }
 
    final url =
        Uri.parse('https://dev-devops.haroob.com/api/create-sprintplan');
    final body = {
      'sprint_id': int.parse(selectedSprint!),
      'project_id': int.parse(selectedProject!),
      'ticket_no': int.parse(ticketNumberController.text),
      'estimation_time': int.parse(estimationTimeController.text),
    };
 
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${token ?? ''}', // Add token to request headers for authentication
        },
        body: json.encode(body),
      );
      if (response.statusCode == 201) {
        Navigator.pop(context, {
          "refresh": true
          // 'sprint': selectedSprint,
          // 'project': body,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit sprint plan: ${response.body}'),
          ),
        );
      }
    } catch (error) {
      print('Error submitting sprint plan: $error');
    }
  }
 

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return isLoadingProject || isLoadingSprint
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor:
                  isDarkMode ? const Color(0xFF1E1E1E) : Colors.whiPte,
              title: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Add Sprint Plan",
                  style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : const Color.fromARGB(255, 37, 39, 39),
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 30,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF1B1F23),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF0F766E),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 404,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                          color: isDarkMode
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),

                              DropdownButtonFormField<String>(
                                dropdownColor: isDarkMode
                                    ? const Color(0xFF121212)
                                    : Colors.grey[200],
                                decoration: InputDecoration(
                                  labelText: "Select Sprint",
                                  labelStyle: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? const Color(0xFF121212)
                                      : Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                value: selectedSprint,
                                items: sprintList
                                    .map((sprint) => DropdownMenuItem<String>(
                                          value: sprint['id'].toString(),
                                          child: Text(
                                            sprint['name'],
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => selectedSprint = value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select a Sprint ';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 15), // Space between fields

                              DropdownButtonFormField<String>(
                                dropdownColor: isDarkMode
                                    ? const Color(0xFF121212)
                                    : Colors.grey[200],
                                decoration: InputDecoration(
                                  labelText: "Select Project",
                                  labelStyle: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? const Color(0xFF121212)
                                      : Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                value: selectedProject,
                                items: projectList
                                    .map((project) => DropdownMenuItem<String>(
                                          value: project['id'].toString(),
                                          child: Text(
                                            project['name'],
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => selectedProject = value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select a Project ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              TextFormField(
                                controller: ticketNumberController,
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Ticket Number",
                                  labelStyle: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? const Color(0xFF121212)
                                      : Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter The Ticket Number ';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 15), // Space between fields

                              TextFormField(
                                controller: estimationTimeController,
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Estimation Time",
                                  labelStyle: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? const Color(0xFF121212)
                                      : Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter The Estimation Time';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Call your submit function only if validation passes
                          submitSprintPlan();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Please fill in all required fields"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Add Sprint Plan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const Text(
                      "Tap above to complete request",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 234, 228, 228)),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
