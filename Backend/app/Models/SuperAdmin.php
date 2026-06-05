<?php

namespace App\Models;

class SuperAdmin extends User
{
    protected $table = 'users';

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $model->role = 'superadmin';
        });

        static::addGlobalScope('role', function ($builder) {
            $builder->where('role', 'superadmin');
        });
    }
}
