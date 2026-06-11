import React from 'react';
import { IconKey } from './Icons';

const UsersTab = ({ users, handleResetPasswordPrompt }) => {
  return (
    <div className="card">
      <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Daftar Mahasiswa Terdaftar</h2>
      <div className="table-container">
        <table>
          <thead>
            <tr>
              <th>Nama Lengkap</th>
              <th>NIM</th>
              <th>Email</th>
              <th>Nomor Telepon</th>
              <th style={{ textAlign: 'center' }}>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {users.map(u => (
              <tr key={u.id}>
                <td><strong>{u.nama}</strong></td>
                <td>{u.profil_mahasiswa?.nim || u.nim || '-'}</td>
                <td>{u.email}</td>
                <td>{u.nomor_telepon || '-'}</td>
                <td style={{ textAlign: 'center' }}>
                  <button
                    className="btn btn-secondary btn-sm"
                    onClick={() => handleResetPasswordPrompt(u)}
                    style={{ display: 'inline-flex', alignItems: 'center', gap: '0.25rem', padding: '0.25rem 0.5rem', fontSize: '0.8rem' }}
                  >
                    <IconKey size={12} />
                    <span>Reset Sandi</span>
                  </button>
                </td>
              </tr>
            ))}
            {users.length === 0 && (
              <tr><td colSpan="5" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada mahasiswa yang masuk dalam database.</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default UsersTab;
