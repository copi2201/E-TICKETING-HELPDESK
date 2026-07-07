import 'package:flutter/material.dart';
import 'package:helpdesk_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:helpdesk_mobile/features/ticket/data/models/ticket_model.dart';
import 'package:helpdesk_mobile/features/ticket/data/repositories/ticket_repository.dart';
import 'package:helpdesk_mobile/features/ticket/presentation/pages/create_ticket_page.dart';
import 'package:helpdesk_mobile/features/ticket/presentation/pages/ticket_detail_page.dart';

class TicketListPage extends StatefulWidget {
  final UserRole role;

  // TODO: ganti dengan nama/ID user yang sedang login (dari auth/session)
  final String currentUserName;

  const TicketListPage({
    super.key,
    required this.role,
    this.currentUserName = 'User',
  });

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final _repository = TicketRepository();
  List<TicketModel> _tickets = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tickets = await _repository.getTicketList();
      if (!mounted) return;
      setState(() {
        _tickets = tickets;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  String get _pageTitle {
    switch (widget.role) {
      case UserRole.admin:
        return 'Semua Tiket';
      case UserRole.helpdesk:
        return 'Tiket Saya';
      case UserRole.user:
        return 'Tiket Saya';
    }
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateTicketPage()),
    );

    if (result == true) {
      _loadTickets();
    }
  }

  Future<void> _navigateToDetail(TicketModel ticket) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketDetailPage(ticketId: ticket.id),
      ),
    );

    // Always refresh after returning from detail
    // because actions (assign/start/close) may have changed status
    _loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTickets,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.cloud_off,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _loadTickets,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : _tickets.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const Center(
                              child: Text('Belum ada data tiket'),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = _tickets[index];
                          final statusColor = _getStatusColor(ticket.status);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ticket.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.10),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        ticket.status,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  ticket.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                ),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _InfoChip(label: ticket.category),
                                    _InfoChip(label: ticket.priority),
                                    _InfoChip(label: 'By ${ticket.createdBy}'),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule_outlined,
                                      size: 16,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      ticket.createdAt,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () =>
                                          _navigateToDetail(ticket),
                                      child: const Text('Detail'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: widget.role == UserRole.user
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreate,
              backgroundColor: const Color(0xFF111827),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Buat Tiket'),
            )
          : null,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return const Color(0xFFEA580C);
      case 'ASSIGNED':
        return const Color(0xFF0EA5E9);
      case 'IN_PROGRESS':
        return const Color(0xFF4F46E5);
      case 'CLOSED':
        return const Color(0xFF059669);
      default:
        return Colors.grey;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
}