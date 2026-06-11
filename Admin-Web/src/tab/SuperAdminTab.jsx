import React from 'react';

const SuperAdminTab = ({ superAdmins, user }) => {
  return (
    <div className="card">
      <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Daftar Akun Super Admin ({superAdmins.length})</h2>
      <div className="table-container">
        <table>
          <thead>
            <tr>
              <th>Nama Lengkap</th>
              <th>Email</th>
              <th>Nomor Telepon</th>
              <th>Terdaftar Sejak</th>
            </tr>
          </thead>
          <tbody>
            {superAdmins.map(s => (
              <tr key={s.id}>
                <td>
                  <strong>{s.nama}</strong>
                  {user && s.id === user.id && (
                    <span className="badge badge-success" style={{ marginLeft: '0.5rem' }}>Anda</span>
                  )}
                </td>
                <td>{s.email}</td>
                <td>{s.nomor_telepon || '-'}</td>
                <td>{s.created_at ? new Date(s.created_at).toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' }) : '-'}</td>
              </tr>
            ))}
            {superAdmins.length === 0 && (
              <tr><td colSpan="4" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada akun super admin.</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default SuperAdminTab;
