import React from 'react';

const SkeletonWireframe = ({ activeTab, isSuper }) => {
  const renderStatsGrid = (count) => (
    <div className="grid-stats" style={{ marginBottom: '2.5rem' }}>
      {Array.from({ length: count }).map((_, i) => (
        <div key={i} className="card stat-card" style={{ height: '98px' }}>
          <div className="stat-info" style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', width: '60%' }}>
            <div className="skeleton-box" style={{ height: '14px', width: '80%' }} />
            <div className="skeleton-box" style={{ height: '28px', width: '50%', marginTop: '4px' }} />
          </div>
          <div className="skeleton-box" style={{ width: '54px', height: '54px', borderRadius: '14px' }} />
        </div>
      ))}
    </div>
  );

  const renderTable = (rows = 5, cols = 5) => (
    <div className="card" style={{ width: '100%' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1.5rem', gap: '1rem' }}>
        <div className="skeleton-box" style={{ height: '38px', width: '250px', borderRadius: '10px' }} />
        <div className="skeleton-box" style={{ height: '38px', width: '120px', borderRadius: '10px' }} />
      </div>
      <div className="table-container">
        <table style={{ width: '100%' }}>
          <thead>
            <tr>
              {Array.from({ length: cols }).map((_, i) => (
                <th key={i} style={{ padding: '1rem' }}>
                  <div className="skeleton-box" style={{ height: '14px', width: '60%' }} />
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {Array.from({ length: rows }).map((_, r) => (
              <tr key={r}>
                {Array.from({ length: cols }).map((_, c) => (
                  <td key={c} style={{ padding: '1.2rem 1rem' }}>
                    <div className="skeleton-box" style={{ height: '14px', width: c === 0 ? '75%' : '50%' }} />
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );

  const renderProfileForm = () => (
    <div className="card" style={{ maxWidth: '800px', margin: '0 auto', width: '100%' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '1.5rem', marginBottom: '2rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '1.5rem' }}>
        <div className="skeleton-box" style={{ width: '80px', height: '80px', borderRadius: '50%' }} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
          <div className="skeleton-box" style={{ height: '20px', width: '40%' }} />
          <div className="skeleton-box" style={{ height: '14px', width: '30%' }} />
          <div className="skeleton-box" style={{ height: '22px', width: '15%', borderRadius: '9999px', marginTop: '4px' }} />
        </div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
            <div className="skeleton-box" style={{ height: '14px', width: '20%' }} />
            <div className="skeleton-box" style={{ height: '38px', width: '100%', borderRadius: '10px' }} />
          </div>
        ))}
        <div className="skeleton-box" style={{ height: '42px', width: '140px', borderRadius: '10px', marginTop: '0.5rem', alignSelf: 'flex-start' }} />
      </div>
    </div>
  );

  const renderChat = () => (
    <div className="chat-wrapper">
      <div className="chat-sidebar card">
        <div className="skeleton-box" style={{ height: '38px', width: '100%', borderRadius: '10px', marginBottom: '0.5rem' }} />
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="card" style={{ padding: '1rem', display: 'flex', flexDirection: 'column', gap: '0.5rem', background: 'rgba(255,255,255,0.2)' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <div className="skeleton-box" style={{ height: '14px', width: '50%' }} />
              <div className="skeleton-box" style={{ height: '10px', width: '20%' }} />
            </div>
            <div className="skeleton-box" style={{ height: '12px', width: '80%' }} />
          </div>
        ))}
      </div>
      <div className="chat-main card" style={{ display: 'flex', flexDirection: 'column', padding: 0 }}>
        <div style={{ padding: '1.25rem 1.5rem', borderBottom: '1px solid var(--border-color)', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.4rem', width: '50%' }}>
            <div className="skeleton-box" style={{ height: '16px', width: '40%' }} />
            <div className="skeleton-box" style={{ height: '12px', width: '60%' }} />
          </div>
          <div className="skeleton-box" style={{ height: '34px', width: '100px', borderRadius: '10px' }} />
        </div>
        <div className="chat-messages" style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '1.5rem', padding: '1.5rem' }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.4rem', alignSelf: 'flex-start', width: '40%' }}>
            <div className="skeleton-box" style={{ height: '45px', width: '100%', borderRadius: '16px 16px 16px 4px' }} />
            <div className="skeleton-box" style={{ height: '10px', width: '30%', alignSelf: 'flex-start' }} />
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.4rem', alignSelf: 'flex-end', width: '40%' }}>
            <div className="skeleton-box" style={{ height: '60px', width: '100%', borderRadius: '16px 16px 4px 16px' }} />
            <div className="skeleton-box" style={{ height: '10px', width: '30%', alignSelf: 'flex-end' }} />
          </div>
        </div>
        <div style={{ padding: '1.25rem 1.5rem', borderTop: '1px solid var(--border-color)', display: 'flex', gap: '0.75rem' }}>
          <div className="skeleton-box" style={{ height: '38px', flex: 1, borderRadius: '10px' }} />
          <div className="skeleton-box" style={{ height: '38px', width: '48px', borderRadius: '10px' }} />
        </div>
      </div>
    </div>
  );

  switch (activeTab) {
    case 'dashboard':
      return (
        <div>
          {renderStatsGrid(4)}
          {renderTable(6, 6)}
        </div>
      );
    case 'konselor':
      if (isSuper) {
        return (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '2rem' }}>
            {renderStatsGrid(2)}
            <div className="card" style={{ maxWidth: '600px', margin: '0 auto', width: '100%' }}>
              <div className="skeleton-box" style={{ height: '24px', width: '50%', marginBottom: '1.5rem' }} />
              <div style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
                {Array.from({ length: 4 }).map((_, i) => (
                  <div key={i} style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                    <div className="skeleton-box" style={{ height: '14px', width: '20%' }} />
                    <div className="skeleton-box" style={{ height: '38px', width: '100%', borderRadius: '10px' }} />
                  </div>
                ))}
                <div className="skeleton-box" style={{ height: '42px', width: '100%', borderRadius: '10px', marginTop: '0.5rem' }} />
              </div>
            </div>
            {renderTable(4, 7)}
          </div>
        );
      }
      return renderProfileForm();
    case 'chat':
      return renderChat();
    case 'laporan':
      return renderTable(7, 6);
    case 'jadwal':
      return renderTable(6, 4);
    case 'konseling':
      return renderTable(7, 5);
    case 'users':
      return renderTable(8, 5);
    case 'superadmin':
      return renderTable(5, 4);
    default:
      return renderTable(5, 5);
  }
};

export default SkeletonWireframe;
