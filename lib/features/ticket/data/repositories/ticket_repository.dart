import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/ticket_model.dart';

class TicketRepository {
  //=========================================
  // AUTH HEADER
  //=========================================
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  //=========================================
  // GET LIST TICKET
  //=========================================
  Future<List<TicketModel>> getTicketList() async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/tickets'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => TicketModel.fromJson(e)).toList();
  }

  //=========================================
  // CREATE TICKET
  //=========================================
  Future<void> createTicket({
    required String title,
    required String description,
    required String category,
    required String priority,
    PlatformFile? attachment,
  }) async {
    final headers = await _authHeaders();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/tickets'),
    );

    request.headers.addAll(headers);

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.fields['priority'] = priority;

    if (attachment != null) {
      if (attachment.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'attachment',
            attachment.bytes!,
            filename: attachment.name,
          ),
        );
      } else if (attachment.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachment',
            attachment.path!,
            filename: attachment.name,
          ),
        );
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw Exception(response.body);
    }
  }

  //=========================================
  // DETAIL TICKET
  //=========================================
  Future<TicketModel> getTicketDetail(int ticketId) async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/tickets/$ticketId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return TicketModel.fromJson(jsonDecode(response.body));
  }

  //=========================================
  // ASSIGN
  //=========================================
  Future<void> assignTicket({
    required int ticketId,
    required int helpdeskId,
  }) async {
    final headers = await _authHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}/tickets/$ticketId/assign'),
      headers: headers,
      body: jsonEncode({
        'helpdesk_id': helpdeskId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  //=========================================
  // START
  //=========================================
  Future<void> startTicket(int ticketId) async {
    final headers = await _authHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}/tickets/$ticketId/start'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  //=========================================
  // CLOSE
  //=========================================
  Future<void> closeTicket({
    required int ticketId,
    required String note,
  }) async {
    final headers = await _authHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}/tickets/$ticketId/close'),
      headers: headers,
      body: jsonEncode({
        'note': note,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  //=========================================
  // GET HELPDESK
  //=========================================
  Future<List<Map<String, dynamic>>> getHelpdeskList() async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/users'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List data = jsonDecode(response.body);

    return data
        .map<Map<String, dynamic>>(
          (user) => {
        'id': user['id'],
        'name': user['name'],
      },
    )
        .toList();
  }
}