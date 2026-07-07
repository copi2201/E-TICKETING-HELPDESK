import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';

class DashboardService {
  Future<List<dynamic>> _get(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data');
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, int>> getUserStats() async {
    final tickets = await _get('tickets');
    int total = tickets.length;
    int open = tickets.where((t) => t['status'] == 'OPEN').length;
    int progress =
        tickets.where((t) => t['status'] == 'ASSIGNED' || t['status'] == 'IN_PROGRESS').length;
    int closed = tickets.where((t) => t['status'] == 'CLOSED').length;

    return {
      'total': total,
      'open': open,
      'progress': progress,
      'closed': closed,
    };
  }

  Future<Map<String, int>> getHelpdeskStats() async {
    final tickets = await _get('tickets');
    int open = tickets.where((t) => t['status'] == 'OPEN').length;
    int progress =
        tickets.where((t) => t['status'] == 'ASSIGNED' || t['status'] == 'IN_PROGRESS').length;
    int resolved = tickets.where((t) => t['status'] == 'CLOSED').length;
    int urgent = tickets.where((t) => t['priority'] == 'URGENT').length;

    return {
      'open': open,
      'progress': progress,
      'resolved': resolved,
      'urgent': urgent,
      'pendingAction': open + urgent,
    };
  }

  Future<Map<String, dynamic>> getAdminStats() async {
    final tickets = await _get('tickets');
    final users = await _get('users');

    int totalTickets = tickets.length;
    int openTickets = tickets.where((t) => t['status'] == 'OPEN').length;
    int closedTickets = tickets.where((t) => t['status'] == 'CLOSED').length;
    int totalUsers = users.where((u) => u['role'] == 'user').length;
    int totalHelpdesk = users.where((u) => u['role'] == 'helpdesk').length;

    return {
      'totalTickets': totalTickets,
      'openTickets': openTickets,
      'closedTickets': closedTickets,
      'totalUsers': totalUsers,
      'totalHelpdesk': totalHelpdesk,
    };
  }

  Future<List<dynamic>> getRecentTickets({int limit = 3}) async {
    final tickets = await _get('tickets');
    tickets.sort((a, b) => b['created_at'].toString().compareTo(a['created_at'].toString()));
    return tickets.take(limit).toList();
  }
}
