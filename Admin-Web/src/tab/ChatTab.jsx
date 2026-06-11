import React from 'react';
import {
  IconCheck,
  IconDoubleCheck,
  IconSingleCheck,
  IconMessageSquare
} from './Icons';
import { getImageUrl } from '../App';

const ChatTab = ({
  chatFilter,
  setChatFilter,
  setActiveChatSession,
  setChatMessages,
  sessions,
  activeChatSession,
  startChatSession,
  user,
  handleUpdateSessionStatus,
  chatMessages,
  chatImagePreview,
  handleCancelChatImage,
  chatImageFile,
  handleSendChatMessage,
  handleChatImageChange,
  newMessageText,
  setNewMessageText,
  chatEndRef
}) => {
  return (
    <div className="chat-wrapper">
      <div className="card chat-sidebar">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem', gap: '0.5rem' }}>
          <h2 style={{ fontSize: '1.1rem', margin: 0 }}>Sesi Chat</h2>
          <select
            value={chatFilter}
            onChange={e => {
              setChatFilter(e.target.value);
              setActiveChatSession(null);
              setChatMessages([]);
            }}
            style={{
              padding: '0.4rem 0.6rem',
              borderRadius: '8px',
              border: '1px solid var(--border-color)',
              background: 'rgba(255, 255, 255, 0.05)',
              color: 'var(--text-primary)',
              fontSize: '0.85rem',
              fontWeight: '600',
              outline: 'none',
              cursor: 'pointer',
            }}
          >
            <option value="aktif" style={{ background: '#1e293b', color: '#fff' }}>Sesi Aktif</option>
            <option value="history" style={{ background: '#1e293b', color: '#fff' }}>Riwayat Selesai</option>
          </select>
        </div>
        <div className="chat-sessions-list">
          {sessions
            .filter(s => {
              if (chatFilter === 'aktif') {
                return s.status === 'Diterima' || s.status === 'Berlangsung';
              } else {
                return s.status === 'Selesai' || s.status === 'Dibatalkan';
              }
            })
            .map(s => (
              <div
                key={s.id}
                className={`chat-session-item ${activeChatSession?.id === s.id ? 'active' : ''}`}
                onClick={() => startChatSession(s)}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.25rem', alignItems: 'center' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                    <strong>{s.mahasiswa?.nama}</strong>
                    {s.pesan?.some(m => m.sender_id !== user?.id && m.status_pesan === 'Terkirim') && (
                      <span
                        style={{
                          width: '8px',
                          height: '8px',
                          borderRadius: '50%',
                          backgroundColor: '#ef4444',
                          display: 'inline-block'
                        }}
                        title="Pesan baru"
                      />
                    )}
                  </div>
                  {s.tipe === 'laporan' ? (
                    <span style={{ fontSize: '0.75rem', color: 'var(--warning)', fontWeight: '600', padding: '2px 6px', background: 'rgba(245, 158, 11, 0.15)', borderRadius: '4px' }}>Laporan</span>
                  ) : (
                    <span style={{ fontSize: '0.75rem', color: 'var(--primary)', fontWeight: '600', padding: '2px 6px', background: 'rgba(16, 104, 163, 0.12)', borderRadius: '4px' }}>Konseling</span>
                  )}
                </div>
                <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', textOverflow: 'ellipsis', overflow: 'hidden', whiteSpace: 'nowrap' }}>
                  {(() => {
                    const lastMsg = s.pesan && s.pesan.length > 0 ? s.pesan[s.pesan.length - 1] : null;
                    if (lastMsg) {
                      return lastMsg.path_gambar ? '📷 Lampiran Gambar' : lastMsg.isi_pesan;
                    }
                    return s.keluhan || 'Tidak ada keluhan tertulis';
                  })()}
                </div>
              </div>
            ))}
          {sessions.filter(s => {
            if (chatFilter === 'aktif') {
              return s.status === 'Diterima' || s.status === 'Berlangsung';
            } else {
              return s.status === 'Selesai' || s.status === 'Dibatalkan';
            }
          }).length === 0 && (
            <div style={{ color: 'var(--text-muted)', fontSize: '0.9rem', textAlign: 'center', marginTop: '2rem' }}>
              {chatFilter === 'aktif' ? 'Tidak ada sesi konseling aktif saat ini.' : 'Tidak ada riwayat sesi konseling.'}
            </div>
          )}
        </div>
      </div>

      <div className="chat-main">
        {activeChatSession ? (
          <>
            <div className="chat-header">
              <div>
                <h3 style={{ fontSize: '1.1rem' }}>{activeChatSession.mahasiswa?.nama}</h3>
                <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>
                  NIM: {activeChatSession.mahasiswa?.profil_mahasiswa?.nim || '-'} | Status: {activeChatSession.status}
                  {activeChatSession.tipe === 'laporan' && (
                    <span style={{ marginLeft: '0.5rem', color: 'var(--warning)', fontWeight: '600' }}>(Tindak Lanjut Laporan)</span>
                  )}
                </p>
              </div>
              {activeChatSession.status !== 'Selesai' && activeChatSession.status !== 'Dibatalkan' && (
                <button className="btn btn-secondary btn-sm" onClick={() => handleUpdateSessionStatus(activeChatSession.id, 'Selesai')} style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                  <IconCheck size={14} /> Selesaikan Sesi
                </button>
              )}
            </div>

            <div className="chat-messages">
              {chatMessages.map(msg => (
                <div
                  key={msg.id}
                  className={`message-bubble ${msg.sender_id === user.id ? 'message-sent' : 'message-received'}`}
                >
                  <div style={{ fontWeight: '600', fontSize: '0.8rem', opacity: 0.9, marginBottom: '0.2rem' }}>
                    {msg.sender_id === user.id ? 'Anda' : msg.sender?.nama}
                  </div>
                  {msg.path_gambar && (
                    <div style={{ marginBottom: '0.5rem', maxWidth: '240px' }}>
                      <img
                        src={getImageUrl(msg.path_gambar)}
                        alt="Lampiran"
                        style={{ width: '100%', borderRadius: '8px', cursor: 'pointer' }}
                        onClick={() => window.open(getImageUrl(msg.path_gambar), '_blank')}
                      />
                    </div>
                  )}
                  {msg.isi_pesan && <div>{msg.isi_pesan}</div>}
                  <div className="message-time" style={{ display: 'inline-flex', alignItems: 'center', gap: '4px', alignSelf: 'flex-end' }}>
                    <span>{new Date(msg.created_at).toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })}</span>
                    {msg.sender_id === user.id && (
                      msg.status_pesan === 'Dibaca' ? (
                        <IconDoubleCheck size={13} color="#40C4FF" />
                      ) : (
                        <IconSingleCheck size={13} color="rgba(255, 255, 255, 0.6)" />
                      )
                    )}
                  </div>
                </div>
              ))}
              <div ref={chatEndRef} />
            </div>

            {activeChatSession.status === 'Selesai' || activeChatSession.status === 'Dibatalkan' ? (
              <div style={{
                padding: '1.25rem',
                background: 'rgba(255, 255, 255, 0.02)',
                borderTop: '1px solid var(--border-color)',
                textAlign: 'center',
                color: 'var(--text-secondary)',
                fontSize: '0.9rem',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '0.5rem',
                fontWeight: '600'
              }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" style={{ opacity: 0.6 }}>
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                  <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                </svg>
                Sesi konseling telah selesai (Arsip / Read-Only)
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column' }}>
                {chatImagePreview && (
                  <div style={{
                    padding: '10px 1.5rem',
                    borderTop: '1px solid var(--border-color)',
                    background: 'rgba(255, 255, 255, 0.03)',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '12px'
                  }}>
                    <div style={{ position: 'relative', width: '60px', height: '60px' }}>
                      <img
                        src={chatImagePreview}
                        alt="Pratinjau"
                        style={{ width: '100%', height: '100%', objectFit: 'cover', borderRadius: '8px' }}
                      />
                      <button
                        type="button"
                        onClick={handleCancelChatImage}
                        style={{
                          position: 'absolute',
                          top: '-6px',
                          right: '-6px',
                          background: '#ef4444',
                          color: '#fff',
                          border: 'none',
                          borderRadius: '50%',
                          width: '18px',
                          height: '18px',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          fontSize: '10px',
                          cursor: 'pointer',
                          padding: 0,
                          lineHeight: '18px'
                        }}
                      >
                        ✕
                      </button>
                    </div>
                    <span style={{ fontSize: '0.85rem', color: 'var(--text-secondary)' }}>
                      {chatImageFile ? chatImageFile.name : ''}
                    </span>
                  </div>
                )}
                <form className="chat-input-area" onSubmit={handleSendChatMessage} style={{ borderTop: chatImagePreview ? 'none' : '1px solid var(--border-color)' }}>
                  <label
                    htmlFor="admin-chat-image-input"
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      cursor: 'pointer',
                      color: 'var(--primary)',
                      padding: '0.5rem',
                      borderRadius: '8px',
                      background: 'rgba(16, 104, 163, 0.05)',
                      transition: 'var(--transition-fast)'
                    }}
                    title="Lampirkan Gambar"
                  >
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                      <circle cx="8.5" cy="8.5" r="1.5" />
                      <polyline points="21 15 16 10 5 21" />
                    </svg>
                  </label>
                  <input
                    id="admin-chat-image-input"
                    type="file"
                    accept="image/*"
                    onChange={handleChatImageChange}
                    style={{ display: 'none' }}
                  />
                  <input
                    type="text"
                    placeholder="Tulis pesan konseling di sini..."
                    value={newMessageText}
                    onChange={e => setNewMessageText(e.target.value)}
                    required={!chatImageFile}
                  />
                  <button type="submit" className="btn btn-primary">Kirim</button>
                </form>
              </div>
            )}
          </>
        ) : (
          <div style={{ display: 'flex', flex: 1, alignItems: 'center', justifyContent: 'center', flexDirection: 'column', color: 'var(--text-muted)', gap: '1rem' }}>
            <div style={{ display: 'flex', justifyContent: 'center', opacity: 0.3 }}><IconMessageSquare size={48} /></div>
            <p>Pilih salah satu sesi konseling aktif dari daftar sebelah kiri untuk mulai chatting.</p>
          </div>
        )}
      </div>
    </div>
  );
};

export default ChatTab;
