// lib/screens/dashboard/parent_dashboard.dart
import 'package:flutter/material.dart';
import '../../widgets/logout_util.dart'; // if you moved it here

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            // onPressed: () => handleLogout(context),
            onPressed: () => confirmLogout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}
// // lib/screens/admin/admin_dashboard_screen.dart
// import 'package:flutter/material.dart';
// import 'package:saferoute/screens/admin/manage_routes_screen.dart';
// import 'package:saferoute/screens/admin/assignments_screen.dart';
// import 'package:saferoute/screens/admin/realtime_map_screen.dart';
// import 'package:saferoute/screens/admin/reports_screen.dart';
// import 'package:saferoute/screens/admin/emergency_broadcast_screen.dart';

// class AdminDashboardScreen extends StatelessWidget {
//   const AdminDashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Dashboard')),
//       body: GridView.count(
//         padding: const EdgeInsets.all(20),
//         crossAxisCount: 2,
//         children: const [
//           _DashboardCard(
//             'Manage Routes',
//             Icons.alt_route,
//             ManageRoutesScreen(),
//           ),
//           _DashboardCard(
//             'Assign Buses',
//             Icons.assignment_ind,
//             AssignmentsScreen(),
//           ),
//           _DashboardCard('Realtime Map', Icons.map, RealtimeMapScreen()),
//           _DashboardCard('Reports', Icons.bar_chart, ReportsScreen()),
//           _DashboardCard(
//             'Broadcast Alert',
//             Icons.warning,
//             EmergencyBroadcastScreen(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Widget screen;

//   const _DashboardCard(this.title, this.icon, this.screen);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         onTap:
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => screen),
//             ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 40),
//               const SizedBox(height: 10),
//               Text(title),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
