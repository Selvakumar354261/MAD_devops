import 'package:devops/services/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
 
class SprintOverviewPage extends StatefulWidget {
  SprintOverviewPage({super.key});
 
  @override
  State<SprintOverviewPage> createState() => _SprintOverviewPageState();
}
 
class _SprintOverviewPageState extends State<SprintOverviewPage> {
  Future<void> sprintlist() async {
    try {
      final response = await http.post(
        Uri.parse('https://dev-devops.haroob.com/api/sprintplan-list'),
        headers: {'Content-Type': 'application/json'},
      );
 
      if (response.statusCode == 200) {
      
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
 
 
  final List<int> estimatedTimes = [5, 8, 7, 6]; 
  final List<int> spentTimes = [4, 6, 5, 4];
 
  
  int getTotalEstimatedTime() {
    return estimatedTimes.fold(0, (total, current) => total + current);
  }
 
 
  int getTotalSpentTime() {
    return spentTimes.fold(0, (total, current) => total + current);
  }
 
  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      backgroundColor: isDarkMode? const Color(0xFF1B1F23) : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:  BoxDecoration(
                color: isDarkMode? const Color(0xFF1B1F23) : Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, bottom: 20, top: 5),
                    child: Container(
                      height: 250, 
                      decoration: BoxDecoration(
                        color: isDarkMode? const Color(0xFF1B1F23) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: BarChart(
                        BarChartData(
                          maxY: 10,
                          barGroups:
                              List.generate(estimatedTimes.length, (index) {
                            return BarChartGroupData(
                              x: index, // X-axis index
                              barRods: [
                                BarChartRodData(
                                  toY: estimatedTimes[index].toDouble(),
                                  color: Colors.teal,
                                  width: 14,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                BarChartRodData(
                                  toY: spentTimes[index].toDouble(),
                                  color: Colors.red,
                                  width: 14,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ],
                            );
                          }),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    "${value.toInt()} Hrs",
                                    style:  TextStyle(
                                        color:isDarkMode?   Colors.white : const Color(0xFF1B1F23), fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    'Task ${value.toInt() + 1}',
                                    style:  TextStyle(
                                        color:isDarkMode?   Colors.white : const Color(0xFF1B1F23), fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData:
                              const FlGridData(show: true, drawVerticalLine: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}