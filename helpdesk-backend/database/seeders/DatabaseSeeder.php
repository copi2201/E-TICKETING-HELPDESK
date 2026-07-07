<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    public function run(): void
    {
        User::create([
            'name' => 'Admin Helpdesk',
            'email' => 'admin@kampus.ac.id',
            'password' => bcrypt('password'),
            'role' => 'admin',
        ]);

        User::create([
            'name' => 'Staff Helpdesk',
            'email' => 'helpdesk@kampus.ac.id',
            'password' => bcrypt('password'),
            'role' => 'helpdesk',
        ]);

        User::create([
            'name' => 'Pengguna',
            'email' => 'user@kampus.ac.id',
            'password' => bcrypt('password'),
            'role' => 'user',
        ]);
    }
}
