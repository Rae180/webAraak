import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeNaame = '/dashboard_screen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}





// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// // Define classes at the top to ensure visibility
// class Activity {
//   final String title;
//   final String subtitle;
//   final String time;
//   final IconData icon;
//   final Color color;

//   Activity(this.title, this.subtitle, this.time, this.icon, this.color);
// }

// class RevenueData {
//   final DateTime date;
//   final double amount;
//   RevenueData(this.date, this.amount);
// }

// class ResourceData {
//   final String type;
//   final int count;
//   final Color color;
//   ResourceData(this.type, this.count, this.color);
// }

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _buildSummaryCards(),
//           const SizedBox(height: 24),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: _buildRevenueChart(),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildResourceChart(),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           _buildRecentActivity(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCards() {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 4,
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       childAspectRatio: 2.5,
//       children: [
//         _summaryCard('Total Rooms', '24', Icons.room, Colors.blue),
//         _summaryCard('Active Items', '156', Icons.chair, Colors.green),
//         _summaryCard('Sub-Galleries', '8', Icons.business, Colors.amber),
//         _summaryCard('Active Users', '1,248', Icons.people, Colors.purple),
//         _summaryCard(
//             'Revenue (30d)', '\$24,560', Icons.attach_money, Colors.teal),
//         _summaryCard('Orders', '324', Icons.shopping_cart, Colors.orange),
//         _summaryCard('Reports', '42', Icons.report, Colors.red),
//         _summaryCard('Satisfaction', '92%', Icons.emoji_emotions, Colors.pink),
//       ],
//     );
//   }

//   Widget _summaryCard(String title, String value, IconData icon, Color color) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: color),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRevenueChart() {
//     final revenueData = [
//       RevenueData(DateTime(2023, 1), 12),
//       RevenueData(DateTime(2023, 2), 15),
//       RevenueData(DateTime(2023, 3), 18),
//       RevenueData(DateTime(2023, 4), 16),
//       RevenueData(DateTime(2023, 5), 22),
//       RevenueData(DateTime(2023, 6), 25),
//       RevenueData(DateTime(2023, 7), 28),
//       RevenueData(DateTime(2023, 8), 24),
//       RevenueData(DateTime(2023, 9), 26),
//       RevenueData(DateTime(2023, 10), 29),
//       RevenueData(DateTime(2023, 11), 27),
//       RevenueData(DateTime(2023, 12), 30),
//     ];

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Revenue Overview',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 300,
//               child: SfCartesianChart(
//                 primaryXAxis: DateTimeAxis(
//                     intervalType: DateTimeIntervalType.months,
//                     dateFormat: DateFormat.MMM(),
//                     title: AxisTitle(text: 'Month')),
//                 primaryYAxis: NumericAxis(
//                     title: AxisTitle(text: 'Amount (k USD)'),
//                     numberFormat:
//                         NumberFormat.simpleCurrency(decimalDigits: 0)),
//                 // Fixed: Use CartesianSeries instead of ChartSeries
//                 series: <CartesianSeries>[
//                   LineSeries<RevenueData, DateTime>(
//                     dataSource: revenueData,
//                     xValueMapper: (RevenueData data, _) => data.date,
//                     yValueMapper: (RevenueData data, _) => data.amount,
//                     color: Colors.blue,
//                     width: 3,
//                     markerSettings: const MarkerSettings(isVisible: true),
//                   )
//                 ],
//                 tooltipBehavior: TooltipBehavior(enable: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResourceChart() {
//     final resourceData = [
//       ResourceData('Rooms', 24, Colors.blue),
//       ResourceData('Items', 156, Colors.green),
//       ResourceData('Models', 87, Colors.amber),
//     ];

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Resource Distribution',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 300,
//               child: SfCircularChart(
//                 series: <CircularSeries>[
//                   PieSeries<ResourceData, String>(
//                     dataSource: resourceData,
//                     xValueMapper: (ResourceData data, _) => data.type,
//                     yValueMapper: (ResourceData data, _) => data.count,
//                     pointColorMapper: (ResourceData data, _) => data.color,
//                     dataLabelSettings: const DataLabelSettings(
//                       isVisible: true,
//                       labelPosition: ChartDataLabelPosition.outside,
//                       textStyle: TextStyle(fontSize: 12),
//                     ),
//                     explode: true,
//                     explodeIndex: 0,
//                   )
//                 ],
//                 legend: Legend(
//                     isVisible: true,
//                     position: LegendPosition.bottom,
//                     overflowMode: LegendItemOverflowMode.wrap),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentActivity() {
//     final activities = [
//       Activity('New Order', 'User: John Doe', '2 min ago', Icons.shopping_cart,
//           Colors.green),
//       Activity('Room Added', 'Modern Living Room', '1 hour ago', Icons.room,
//           Colors.blue),
//       Activity('Report Submitted', 'Broken 3D model', '3 hours ago',
//           Icons.report, Colors.red),
//       Activity('New Sub-Gallery', 'Berlin Showroom', '5 hours ago',
//           Icons.business, Colors.amber),
//       Activity('User Registered', 'sarah@example.com', 'Yesterday',
//           Icons.person_add, Colors.purple),
//     ];

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Recent Activity',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: activities.length,
//               separatorBuilder: (context, index) => const Divider(),
//               itemBuilder: (context, index) {
//                 final activity = activities[index];
//                 return ListTile(
//                   leading: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: activity.color.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(activity.icon, color: activity.color),
//                   ),
//                   title: Text(activity.title),
//                   subtitle: Text(activity.subtitle),
//                   trailing: Text(
//                     activity.time,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }