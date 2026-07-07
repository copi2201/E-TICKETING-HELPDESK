class TicketHistory {
  final int id;
  final String status;
  final String? note;
  final String changedBy;
  final String createdAt;

  const TicketHistory({
    required this.id,
    required this.status,
    this.note,
    required this.changedBy,
    required this.createdAt,
  });

  factory TicketHistory.fromJson(Map<String, dynamic> json) {
    return TicketHistory(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      note: json['note'],
      changedBy:
      json['user']?['name'] ??
          json['changed_by']?.toString() ??
          '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'note': note,
      'changed_by': changedBy,
      'created_at': createdAt,
    };
  }
}

class TicketModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String priority;

  final String createdAt;
  final String createdBy;

  final String? assignedTo;
  final String? finishedAt;

  /// Path attachment dari Laravel
  final String? attachment;

  final List<TicketHistory> histories;

  const TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.createdBy,
    this.assignedTo,
    this.finishedAt,
    this.attachment,
    this.histories = const [],
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    final historyList =
        (json['histories'] as List<dynamic>?)
            ?.map((e) => TicketHistory.fromJson(e))
            .toList() ??
            [];

    return TicketModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      createdAt: json['created_at'] ?? '',
      createdBy: json['user']?['name'] ?? '',
      assignedTo: json['helpdesk']?['name'],
      finishedAt: json['finished_at'],
      attachment: json['attachment'],
      histories: historyList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'priority': priority,
      'created_at': createdAt,
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'finished_at': finishedAt,
      'attachment': attachment,
      'histories': histories.map((e) => e.toJson()).toList(),
    };
  }

  TicketModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    String? createdAt,
    String? createdBy,
    String? assignedTo,
    String? finishedAt,
    String? attachment,
    List<TicketHistory>? histories,
  }) {
    return TicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      assignedTo: assignedTo ?? this.assignedTo,
      finishedAt: finishedAt ?? this.finishedAt,
      attachment: attachment ?? this.attachment,
      histories: histories ?? this.histories,
    );
  }

  /// URL lengkap attachment
  String? get attachmentUrl {
    if (attachment == null || attachment!.isEmpty) return null;
    return 'http://127.0.0.1:8000/storage/$attachment';
  }
}