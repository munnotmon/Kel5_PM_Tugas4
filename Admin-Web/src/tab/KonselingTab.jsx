import React from 'react';

const KonselingTab = ({
  sessions,
  handleUpdateSessionStatus,
  startChatSession,
  setSelectedSession
}) => {
  // Saring hanya sesi konseling (bukan laporan)
  const counselingSessions = sessions.filter(s => s.tipe !== 'laporan');

  // Urutkan secara kronologis berdasarkan ID (ascending) untuk menghitung nomor antrian secara berurutan
  const sortedChronologically = [...counselingSessions].sort((a, b) => a.id - b.id);

  // Beri nomor antrian Q-1, Q-2, Q-3 dst. berdasarkan urutan masuknya
  const sessionsWithQueue = sortedChronologically.map((s, index) => ({
    ...s,
    displayQueueNumber: index + 1
  }));

  // Urutkan ulang agar yang terbaru (antrian tertinggi) berada di paling atas
  const finalSessions = [...sessionsWithQueue].sort((a, b) => b.id - a.id);

  return (
    <div className="card">
      <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Pengajuan & Sesi Konseling</h2>
      <div className="table-container">
        <table>
          <thead>
            <tr>
              <th>Antrian</th>
              <th>Mahasiswa</th>
              <th>Tanggal & Waktu</th>
              <th>Keluhan</th>
              <th>Konselor</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {finalSessions.map(s => (
              <tr key={s.id}>
                <td style={{ fontWeight: '700', color: 'var(--primary)' }}>Q-{s.displayQueueNumber}</td>
                <td>
                  <strong>{s.mahasiswa?.nama || 'Mahasiswa'}</strong>
                  <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>NIM: {s.mahasiswa?.profil_mahasiswa?.nim || '-'}</div>
                </td>
                <td>
                  {s.jadwal_konseling ? (
                    <>
                      <div>{new Date(s.jadwal_konseling.tanggal).toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })}</div>
                      <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>{s.jadwal_konseling.jam_mulai.substring(0, 5)} - {s.jadwal_konseling.jam_selesai.substring(0, 5)}</div>
                    </>
                  ) : 'Jadwal dihapus'}
                </td>
                <td><div style={{ maxWidth: '200px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }} title={s.keluhan}>{s.keluhan || '-'}</div></td>
                <td>{s.admin?.nama || 'Belum ditugaskan'}</td>
                <td>
                  <span className={`badge ${s.status === 'Diajukan' ? 'badge-pending' :
                    s.status === 'Diterima' ? 'badge-process' :
                      s.status === 'Berlangsung' ? 'badge-process' :
                        s.status === 'Selesai' ? 'badge-success' : 'badge-danger'
                    }`}>{s.status}</span>
                </td>
                <td>
                  <div style={{ display: 'flex', gap: '0.4rem', flexWrap: 'wrap' }}>
                    {s.status === 'Diajukan' && (
                      <button className="btn btn-primary btn-sm" onClick={() => handleUpdateSessionStatus(s.id, 'Diterima')}>Terima</button>
                    )}
                    {s.status === 'Diterima' && (
                      <>
                        <button className="btn btn-primary btn-sm" onClick={() => handleUpdateSessionStatus(s.id, 'Berlangsung')}>Mulai Sesi</button>
                        <button className="btn btn-secondary btn-sm" onClick={() => startChatSession(s)}>Chat</button>
                      </>
                    )}
                    {s.status === 'Berlangsung' && (
                      <>
                        <button className="btn btn-primary btn-sm" onClick={() => handleUpdateSessionStatus(s.id, 'Selesai')}>Selesai</button>
                        <button className="btn btn-secondary btn-sm" onClick={() => startChatSession(s)}>Chat</button>
                      </>
                    )}
                    <button className="btn btn-secondary btn-sm" onClick={() => setSelectedSession(s)}>Detail</button>
                  </div>
                </td>
              </tr>
            ))}
            {finalSessions.length === 0 && (
              <tr><td colSpan="7" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada pengajuan konseling.</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default KonselingTab;
