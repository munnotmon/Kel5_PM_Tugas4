import React, { useEffect } from 'react';
import { getBuktiUrl } from '../App'; // We will export helper functions like getBuktiUrl from App

const LaporanTab = ({
  reports,
  reportSearchQuery,
  setReportSearchQuery,
  reportCurrentPage,
  setReportCurrentPage,
  setSelectedReport
}) => {
  const reportsPerPage = 10;

  // Reset page to 1 when search query changes
  useEffect(() => {
    setReportCurrentPage(1);
  }, [reportSearchQuery, setReportCurrentPage]);

  const filteredReports = reports.filter(r => {
    const query = reportSearchQuery.toLowerCase();
    const pelaporNama = (r.pelapor?.nama || '').toLowerCase();
    const pelaporNim = (r.pelapor?.profil_mahasiswa?.nim || '').toLowerCase();
    const judul = (r.judul_pelaporan || '').toLowerCase();
    const jenis = (r.jenis_perundungan || '').toLowerCase();
    const lokasi = (r.lokasi || '').toLowerCase();
    const status = (r.status || '').toLowerCase();

    return pelaporNama.includes(query) ||
      pelaporNim.includes(query) ||
      judul.includes(query) ||
      jenis.includes(query) ||
      lokasi.includes(query) ||
      status.includes(query);
  });

  const indexOfLastReport = reportCurrentPage * reportsPerPage;
  const indexOfFirstReport = indexOfLastReport - reportsPerPage;
  const currentReports = filteredReports.slice(indexOfFirstReport, indexOfLastReport);
  const totalPages = Math.ceil(filteredReports.length / reportsPerPage);

  return (
    <div className="card">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.25rem', gap: '1rem', flexWrap: 'wrap' }}>
        <h2 style={{ fontSize: '1.2rem', margin: 0 }}>Daftar Pengaduan Perundungan</h2>
        <div style={{ position: 'relative', width: '300px' }}>
          <input
            type="text"
            placeholder="Cari laporan..."
            value={reportSearchQuery}
            onChange={(e) => setReportSearchQuery(e.target.value)}
            style={{
              width: '100%',
              padding: '0.6rem 1rem 0.6rem 2.5rem',
              borderRadius: '30px',
              border: '1px solid var(--border-color)',
              background: 'rgba(255, 255, 255, 0.05)',
              color: 'var(--text-primary)',
              fontSize: '0.9rem',
              outline: 'none',
              transition: 'border-color 0.2s'
            }}
          />
          <svg
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="var(--text-secondary)"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            style={{ position: 'absolute', left: '1rem', top: '50%', transform: 'translateY(-50%)', pointerEvents: 'none' }}
          >
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
        </div>
      </div>

      <div className="table-container">
        <table style={{ tableLayout: 'fixed', width: '100%' }}>
          <colgroup>
            <col style={{ width: '18%' }} />
            <col style={{ width: '15%' }} />
            <col style={{ width: '30%' }} />
            <col style={{ width: '10%' }} />
            <col style={{ width: '11%' }} />
            <col style={{ width: '10%' }} />
            <col style={{ width: '6%' }} />
          </colgroup>
          <thead>
            <tr>
              <th>Pelapor</th>
              <th>NIM</th>
              <th>Judul Laporan</th>
              <th>Jenis</th>
              <th>Tanggal</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            {currentReports.map(r => (
              <tr key={r.id}>
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
                <td>
                  <div style={{ display: 'flex', gap: '0.4rem' }}>
                    <button className="btn btn-secondary btn-sm" onClick={() => setSelectedReport(r)}>Detail</button>
                  </div>
                </td>
              </tr>
            ))}
            {filteredReports.length === 0 && (
              <tr>
                <td colSpan="7" style={{ textAlign: 'center', color: 'var(--text-secondary)', padding: '2rem' }}>
                  {reportSearchQuery ? 'Tidak ada laporan yang cocok dengan pencarian.' : 'Belum ada laporan perundungan.'}
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination Controls */}
      {totalPages > 0 && (
        <div style={{ marginTop: '1.5rem', borderTop: '1px solid var(--border-color)', paddingTop: '1.25rem' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '1rem' }}>
            <div style={{ color: 'var(--text-secondary)', fontSize: '0.9rem' }}>
              Menampilkan {filteredReports.length === 0 ? 0 : indexOfFirstReport + 1}–{Math.min(indexOfLastReport, filteredReports.length)} dari {filteredReports.length} laporan
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '0.35rem' }}>
              <button
                className="btn btn-secondary btn-sm"
                disabled={reportCurrentPage === 1}
                onClick={() => setReportCurrentPage(prev => Math.max(prev - 1, 1))}
                style={{ padding: '0.4rem 0.9rem', minWidth: '64px' }}
              >
                ← Prev
              </button>
              {Array.from({ length: totalPages }, (_, i) => i + 1).map(page => (
                <button
                  key={page}
                  className={`btn btn-sm ${reportCurrentPage === page ? 'btn-primary' : 'btn-secondary'}`}
                  onClick={() => setReportCurrentPage(page)}
                  style={{ padding: '0.4rem 0.75rem', minWidth: '36px' }}
                >
                  {page}
                </button>
              ))}
              <button
                className="btn btn-secondary btn-sm"
                disabled={reportCurrentPage === totalPages}
                onClick={() => setReportCurrentPage(prev => Math.min(prev + 1, totalPages))}
                style={{ padding: '0.4rem 0.9rem', minWidth: '64px' }}
              >
                Next →
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default LaporanTab;
