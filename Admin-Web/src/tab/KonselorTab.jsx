import React from 'react';
import {
  IconCounselor,
  IconStatKonseling,
  IconWarning,
  IconCheckCircle,
  IconEyeOff,
  IconEye,
  IconRefresh,
  IconX
} from './Icons';
import { getBuktiUrl } from '../App';

const KonselorTab = ({
  user,
  allCounselors,
  newAdminForm,
  setNewAdminForm,
  adminRegisterError,
  adminRegisterSuccess,
  adminRegistering,
  handleRegisterAdmin,
  showNewAdminPassword,
  setShowNewAdminPassword,
  handleOpenEditModal,
  promptDeleteCounselor,

  // Counselor/Admin Form (not superadmin)
  profilePhotoPreview,
  konselorPhotoBlobUrl,
  profilePhotoUploading,
  photoInputRef,
  handleProfilePhotoChange,
  konselorForm,
  setKonselorField,
  konselorLoaded,
  konselorSaving,
  konselorFormError,
  handleSaveKonselor,
  addKonselorRow,
  removeKonselorRow,
  updateKonselorRow,
  schedules,
  newSchedDate,
  setNewSchedDate,
  newSchedLoc,
  setNewSchedLoc,
  newSchedStart,
  setNewSchedStart,
  newSchedEnd,
  setNewSchedEnd,
  addSchedLoading,
  handleAddSchedule,
  promptDeleteSchedule
}) => {
  const isSuper = user && user.role === 'superadmin';

  if (isSuper) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: '2rem' }}>
        {/* Ringkasan jumlah konselor terdaftar */}
        <div className="grid-stats">
          <div className="card stat-card">
            <div className="stat-info">
              <h3>Total Admin / Konselor Terdaftar</h3>
              <p>{allCounselors.length}</p>
            </div>
            <div className="stat-icon" style={{ background: 'var(--info-bg)', color: 'var(--info)' }}>
              <IconStatKonseling />
            </div>
          </div>
          <div className="card stat-card">
            <div className="stat-info">
              <h3>Sedang Online</h3>
              <p>{allCounselors.filter(c => c.is_online).length}</p>
            </div>
            <div className="stat-icon" style={{ background: 'var(--success-bg)', color: 'var(--success)' }}>
              <IconCounselor />
            </div>
          </div>
        </div>

        {/* Form Registrasi Admin Baru */}
        <div className="card" style={{ maxWidth: '600px', margin: '0 auto', width: '100%' }}>
          <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Daftarkan Akun Baru (Admin / Super Admin)</h2>
          <form onSubmit={handleRegisterAdmin} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            {adminRegisterError && (
              <div style={{ background: 'var(--danger-bg)', border: '1px solid var(--danger-border)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--danger)', fontSize: '0.95rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                <IconWarning size={16} /> {adminRegisterError}
              </div>
            )}
            {adminRegisterSuccess && (
              <div style={{ background: 'var(--success-bg)', border: '1px solid var(--success-border)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--success)', fontSize: '0.95rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                <IconCheckCircle size={16} /> {adminRegisterSuccess}
              </div>
            )}

            <div className="form-group">
              <label>Nama Lengkap *</label>
              <input
                type="text"
                value={newAdminForm.nama}
                onChange={e => setNewAdminForm({ ...newAdminForm, nama: e.target.value })}
                required
                placeholder="Nama Lengkap Admin"
              />
            </div>

            <div className="form-group">
              <label>Email *</label>
              <input
                type="email"
                value={newAdminForm.email}
                onChange={e => setNewAdminForm({ ...newAdminForm, email: e.target.value })}
                required
                placeholder="email@example.com"
              />
            </div>

            <div className="form-group">
              <label>Password *</label>
              <div style={{ position: 'relative' }}>
                <input
                  type={showNewAdminPassword ? 'text' : 'password'}
                  value={newAdminForm.password}
                  onChange={e => setNewAdminForm({ ...newAdminForm, password: e.target.value })}
                  required
                  placeholder="Min. 8 karakter, angka, dan karakter khusus"
                  style={{ paddingRight: '2.75rem' }}
                />
                <button
                  type="button"
                  onClick={() => setShowNewAdminPassword(v => !v)}
                  style={{ position: 'absolute', right: '0.75rem', top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', cursor: 'pointer', color: 'var(--text-secondary)', padding: 0, display: 'flex', alignItems: 'center' }}
                >
                  {showNewAdminPassword ? <IconEyeOff size={16} /> : <IconEye size={16} />}
                </button>
              </div>
            </div>

            <div className="form-group">
              <label>Nomor Telepon (Opsional)</label>
              <input
                type="text"
                value={newAdminForm.nomor_telepon}
                onChange={e => setNewAdminForm({ ...newAdminForm, nomor_telepon: e.target.value })}
                placeholder="cth: 08123456789"
              />
            </div>

            <div className="form-group">
              <label>Role *</label>
              <select
                value={newAdminForm.role}
                onChange={e => setNewAdminForm({ ...newAdminForm, role: e.target.value })}
                required
              >
                <option value="admin">Admin / Konselor</option>
                <option value="superadmin">Super Admin</option>
              </select>
            </div>

            <button type="submit" className="btn btn-primary" disabled={adminRegistering} style={{ padding: '0.75rem', marginTop: '0.5rem' }}>
              {adminRegistering ? 'Mendaftarkan...' : 'Daftarkan Akun Baru'}
            </button>
          </form>
        </div>

        {/* Tabel Semua Admin/Konselor */}
        <div className="card">
          <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Daftar Seluruh Admin & Konselor ({allCounselors.length})</h2>
          <div className="table-container">
            <table style={{ minWidth: '1000px', width: '100%' }}>
              <thead>
                <tr>
                  <th>Nama</th>
                  <th>Email</th>
                  <th>Nomor Telepon</th>
                  <th>Role</th>
                  <th>Sesi</th>
                  <th>Status</th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody>
                {allCounselors.map(c => (
                  <tr key={c.id}>
                    <td>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                        {c.foto_profil ? (
                          <img
                            src={getBuktiUrl(c.foto_profil)}
                            alt={c.name}
                            style={{ width: '32px', height: '32px', borderRadius: '50%', objectFit: 'cover' }}
                            onError={(e) => { e.target.style.display = 'none'; }}
                          />
                        ) : (
                          <div style={{
                            width: '32px',
                            height: '32px',
                            borderRadius: '50%',
                            backgroundColor: 'var(--primary)',
                            color: '#fff',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            fontWeight: '700',
                            fontSize: '0.85rem',
                            textTransform: 'uppercase',
                            flexShrink: 0
                          }}>
                            {(c.name || 'P').charAt(0)}
                          </div>
                        )}
                        <strong>{c.name}</strong>
                      </div>
                    </td>
                    <td>{c.email}</td>
                    <td>{c.nomor_telepon || '-'}</td>
                    <td>
                      <span className={`badge ${c.role === 'superadmin' ? 'badge-pending' : 'badge-process'}`}>
                        {c.role === 'superadmin' ? 'Super Admin' : 'Admin'}
                      </span>
                    </td>
                    <td>{c.sessions}</td>
                    <td>
                      <span className={`badge ${c.is_online ? 'badge-success' : 'badge-danger'}`}>
                        {c.is_online ? 'Online' : 'Offline'}
                      </span>
                    </td>
                    <td>
                      <div style={{ display: 'flex', gap: '0.4rem' }}>
                        <button className="btn btn-secondary btn-sm" onClick={() => handleOpenEditModal(c)}>Edit</button>
                        <button className="btn btn-danger btn-sm" onClick={() => promptDeleteCounselor(c.id)}>Hapus</button>
                      </div>
                    </td>
                  </tr>
                ))}
                {allCounselors.length === 0 && (
                  <tr><td colSpan="7" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada admin/konselor terdaftar.</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  }

  // Calculate schedule states
  const existingDatesSet = new Set(schedules.map(s => String(s.tanggal).substring(0, 10)));
  const uniqueDayCount = existingDatesSet.size;
  const isDateNew = newSchedDate && !existingDatesSet.has(newSchedDate);
  const isMaxDayReached = uniqueDayCount >= 3 && isDateNew;
  const isFormDisabled = addSchedLoading;

  return (
    <div className="card" style={{ maxWidth: '800px', margin: '0 auto' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '1.5rem', marginBottom: '2rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '1.5rem' }}>
        <div
          style={{ position: 'relative', width: '80px', height: '80px', flexShrink: 0, cursor: 'pointer' }}
          onClick={() => !profilePhotoUploading && photoInputRef.current?.click()}
          title="Klik untuk ubah foto profil"
        >
          {profilePhotoPreview || konselorPhotoBlobUrl ? (
            <img
              src={profilePhotoPreview || konselorPhotoBlobUrl}
              alt={konselorForm.nama}
              style={{ width: '80px', height: '80px', borderRadius: '50%', objectFit: 'cover', border: '3px solid var(--primary)', display: 'block', opacity: profilePhotoUploading ? 0.5 : 1, transition: 'opacity 0.2s' }}
            />
          ) : (
            <div style={{
              width: '80px',
              height: '80px',
              borderRadius: '50%',
              backgroundColor: 'var(--primary)',
              color: '#fff',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: '700',
              fontSize: '2rem',
              textTransform: 'uppercase',
              border: '3px solid var(--primary)',
              opacity: profilePhotoUploading ? 0.5 : 1,
              transition: 'opacity 0.2s',
              flexShrink: 0
            }}>
              {(konselorForm.nama || 'K').charAt(0)}
            </div>
          )}
          <div style={{
            position: 'absolute', bottom: 2, right: 2,
            width: '24px', height: '24px', borderRadius: '50%',
            background: 'var(--primary)',
            border: '2px solid #fff',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            pointerEvents: 'none',
          }}>
            {profilePhotoUploading ? (
              <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" style={{ animation: 'spin 1s linear infinite' }}><path d="M21.5 2v6h-6" /><path d="M21.34 15.57a10 10 0 1 1-.57-8.38" /></svg>
            ) : (
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" /><circle cx="12" cy="13" r="4" /></svg>
            )}
          </div>
          <input
            ref={photoInputRef}
            type="file"
            accept="image/jpeg,image/png,image/jpg"
            style={{ display: 'none' }}
            onChange={handleProfilePhotoChange}
          />
        </div>
        <div>
          <h2 style={{ fontSize: '1.4rem', margin: 0 }}>{konselorForm.nama || 'Konselor'}</h2>
          <p style={{ color: 'var(--text-secondary)', margin: '0.25rem 0 0' }}>{konselorForm.spesialisasi || 'Spesialisasi belum diatur'}</p>
          <div style={{ marginTop: '0.5rem' }}>
            <span className={`badge ${konselorForm.is_online ? 'badge-success' : 'badge-danger'}`}>
              {konselorForm.is_online ? 'Online' : 'Offline'}
            </span>
          </div>
        </div>
      </div>

      {!konselorLoaded ? (
        <div style={{ padding: '2rem', textAlign: 'center', color: 'var(--text-secondary)' }}>Memuat data profil konselor...</div>
      ) : (
        <form onSubmit={handleSaveKonselor} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
          {konselorFormError && (
            <div style={{ background: 'var(--danger-bg)', border: '1px solid var(--danger-border)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--danger)', fontSize: '0.95rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <IconWarning size={16} /> {konselorFormError}
            </div>
          )}

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
            <div className="form-group">
              <label>Nama Lengkap *</label>
              <input value={konselorForm.nama} onChange={e => setKonselorField('nama', e.target.value)} required />
            </div>
            <div className="form-group">
              <label>Spesialisasi (Judul) *</label>
              <input value={konselorForm.spesialisasi} onChange={e => setKonselorField('spesialisasi', e.target.value)} placeholder="cth: Psikolog Klinis" required />
            </div>
            <div className="form-group">
              <label>Pengalaman</label>
              <input value={konselorForm.pengalaman_tahun} onChange={e => setKonselorField('pengalaman_tahun', e.target.value)} placeholder="cth: 3 Tahun" />
            </div>
            <div className="form-group">
              <label>Nomor Telepon</label>
              <input value={konselorForm.nomor_telepon} onChange={e => setKonselorField('nomor_telepon', e.target.value)} placeholder="cth: 08123456789" />
            </div>
          </div>

          <div className="form-group">
            <label>Tentang / Deskripsi Diri</label>
            <textarea rows={4} value={konselorForm.tentang} onChange={e => setKonselorField('tentang', e.target.value)} placeholder="Tulis deskripsi diri atau latar belakang Anda..." />
          </div>

          <div className="form-group">
            <label>Spesialisasi (Chips, pisah dengan koma)</label>
            <input value={konselorForm.spesialisasi_list} onChange={e => setKonselorField('spesialisasi_list', e.target.value)} placeholder="cth: Perundungan, Trauma, Cemas" />
          </div>

          <KonselorRowEditor
            title="Pendidikan"
            rows={konselorForm.pendidikan}
            onAdd={() => addKonselorRow('pendidikan')}
            onRemove={(i) => removeKonselorRow('pendidikan', i)}
            onChange={(i, key, val) => updateKonselorRow('pendidikan', i, key, val)}
          />

          <KonselorRowEditor
            title="Pengalaman Kerja"
            rows={konselorForm.pengalaman}
            onAdd={() => addKonselorRow('pengalaman')}
            onRemove={(i) => removeKonselorRow('pengalaman', i)}
            onChange={(i, key, val) => updateKonselorRow('pengalaman', i, key, val)}
          />

          {/* SECTION: TAMBAH SLOT JADWAL PRAKTIK */}
          <div style={{ borderTop: '1px solid var(--border-color)', paddingTop: '1.5rem', marginTop: '1.5rem' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
              <h3 style={{ fontSize: '1.1rem', margin: 0, color: 'var(--primary)' }}>
                Tambah Slot Jadwal Praktik ({uniqueDayCount}/3 hari)
              </h3>
              {uniqueDayCount >= 3 && (
                <span style={{ color: 'var(--warning)', fontSize: '0.85rem', fontWeight: '500' }}>
                  3 hari sudah terisi — jam baru pada hari yang sama tetap bisa ditambah.
                </span>
              )}
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <div className="form-group">
                <label>Tanggal</label>
                <input
                  type="date"
                  value={newSchedDate}
                  onChange={e => setNewSchedDate(e.target.value)}
                  disabled={isFormDisabled}
                />
              </div>
              <div className="form-group">
                <label>Ruangan / Lokasi</label>
                <input
                  type="text"
                  placeholder="Ruang Konseling Gd. AX"
                  value={newSchedLoc}
                  onChange={e => setNewSchedLoc(e.target.value)}
                  disabled={isFormDisabled}
                />
              </div>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginTop: '0.5rem' }}>
              <div className="form-group">
                <label>Jam Mulai</label>
                <input
                  type="time"
                  value={newSchedStart}
                  onChange={e => setNewSchedStart(e.target.value)}
                  disabled={isFormDisabled}
                />
              </div>
              <div className="form-group">
                <label>Jam Selesai</label>
                <input
                  type="time"
                  value={newSchedEnd}
                  onChange={e => setNewSchedEnd(e.target.value)}
                  disabled={isFormDisabled}
                />
              </div>
            </div>
            <div style={{ display: 'flex', justifyContent: 'flex-start', marginTop: '0.75rem' }}>
              <button
                type="button"
                className="btn btn-secondary btn-sm"
                onClick={handleAddSchedule}
                disabled={isFormDisabled || isMaxDayReached}
                style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}
              >
                <IconRefresh spinning={addSchedLoading} />
                {addSchedLoading ? 'Menyimpan...' : 'Tambah Slot Jadwal'}
              </button>
            </div>

            {/* Current slots list */}
            {schedules.length > 0 && (
              <div style={{ marginTop: '1.5rem', borderTop: '1px solid rgba(16, 104, 163, 0.08)', paddingTop: '1.25rem' }}>
                <h4 style={{ fontSize: '0.9rem', fontWeight: '600', marginBottom: '0.75rem', color: 'var(--text-secondary)' }}>
                  Daftar Slot Jadwal Praktik Aktif
                </h4>
                <ul style={{ listStyle: 'none', padding: 0, display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                  {schedules.map(s => (
                    <li key={s.id} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0.6rem 0.85rem', background: 'rgba(16, 104, 163, 0.03)', borderRadius: '8px', border: '1px solid rgba(16, 104, 163, 0.06)', fontSize: '0.875rem' }}>
                      <span>
                        <strong>{new Date(s.tanggal).toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'short' })}</strong>: {s.jam_mulai.substring(0, 5)} - {s.jam_selesai.substring(0, 5)} ({s.lokasi || 'TBA'})
                      </span>
                      <button
                        type="button"
                        className="btn btn-danger btn-sm"
                        style={{ padding: '0.2rem 0.6rem', fontSize: '0.75rem', borderRadius: '4px' }}
                        onClick={() => promptDeleteSchedule(s.id)}
                      >
                        Hapus
                      </button>
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>

          <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '1rem', borderTop: '1px solid var(--border-color)', paddingTop: '1.5rem' }}>
            <button type="submit" className="btn btn-primary" disabled={konselorSaving} style={{ padding: '0.6rem 2rem' }}>
              {konselorSaving ? 'Menyimpan...' : 'Simpan Profil Konselor'}
            </button>
          </div>
        </form>
      )}
    </div>
  );
};

// Editor baris untuk Pendidikan/Pengalaman konselor
function KonselorRowEditor({ title, rows, onAdd, onRemove, onChange }) {
  return (
    <div className="form-group">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.4rem' }}>
        <label style={{ margin: 0 }}>{title}</label>
        <button type="button" className="btn btn-secondary btn-sm" onClick={onAdd}>+ Tambah</button>
      </div>
      {rows.length === 0 && <p style={{ color: 'var(--text-muted)', fontSize: '0.85rem' }}>Belum ada {title.toLowerCase()}.</p>}
      {rows.map((r, i) => (
        <div key={i} style={{ display: 'flex', gap: '0.5rem', marginBottom: '0.5rem' }}>
          <input placeholder="Judul" value={r.title || ''} onChange={e => onChange(i, 'title', e.target.value)} />
          <input placeholder="Keterangan" value={r.subtitle || ''} onChange={e => onChange(i, 'subtitle', e.target.value)} />
          <button type="button" className="btn btn-danger btn-sm" onClick={() => onRemove(i)} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}><IconX size={12} /></button>
        </div>
      ))}
    </div>
  );
}

export default KonselorTab;
