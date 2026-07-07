<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Ticket extends Model
{
    protected $fillable = [
        'user_id',
        'helpdesk_id',
        'title',
        'description',
        'category',
        'status',
        'priority',
        'finished_at',
    ];

    protected function casts(): array
    {
        return [
            'finished_at' => 'datetime',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function helpdesk()
    {
        return $this->belongsTo(User::class, 'helpdesk_id');
    }

    public function attachments()
    {
        return $this->hasMany(TicketAttachment::class);
    }

    public function histories()
    {
        return $this->hasMany(TicketHistory::class);
    }
}
