import React from 'react';
import {
  IconStatLaporan,
  IconStatVerifikasi,
  IconStatKonseling,
  IconStatJadwal
} from './Icons';

const DashboardTab = ({ reports, schedules, sessions, setSelectedReport }) => {
  return (
    <>
      <div className="grid-stats">
        <div className="card stat-card">
          <div className="stat-info">
            <h3>Total Laporan</h3>
            <p>{reports.length}</p>
          </div>
          <div className="stat-icon" style={{ background: 'var(--info-bg)', color: 'var(--info)' }}>
            <IconStatLaporan />
          </div>
        </div>
        <div className="card stat-card">
          <div className="stat-info">
            <h3>Menunggu Verifikasi</h3>
            <p>{reports.filter(r => r.status === 'Menunggu').length}</p>
          </div>
          <div className="stat-icon" style={{ background: 'var(--warning-bg)', color: 'var(--warning)' }}>
            <IconStatVerifikasi />
          </div>
        </div>
        <div className="card stat-card">
          <div className="stat-info">
            <h3>Konseling Aktif</h3>
            <p>{sessions.filter(s => s.status === 'Diterima' || s.status === 'Berlangsung').length}</p>
          </div>
          <div className="stat-icon" style={{ background: 'var(--primary-glow)', color: 'var(--primary)' }}>
            <IconStatKonseling />
          </div>
        </div>
        <div className="card stat-card">
          <div className="stat-info">
            <h3>Slot Jadwal Tersedia</h3>
            <p>{schedules.filter(s => s.status === 'Tersedia').length}</p>
          </div>
          <div className="stat-icon" style={{ background: 'var(--success-bg)', color: 'var(--success)' }}>
            <IconStatJadwal />
          </div>
        </div>
      </div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
        <div className="card">
          <h2 style={{ fontSize: '1.2rem', marginBottom: '1rem' }}>Laporan Terbaru</h2>
          <div className="table-container">
            <table style={{ tableLayout: 'fixed', width: '100%' }}>
              <colgroup>
                <col style={{ width: '20%' }} />
                <col style={{ width: '15%' }} />
                <col style={{ width: '33%' }} />
                <col style={{ width: '10%' }} />
                <col style={{ width: '12%' }} />
                <col style={{ width: '10%' }} />
              </colgroup>
              <thead>
                <tr>
                  <th>Pelapor</th>
                  <th>NIM</th>
                  <th>Judul Laporan</th>
                  <th>Jenis</th>
                  <th>Tanggal</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {reports.slice(0, 5).map(r => (
                  <tr key={r.id} style={{ cursor: 'pointer' }} onClick={() => setSelectedReport(r)}>
                    <td>
                      <strong>{r.pelapor?.nama || 'Mahasiswa'}</strong>
                      <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>{r.pelapor?.nomor_telepon || '-'}</div>
                    </td>
                    <td style={{ whiteSpace: 'normal', wordBreak: 'break-all' }}>{r.pelapor?.profil_mahasiswa?.nim || '-'}</td>
                    <td style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}>{r.judul_pelaporan}</td>
                    <td>{r.jenis_perundungan || '-'}</td>
                    <td>{new Date(r.created_at).toLocaleDateString('id-ID')}</td>
                    <td>
                      <span className={`badge ${r.status === 'Menunggu' ? 'badge-pending' :
                        (r.status === 'Diterima' || r.status === 'Diproses') ? 'badge-process' :
                          r.status === 'Selesai' ? 'badge-success' : 'badge-danger'
                        }`}>{r.status}</span>
                    </td>
                  </tr>
                ))}
                {reports.length === 0 && (
                  <tr><td colSpan="6" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada laporan perundungan.</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        <div className="card">
          <h2 style={{ fontSize: '1.2rem', marginBottom: '1rem' }}>Jadwal Konseling Terdekat</h2>
          <div className="table-container">
            <table>
              <thead>
                <tr>
                  <th>Tanggal</th>
                  <th>Jam</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {schedules.slice(0, 5).map(s => (
                  <tr key={s.id}>
                    <td>{new Date(s.tanggal).toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'short' })}</td>
                    <td>{s.jam_mulai.substring(0, 5)} - {s.jam_selesai.substring(0, 5)}</td>
                    <td>
                      <span className={`badge ${s.status === 'Tersedia' ? 'badge-success' :
                        s.status === 'Penuh' ? 'badge-pending' : 'badge-danger'
                        }`}>{s.status}</span>
                    </td>
                  </tr>
                ))}
                {schedules.length === 0 && (
                  <tr><td colSpan="3" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada jadwal konseling.</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </>
  );
};

export default DashboardTab;
