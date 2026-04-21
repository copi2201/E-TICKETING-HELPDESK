import 'package:helpdesk_mobile/features/ticket/data/models/ticket_model.dart';

class TicketRepository {
  Future<List<TicketModel>> getTicketList() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      TicketModel(
        id: 1,
        title: 'Internet lab lantai 2 bermasalah',
        description: 'Koneksi internet sering putus saat praktikum berlangsung.',
        category: 'Network',
        status: 'Open',
        priority: 'High',
        createdAt: '2026-04-21 08:30',
        createdBy: 'Andi',
      ),
      TicketModel(
        id: 2,
        title: 'Printer administrasi error',
        description: 'Printer tidak dapat mencetak dokumen PDF.',
        category: 'Hardware',
        status: 'Progress',
        priority: 'Medium',
        createdAt: '2026-04-21 09:10',
        createdBy: 'Budi',
      ),
      TicketModel(
        id: 3,
        title: 'Reset akun email dosen',
        description: 'Dosen lupa password email institusi.',
        category: 'Account',
        status: 'Closed',
        priority: 'Low',
        createdAt: '2026-04-21 10:00',
        createdBy: 'Citra',
      ),
      TicketModel(
        id: 4,
        title: 'Projector ruang seminar tidak menyala',
        description: 'Projector tidak merespon saat dinyalakan.',
        category: 'Hardware',
        status: 'Open',
        priority: 'High',
        createdAt: '2026-04-21 10:30',
        createdBy: 'Dewi',
      ),
      TicketModel(
        id: 5,
        title: 'Akses sistem akademik lambat',
        description: 'Halaman dashboard akademik loading terlalu lama.',
        category: 'System',
        status: 'Progress',
        priority: 'Medium',
        createdAt: '2026-04-21 11:00',
        createdBy: 'Eka',
      ),
    ];
  }
}