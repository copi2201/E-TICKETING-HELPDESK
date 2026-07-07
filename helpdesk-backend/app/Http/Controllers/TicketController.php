<?php

namespace App\Http\Controllers;

use App\Models\Ticket;
use App\Models\TicketHistory;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TicketController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Ticket::with('user:id,name', 'helpdesk:id,name');

        if ($user->role === 'user') {
            $query->where('user_id', $user->id);
        }

        return response()->json($query->latest()->get());
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'category' => 'required|string|max:100',
            'priority' => 'required|in:LOW,MEDIUM,HIGH,URGENT',
            'attachments.*' => 'nullable|file|max:10240',
        ]);

        $data['user_id'] = $request->user()->id;
        $data['status'] = 'OPEN';

        $ticket = Ticket::create($data);

        // Handle file uploads
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $file) {
                $storedPath = $file->store('tickets/' . $ticket->id, 'public');

                $ticket->attachments()->create([
                    'original_name' => $file->getClientOriginalName(),
                    'stored_path' => $storedPath,
                    'mime_type' => $file->getMimeType(),
                    'file_size' => $file->getSize(),
                ]);
            }
        }

        // Create history
        TicketHistory::create([
            'ticket_id' => $ticket->id,
            'user_id' => $request->user()->id,
            'status' => 'OPEN',
            'note' => 'Tiket dibuat',
        ]);

        // Notify admin
        $admins = \App\Models\User::where('role', 'admin')->get();
        foreach ($admins as $admin) {
            UserNotification::create([
                'user_id' => $admin->id,
                'type' => 'ticket_created',
                'title' => 'Tiket baru: ' . $ticket->title,
                'body' => $request->user()->name . ' membuat tiket baru',
                'related_type' => 'ticket',
                'related_id' => $ticket->id,
            ]);
        }

        return response()->json(
            $ticket->load('user:id,name', 'attachments', 'histories'),
            201
        );
    }

    public function show(Request $request, Ticket $ticket)
    {
        return response()->json(
            $ticket->load('user:id,name', 'helpdesk:id,name', 'attachments', 'histories.user:id,name')
        );
    }

    public function assign(Request $request, Ticket $ticket)
    {
        $request->validate([
            'helpdesk_id' => 'required|exists:users,id',
        ]);

        if ($request->user()->role !== 'admin') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $ticket->update([
            'helpdesk_id' => $request->helpdesk_id,
            'status' => 'ASSIGNED',
        ]);

        // History
        TicketHistory::create([
            'ticket_id' => $ticket->id,
            'user_id' => $request->user()->id,
            'status' => 'ASSIGNED',
            'note' => 'Ditugaskan ke helpdesk',
        ]);

        // Notify helpdesk
        $helpdesk = \App\Models\User::find($request->helpdesk_id);
        if ($helpdesk) {
            UserNotification::create([
                'user_id' => $helpdesk->id,
                'type' => 'ticket_assigned',
                'title' => 'Tiket ditugaskan: ' . $ticket->title,
                'body' => 'Tiket telah ditugaskan kepada Anda',
                'related_type' => 'ticket',
                'related_id' => $ticket->id,
            ]);
        }

        // Notify user
        UserNotification::create([
            'user_id' => $ticket->user_id,
            'type' => 'ticket_assigned',
            'title' => 'Tiket #' . $ticket->id . ' sedang ditugaskan',
            'body' => 'Tiket Anda telah ditugaskan ke helpdesk',
            'related_type' => 'ticket',
            'related_id' => $ticket->id,
        ]);

        return response()->json($ticket->load('histories'));
    }

    public function start(Request $request, Ticket $ticket)
    {
        if ($request->user()->role !== 'helpdesk') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $ticket->update(['status' => 'IN_PROGRESS']);

        TicketHistory::create([
            'ticket_id' => $ticket->id,
            'user_id' => $request->user()->id,
            'status' => 'IN_PROGRESS',
            'note' => 'Tiket sedang dikerjakan',
        ]);

        // Notify user
        UserNotification::create([
            'user_id' => $ticket->user_id,
            'type' => 'ticket_progress',
            'title' => 'Tiket #' . $ticket->id . ' sedang diproses',
            'body' => 'Tiket Anda sedang dikerjakan oleh helpdesk',
            'related_type' => 'ticket',
            'related_id' => $ticket->id,
        ]);

        return response()->json($ticket->load('histories'));
    }

    public function close(Request $request, Ticket $ticket)
    {
        $request->validate([
            'note' => 'required|string',
        ]);

        if ($request->user()->role !== 'helpdesk') {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $ticket->update([
            'status' => 'CLOSED',
            'finished_at' => now(),
        ]);

        TicketHistory::create([
            'ticket_id' => $ticket->id,
            'user_id' => $request->user()->id,
            'status' => 'CLOSED',
            'note' => $request->note,
        ]);

        // Notify user
        UserNotification::create([
            'user_id' => $ticket->user_id,
            'type' => 'ticket_closed',
            'title' => 'Tiket #' . $ticket->id . ' telah selesai',
            'body' => 'Tiket Anda telah ditutup: ' . $request->note,
            'related_type' => 'ticket',
            'related_id' => $ticket->id,
        ]);

        return response()->json($ticket->load('histories'));
    }
}
