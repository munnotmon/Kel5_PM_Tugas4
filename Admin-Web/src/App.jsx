import { useState, useEffect, useRef } from 'react';
import axios from 'axios';

// SVG Icons for Sidebar
const IconDashboard = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <rect x="3" y="3" width="7" height="9" />
    <rect x="14" y="3" width="7" height="5" />
    <rect x="14" y="12" width="7" height="9" />
    <rect x="3" y="16" width="7" height="5" />
  </svg>
);

const IconCounselor = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
    <circle cx="12" cy="7" r="4" />
    <path d="M12 11v3" />
    <path d="M10.5 12.5h3" />
  </svg>
);

const IconReport = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M11 5L6 9H2v6h4l5 4V5z" />
    <path d="M15.54 8.46a5 5 0 0 1 0 7.07" />
    <path d="M19.07 4.93a10 10 0 0 1 0 14.14" />
  </svg>
);

const IconBooking = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
    <circle cx="9" cy="7" r="4" />
    <polyline points="16 11 18 13 22 9" />
  </svg>
);

const IconChat = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
  </svg>
);

const IconUsers = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
    <circle cx="9" cy="7" r="4" />
    <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
    <path d="M16 3.13a4 4 0 0 1 0 7.75" />
  </svg>
);

const IconShieldUser = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
    <circle cx="12" cy="10" r="2.2" />
    <path d="M8.5 16a3.5 3.5 0 0 1 7 0" />
  </svg>
);

const IconSignOut = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
    <polyline points="16 17 21 12 16 7" />
    <line x1="21" y1="12" x2="9" y2="12" />
  </svg>
);

const IconKey = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4" />
  </svg>
);

const IconMenu = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <line x1="4" x2="20" y1="12" y2="12" />
    <line x1="4" x2="20" y1="6" y2="6" />
    <line x1="4" x2="20" y1="18" y2="18" />
  </svg>
);

const IconRefresh = ({ spinning }) => (
  <svg
    width="14"
    height="14"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2.5"
    strokeLinecap="round"
    strokeLinejoin="round"
    style={{
      flexShrink: 0,
      animation: spinning ? 'spin 1s linear infinite' : 'none'
    }}
  >
    <path d="M21.5 2v6h-6" />
    <path d="M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67" />
  </svg>
);

const LogoIcon = ({ size = 36 }) => {
  const shieldSize = size;
  const heartSize = Math.round(size * 0.4);
  return (
    <div style={{ position: 'relative', width: `${size}px`, height: `${size}px`, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
      {/* Shield */}
      <svg width={shieldSize} height={shieldSize} viewBox="0 0 24 24" fill="#1068A3" stroke="#1068A3" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
      </svg>
      {/* Heart */}
      <div style={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -50%)', display: 'flex', alignItems: 'center', justifyContent: 'center', marginTop: `${Math.round(size * 0.03)}px` }}>
        <svg width={heartSize} height={heartSize} viewBox="0 0 24 24" fill="#ffffff" stroke="#ffffff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z" />
        </svg>
      </div>
    </div>
  );
};

// SVG Icons for Dashboard Stat Cards
const IconStatLaporan = () => (
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M11 5L6 9H2v6h4l5 4V5z" />
    <path d="M15.54 8.46a5 5 0 0 1 0 7.07" />
    <path d="M19.07 4.93a10 10 0 0 1 0 14.14" />
  </svg>
);

const IconStatVerifikasi = () => (
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M5 2h14" />
    <path d="M5 22h14" />
    <path d="M19 2v6a7 7 0 0 1-3.5 6L12 17l-3.5-3A7 7 0 0 1 5 8V2" />
    <path d="M5 22v-6a7 7 0 0 1 3.5-6L12 7l3.5 3A7 7 0 0 1 19 16v6" />
  </svg>
);

const IconStatKonseling = () => (
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
    <circle cx="9" cy="7" r="4" />
    <polyline points="16 11 18 13 22 9" />
  </svg>
);

const IconStatJadwal = () => (
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
    <line x1="16" y1="2" x2="16" y2="6" />
    <line x1="8" y1="2" x2="8" y2="6" />
    <line x1="3" y1="10" x2="21" y2="10" />
    <path d="M8 14h.01" />
    <path d="M12 14h.01" />
    <path d="M16 14h.01" />
    <path d="M12 18h.01" />
    <path d="M16 18h.01" />
  </svg>
);

const IconWarning = ({ size = 16, className, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" className={className} style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
    <line x1="12" y1="9" x2="12" y2="13" />
    <line x1="12" y1="17" x2="12.01" y2="17" />
  </svg>
);

const IconPaperclip = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48" />
  </svg>
);

const IconCalendar = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
    <line x1="16" y1="2" x2="16" y2="6" />
    <line x1="8" y1="2" x2="8" y2="6" />
    <line x1="3" y1="10" x2="21" y2="10" />
  </svg>
);

const IconClock = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <circle cx="12" cy="12" r="10" />
    <polyline points="12 6 12 12 16 14" />
  </svg>
);

const IconMapPin = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
    <circle cx="12" cy="10" r="3" />
  </svg>
);

const IconMessageSquare = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
  </svg>
);

const IconCheck = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <polyline points="20 6 9 17 4 12" />
  </svg>
);

const IconX = ({ size = 14, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <line x1="18" y1="6" x2="6" y2="18" />
    <line x1="6" y1="6" x2="18" y2="18" />
  </svg>
);

const IconEye = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
    <circle cx="12" cy="12" r="3" />
  </svg>
);

const IconEyeOff = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94" />
    <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19" />
    <line x1="1" y1="1" x2="23" y2="23" />
  </svg>
);

const IconCheckCircle = ({ size = 16, style }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
    <polyline points="22 4 12 14.01 9 11.01" />
  </svg>
);

const IconSingleCheck = ({ size = 14, style, color = 'currentColor' }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <polyline points="20 6 9 17 4 12" />
  </svg>
);

const IconDoubleCheck = ({ size = 14, style, color = 'currentColor' }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, display: 'inline-block', verticalAlign: 'middle', ...style }}>
    <path d="M17 6L8.5 14.5L5 11" />
    <path d="M22 6L13.5 14.5L12 13" />
  </svg>
);

// Configure Axios defaults
const useNgrok = true;
axios.defaults.baseURL = useNgrok
  ? 'https://engraver-stride-chatter.ngrok-free.dev/api'
  : 'http://localhost:8000/api';

const getImageUrl = (path) => {
  if (!path) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  return `${axios.defaults.baseURL}/storage/${path}`;
};

const getBuktiType = (fileName) => {
  if (!fileName) return 'other';
  const ext = fileName.split('.').pop().toLowerCase();
  if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].includes(ext)) return 'image';
  if (['mp4', 'mov', 'avi', 'mkv', 'webm'].includes(ext)) return 'video';
  if (['mp3', 'wav', 'ogg', 'm4a', 'aac', 'flac'].includes(ext)) return 'audio';
  return 'other';
};

const getBuktiUrl = (pathFile) => {
  if (!pathFile) { console.warn('[getBuktiUrl] pathFile is null/empty'); return null; }
  const serverRoot = axios.defaults.baseURL.replace(/\/api$/, '');
  let result;
  if (pathFile.startsWith('http://') || pathFile.startsWith('https://')) {
    try {
      const u = new URL(pathFile);
      result = `${serverRoot}${u.pathname}`;
    } catch { result = pathFile; }
  } else {
    const cleanPath = pathFile.startsWith('/') ? pathFile : `/storage/${pathFile}`;
    result = `${serverRoot}${cleanPath}`;
  }
  console.log('[getBuktiUrl] raw:', pathFile, '| final:', result);
  return result;
};

// Add request interceptor to attach bearer token
axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('admin_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    config.headers['ngrok-skip-browser-warning'] = 'true';
    return config;
  },
  (error) => Promise.reject(error)
);

// Add response interceptor to handle 401 Unauthorized
axios.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      const isLoginRequest = error.config && error.config.url && error.config.url.includes('/login');
      if (!isLoginRequest) {
        localStorage.removeItem('admin_token');
        localStorage.removeItem('admin_user');
        window.location.reload();
      }
    }
    return Promise.reject(error);
  }
);

const emptyKonselorForm = {
  nama: '', email: '', password: '', nomor_telepon: '',
  spesialisasi: '', rating: '5.0', pengalaman_tahun: '', tentang: '',
  spesialisasi_list: '', jam_tersedia: '', hari_praktik: [],
  foto_profil: '', is_online: false, pendidikan: [], pengalaman: [],
};

const getWeekdayFromDateString = (dateStr) => {
  if (!dateStr) return 1;
  const cleanStr = dateStr.substring(0, 10);
  const parts = cleanStr.split('-');
  if (parts.length < 3) return 1;
  const yr = parseInt(parts[0], 10);
  const mo = parseInt(parts[1], 10);
  const dy = parseInt(parts[2], 10);
  const dt = new Date(Date.UTC(yr, mo - 1, dy));
  const day = dt.getUTCDay();
  return day === 0 ? 7 : day;
};

const normalizeTimeStr = (timeStr) => {
  if (!timeStr) return '';
  const clean = timeStr.replace(' WIB', '').trim();
  const parts = clean.split(':');
  if (parts.length === 0) return '';
  const hr = parts[0].padStart(2, '0');
  const min = (parts[1] || '00').padStart(2, '0');
  return `${hr}:${min}`;
};

function App() {
  const storedUser = JSON.parse(localStorage.getItem('admin_user'));
  const [token, setToken] = useState(localStorage.getItem('admin_token'));
  const [user, setUser] = useState(storedUser);
  // Super Admin hanya mengelola admin/konselor, jadi langsung ke tab tersebut.
  const [activeTab, setActiveTab] = useState(storedUser?.role === 'superadmin' ? 'konselor' : 'dashboard');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [sidebarCollapsed, setSidebarCollapsed] = useState(() => localStorage.getItem('sidebar_collapsed') === 'true');
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);
  const [logoutLoading, setLogoutLoading] = useState(false);
  const [showDeleteSchedConfirm, setShowDeleteSchedConfirm] = useState(false);
  const [schedIdToDelete, setSchedIdToDelete] = useState(null);
  const [deleteSchedLoading, setDeleteSchedLoading] = useState(false);
  const [addSchedLoading, setAddSchedLoading] = useState(false);
  const [showDeleteCounselorConfirm, setShowDeleteCounselorConfirm] = useState(false);
  const [counselorIdToDelete, setCounselorIdToDelete] = useState(null);
  const [deleteCounselorLoading, setDeleteCounselorLoading] = useState(false);
  const [, setMyProfileData] = useState(null);


  const toggleSidebar = () => {
    setSidebarCollapsed(prev => {
      const newVal = !prev;
      localStorage.setItem('sidebar_collapsed', String(newVal));
      return newVal;
    });
  };

  // Login Form States
  const [loginEmail, setLoginEmail] = useState('');
  const [loginPassword, setLoginPassword] = useState('');

  // Data States
  const [reports, setReports] = useState([]);
  const [schedules, setSchedules] = useState([]);
  const [sessions, setSessions] = useState([]);
  const [users, setUsers] = useState([]);
  const [allCounselors, setAllCounselors] = useState([]);
  const [superAdmins, setSuperAdmins] = useState([]);
  const [loadingChatForReport, setLoadingChatForReport] = useState(false);
  const [newAdminForm, setNewAdminForm] = useState({ nama: '', email: '', password: '', nomor_telepon: '', role: 'admin' });
  const [showNewAdminPassword, setShowNewAdminPassword] = useState(false);
  const [adminRegistering, setAdminRegistering] = useState(false);
  const [adminRegisterError, setAdminRegisterError] = useState('');
  const [adminRegisterSuccess, setAdminRegisterSuccess] = useState('');

  // Edit/Delete Counselor States
  const [editingCounselor, setEditingCounselor] = useState(null);
  const [editForm, setEditForm] = useState({ nama: '', email: '', password: '', nomor_telepon: '', role: 'admin' });
  const [showEditPassword, setShowEditPassword] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);

  // Reset Password Mahasiswa States
  const [resettingUser, setResettingUser] = useState(null);
  const [resetPasswordForm, setResetPasswordForm] = useState({ password: '', showPassword: false });
  const [showResetPasswordModal, setShowResetPasswordModal] = useState(false);

  // Selesai Sesi Modal States
  const [showSelesaiModal, setShowSelesaiModal] = useState(false);
  const [selesaiSessionId, setSelesaiSessionId] = useState(null);
  const [catatanKonselor, setCatatanKonselor] = useState('');
  const [rekomendasiPemulihan, setRekomendasiPemulihan] = useState('');

  // Laporan Search & Pagination States
  const [reportSearchQuery, setReportSearchQuery] = useState('');
  const [reportCurrentPage, setReportCurrentPage] = useState(1);
  const reportsPerPage = 10;

  // Reset page to 1 when search query changes
  useEffect(() => {
    setReportCurrentPage(1);
  }, [reportSearchQuery]);

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
  // Profil konselor milik admin yang login
  const [konselorForm, setKonselorForm] = useState(emptyKonselorForm);
  const [konselorSaving, setKonselorSaving] = useState(false);
  const [konselorFormError, setKonselorFormError] = useState('');
  const [konselorLoaded, setKonselorLoaded] = useState(false);
  const [profilePhotoPreview, setProfilePhotoPreview] = useState(null);
  const [profilePhotoUploading, setProfilePhotoUploading] = useState(false);
  const [konselorPhotoBlobUrl, setKonselorPhotoBlobUrl] = useState(null);
  const myProfileDataRef = useRef(null);
  const photoInputRef = useRef(null);

  // Detail Modal States
  const [selectedReport, setSelectedReport] = useState(null);
  const [selectedSession, setSelectedSession] = useState(null);
  const [showSuccessAlert, setShowSuccessAlert] = useState(false);
  const [successAlertMsg, setSuccessAlertMsg] = useState('');
  const [reportStatusUpdating, setReportStatusUpdating] = useState(null);
  const [previewBukti, setPreviewBukti] = useState(null);

  // Form States (New Schedule)
  const [newSchedDate, setNewSchedDate] = useState('');
  const [newSchedStart, setNewSchedStart] = useState('');
  const [newSchedEnd, setNewSchedEnd] = useState('');
  const [newSchedLoc, setNewSchedLoc] = useState('');

  // Chat Room States
  const [activeChatSession, setActiveChatSession] = useState(null);
  const [chatFilter, setChatFilter] = useState('aktif'); // 'aktif' or 'history'
  const [chatMessages, setChatMessages] = useState([]);
  const [newMessageText, setNewMessageText] = useState('');
  const [chatImageFile, setChatImageFile] = useState(null);
  const [chatImagePreview, setChatImagePreview] = useState('');
  const chatEndRef = useRef(null);

  const handleChatImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setChatImageFile(file);
      setChatImagePreview(URL.createObjectURL(file));
    }
  };

  const handleCancelChatImage = () => {
    setChatImageFile(null);
    if (chatImagePreview) {
      URL.revokeObjectURL(chatImagePreview);
      setChatImagePreview('');
    }
  };
  // Check Auth & Fetch Initial Data
  useEffect(() => {
    if (token) {
      fetchDashboardData();
    }
  }, [token]);

  // Polling data dashboard secara silent setiap 10 detik (saat user login)
  useEffect(() => {
    if (!token) return;
    const interval = setInterval(() => {
      fetchDashboardData(true);
    }, 10000);
    return () => clearInterval(interval);
  }, [token]);

  // Declarative chat polling effect
  useEffect(() => {
    handleCancelChatImage();
    if (!activeChatSession) {
      setChatMessages([]);
      return;
    }

    const sessionId = activeChatSession.id;

    // Clear messages immediately when switching to avoid showing old/stuck messages
    setChatMessages([]);

    // Fetch messages immediately when active chat changes
    fetchChatMessages(sessionId);

    // Setup Polling every 3 seconds
    const interval = setInterval(() => {
      pollChatMessages(sessionId);
    }, 3000);

    return () => {
      clearInterval(interval);
    };
  }, [activeChatSession?.id]);

  // Scroll to bottom on new messages
  useEffect(() => {
    if (chatEndRef.current) {
      chatEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [chatMessages]);

  // Fetch foto profil konselor via axios agar header ngrok ter-include
  useEffect(() => {
    const url = getBuktiUrl(konselorForm.foto_profil);
    if (!url) {
      setKonselorPhotoBlobUrl(null);
      return;
    }
    let currentBlobUrl = null;
    let cancelled = false;
    axios.get(url, { responseType: 'blob' })
      .then(res => {
        if (cancelled) return;
        const blob = URL.createObjectURL(res.data);
        currentBlobUrl = blob;
        setKonselorPhotoBlobUrl(blob);
      })
      .catch(() => {
        if (!cancelled) setKonselorPhotoBlobUrl(null);
      });
    return () => {
      cancelled = true;
      if (currentBlobUrl) URL.revokeObjectURL(currentBlobUrl);
    };
  }, [konselorForm.foto_profil]);

  const fetchDashboardData = async (silent = false) => {
    if (!silent) setLoading(true);
    if (!silent) setError('');
    try {
      const currentUser = user || JSON.parse(localStorage.getItem('admin_user'));
      const isSuper = currentUser && currentUser.role === 'superadmin';

      // Super Admin: daftar konselor, data mahasiswa, dan data super admin.
      if (isSuper) {
        const [konselorRes, mhsRes, superRes] = await Promise.all([
          axios.get('/konselor'),
          axios.get('/mahasiswa'),
          axios.get('/superadmin'),
        ]);
        if (konselorRes.data.success) setAllCounselors(konselorRes.data.data);
        if (mhsRes.data.success) setUsers(mhsRes.data.data);
        if (superRes.data.success) setSuperAdmins(superRes.data.data);
        return;
      }

      const baseRequests = [
        axios.get('/laporan'),
        axios.get('/jadwal'),
        axios.get('/konseling'),
        axios.get('/mahasiswa'),
      ];
      if (!silent) baseRequests.push(axios.get('/konselor/me'));

      const results = await Promise.all(baseRequests);
      const [repRes, schedRes, sessRes, mhsRes, lastRes] = results;

      if (repRes.data.success) setReports(repRes.data.data);
      if (sessRes.data.success) setSessions(sessRes.data.data);
      if (mhsRes.data.success) setUsers(mhsRes.data.data);

      let myProfile = myProfileDataRef.current;
      if (lastRes && lastRes.data.success) {
        myProfile = lastRes.data.data;
        myProfileDataRef.current = myProfile;
        setMyProfileData(myProfile);
        applyMyKonselorProfile(myProfile);
        setKonselorLoaded(true);
      } else if (!myProfile) {
        myProfile = user;
      }

      if (schedRes.data.success) {
        const allScheds = schedRes.data.data;
        if (myProfile) {
          const practiceDays = myProfile.practice_days || [];
          const availableTimes = (myProfile.available_times || []).map(normalizeTimeStr);

          const myScheds = allScheds.filter(s => {
            const weekday = getWeekdayFromDateString(s.tanggal);

            if (!practiceDays.includes(weekday)) return false;

            const startNorm = normalizeTimeStr(s.jam_mulai);
            return availableTimes.includes(startNorm);
          });
          setSchedules(myScheds);
        } else {
          setSchedules(allScheds);
        }
      }
    } catch (err) {
      console.error(err);
      if (!silent) setError('Gagal memuat data dari server.');
    } finally {
      if (!silent) setLoading(false);
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      const response = await axios.post('/login', {
        email: loginEmail,
        password: loginPassword,
      });

      if (response.data.success) {
        const loggedInUser = response.data.data.user;
        const userToken = response.data.data.token;

        if (loggedInUser.role !== 'admin' && loggedInUser.role !== 'superadmin') {
          setError('Akses ditolak. Halaman ini hanya untuk Administrator.');
          setLoading(false);
          return;
        }

        localStorage.setItem('admin_token', userToken);
        localStorage.setItem('admin_user', JSON.stringify(loggedInUser));
        setToken(userToken);
        setUser(loggedInUser);
        setActiveTab(loggedInUser.role === 'superadmin' ? 'konselor' : 'dashboard');
        setSuccess('Login berhasil!');
      } else {
        setError(response.data.message || 'Login gagal.');
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Email atau password salah.');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    setLogoutLoading(true);
    try {
      await axios.post('/logout');
    } catch (err) {
      console.error('Logout error on server', err);
    } finally {
      localStorage.removeItem('admin_token');
      localStorage.removeItem('admin_user');
      setToken(null);
      setUser(null);
      setActiveChatSession(null);
      setChatMessages([]);
      setLogoutLoading(false);
      setShowLogoutConfirm(false);
    }
  };

  // Report Moderation Actions
  const handleUpdateReportStatus = async (reportId, newStatus) => {
    setReportStatusUpdating(newStatus);
    try {
      const res = await axios.post(`/laporan/${reportId}/status`, { status: newStatus });
      if (res.data.success) {
        // Update reports in list
        setReports(reports.map(r => r.id === reportId ? { ...r, status: newStatus } : r));

        // Show premium success alert
        setSuccessAlertMsg(`Status laporan berhasil diperbarui menjadi "${newStatus}".`);
        setShowSuccessAlert(true);

        // Close detail modal (redirects to list)
        setSelectedReport(null);

        // Auto close after 2.5 seconds
        setTimeout(() => {
          setShowSuccessAlert(false);
        }, 2500);
      }
    } catch {
      setError('Gagal memperbarui status laporan.');
    } finally {
      setReportStatusUpdating(null);
    }
  };

  const handleStartChatForReport = async (report) => {
    if (!report?.pelapor_id) return;
    setLoadingChatForReport(true);
    setError('');
    try {
      const res = await axios.post(`/laporan/${report.id}/chat`);
      if (res.data.success) {
        const session = res.data.data;
        setSelectedReport(null);
        if (!sessions.some(s => s.id === session.id)) {
          setSessions(prev => [session, ...prev]);
        }
        startChatSession(session);
      }
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.message || 'Gagal memulai chat dengan pelapor.');
    } finally {
      setLoadingChatForReport(false);
    }
  };

  const syncProfileDaysAndTimes = async (updatedSchedules) => {
    const practiceDays = Array.from(new Set(updatedSchedules.map(s => getWeekdayFromDateString(s.tanggal))));

    const availableTimes = Array.from(new Set(updatedSchedules.map(s => {
      const startNorm = normalizeTimeStr(s.jam_mulai);
      return `${startNorm} WIB`;
    })));

    const payload = {
      nama: konselorForm.nama,
      spesialisasi: konselorForm.spesialisasi,
      rating: parseFloat(konselorForm.rating) || 5.0,
      pengalaman_tahun: konselorForm.pengalaman_tahun,
      tentang: konselorForm.tentang,
      spesialisasi_list: konselorForm.spesialisasi_list.split(',').map((s) => s.trim()).filter(Boolean),
      jam_tersedia: availableTimes,
      hari_praktik: practiceDays,
      nomor_telepon: konselorForm.nomor_telepon || null,
      pendidikan: konselorForm.pendidikan.filter((r) => r.title || r.subtitle),
      pengalaman: konselorForm.pengalaman.filter((r) => r.title || r.subtitle),
      foto_profil: konselorForm.foto_profil || null,
    };

    try {
      const res = await axios.post('/konselor/me', payload);
      if (res.data.success) {
        applyMyKonselorProfile(res.data.data);
        myProfileDataRef.current = res.data.data;
        setMyProfileData(res.data.data);
      }
    } catch (err) {
      console.error('Gagal menyinkronkan hari praktik & jam tersedia:', err);
    }
  };

  // Schedule Management Actions
  const handleAddSchedule = async (e) => {
    e.preventDefault();
    const existingDates = new Set(schedules.map(s => String(s.tanggal).substring(0, 10)));
    const isNewDay = !existingDates.has(newSchedDate);
    if (isNewDay && existingDates.size >= 3) {
      setError('Maksimal hanya boleh memiliki 3 hari jadwal yang berbeda.');
      return;
    }
    setAddSchedLoading(true);
    try {
      const res = await axios.post('/jadwal', {
        tanggal: newSchedDate,
        jam_mulai: newSchedStart,
        jam_selesai: newSchedEnd,
        lokasi: newSchedLoc
      });
      if (res.data.success) {
        setSuccess('Jadwal berhasil ditambahkan.');
        const updated = [...schedules, res.data.data];
        setSchedules(updated);
        await syncProfileDaysAndTimes(updated);
        await fetchDashboardData(true);
        setNewSchedDate('');
        setNewSchedStart('');
        setNewSchedEnd('');
        setNewSchedLoc('');
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal menambahkan jadwal.');
    } finally {
      setAddSchedLoading(false);
    }
  };

  const promptDeleteSchedule = (schedId) => {
    setSchedIdToDelete(schedId);
    setShowDeleteSchedConfirm(true);
  };

  const confirmDeleteSchedule = async () => {
    if (!schedIdToDelete) return;
    setDeleteSchedLoading(true);
    setError('');
    try {
      const res = await axios.delete(`/jadwal/${schedIdToDelete}`);
      if (res.data.success) {
        setSuccess('Jadwal berhasil dihapus.');
        const updated = schedules.filter(s => s.id !== schedIdToDelete);
        setSchedules(updated);
        await syncProfileDaysAndTimes(updated);
        await fetchDashboardData(true);
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal menghapus jadwal.');
    } finally {
      setDeleteSchedLoading(false);
      setShowDeleteSchedConfirm(false);
      setSchedIdToDelete(null);
    }
  };

  // Counseling Booking Actions
  const handleUpdateSessionStatus = async (sessionId, newStatus) => {
    if (newStatus === 'Selesai') {
      setSelesaiSessionId(sessionId);
      setCatatanKonselor('');
      setRekomendasiPemulihan('');
      setShowSelesaiModal(true);
      return;
    }
    try {
      const res = await axios.post(`/konseling/${sessionId}/status`, { status: newStatus });
      if (res.data.success) {
        setSuccess(`Sesi konseling berhasil diupdate menjadi ${newStatus}`);
        fetchDashboardData();
        if (selectedSession && selectedSession.id === sessionId) {
          setSelectedSession({ ...selectedSession, status: newStatus, admin_id: user.id, admin: user });
        }
        if (activeChatSession && activeChatSession.id === sessionId && (newStatus === 'Selesai' || newStatus === 'Dibatalkan')) {
          setActiveChatSession(null);
          setChatMessages([]);
        }
      }
    } catch {
      setError('Gagal memperbarui status sesi konseling.');
    }
  };

  const handleSubmitSelesaiSession = async (e) => {
    e.preventDefault();
    if (!catatanKonselor.trim() || !rekomendasiPemulihan.trim()) {
      setError('Catatan Sesi dan Rekomendasi Pemulihan wajib diisi!');
      return;
    }
    try {
      const res = await axios.post(`/konseling/${selesaiSessionId}/status`, {
        status: 'Selesai',
        catatan_konselor: catatanKonselor,
        rekomendasi_pemulihan: rekomendasiPemulihan,
      });
      if (res.data.success) {
        setSuccess('Sesi konseling berhasil diselesaikan.');
        setShowSelesaiModal(false);
        fetchDashboardData();
        if (selectedSession && selectedSession.id === selesaiSessionId) {
          setSelectedSession({
            ...selectedSession,
            status: 'Selesai',
            admin_id: user.id,
            admin: user,
            catatan_konselor: catatanKonselor,
            rekomendasi_pemulihan: rekomendasiPemulihan,
          });
        }
        if (activeChatSession && activeChatSession.id === selesaiSessionId) {
          setActiveChatSession(null);
          setChatMessages([]);
        }
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal menyelesaikan sesi konseling.');
    }
  };

  // Konselor (Profil Sendiri) Actions
  const applyMyKonselorProfile = (d) => {
    setKonselorForm({
      nama: d.name || '',
      email: '',
      password: '',
      nomor_telepon: d.nomor_telepon || '',
      spesialisasi: d.specialty || '',
      rating: d.rating || '5.0',
      pengalaman_tahun: d.experience_years || '',
      tentang: d.about || '',
      spesialisasi_list: (d.specialties || []).join(', '),
      jam_tersedia: (d.available_times || []).join(', '),
      hari_praktik: d.practice_days || [],
      foto_profil: d.foto_profil || '',
      is_online: !!d.is_online,
      pendidikan: d.educations || [],
      pengalaman: d.experiences || [],
    });
  };

  const setKonselorField = (key, value) => setKonselorForm((f) => ({ ...f, [key]: value }));

  const updateKonselorRow = (field, idx, key, value) => {
    setKonselorForm((f) => {
      const rows = [...f[field]];
      rows[idx] = { ...rows[idx], [key]: value };
      return { ...f, [field]: rows };
    });
  };
  const addKonselorRow = (field) =>
    setKonselorForm((f) => ({ ...f, [field]: [...f[field], { title: '', subtitle: '' }] }));
  const removeKonselorRow = (field, idx) =>
    setKonselorForm((f) => ({ ...f, [field]: f[field].filter((_, i) => i !== idx) }));

  const handleSaveKonselor = async (e) => {
    e.preventDefault();
    setKonselorSaving(true);
    setKonselorFormError('');
    const f = konselorForm;

    const practiceDays = Array.from(new Set(schedules.map(s => getWeekdayFromDateString(s.tanggal))));

    const availableTimes = Array.from(new Set(schedules.map(s => {
      const startNorm = normalizeTimeStr(s.jam_mulai);
      return `${startNorm} WIB`;
    })));

    const payload = {
      nama: f.nama,
      spesialisasi: f.spesialisasi,
      rating: parseFloat(f.rating) || 5.0,
      pengalaman_tahun: f.pengalaman_tahun,
      tentang: f.tentang,
      spesialisasi_list: f.spesialisasi_list.split(',').map((s) => s.trim()).filter(Boolean),
      jam_tersedia: availableTimes,
      hari_praktik: practiceDays,
      nomor_telepon: f.nomor_telepon || null,
      pendidikan: f.pendidikan.filter((r) => r.title || r.subtitle),
      pengalaman: f.pengalaman.filter((r) => r.title || r.subtitle),
      foto_profil: f.foto_profil || null,
    };
    try {
      const res = await axios.post('/konselor/me', payload);
      if (res.data.success) {
        applyMyKonselorProfile(res.data.data);
        myProfileDataRef.current = res.data.data;
        setMyProfileData(res.data.data);
        setSuccess('Profil konselor Anda berhasil diperbarui.');
      }
    } catch (err) {
      setKonselorFormError(err.response?.data?.message || 'Gagal menyimpan profil konselor.');
    } finally {
      setKonselorSaving(false);
    }
  };

  const handleProfilePhotoChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const objectUrl = URL.createObjectURL(file);
    setProfilePhotoPreview(objectUrl);
    setProfilePhotoUploading(true);
    setKonselorFormError('');
    try {
      const formData = new FormData();
      formData.append('foto_profil', file);
      const res = await axios.post('/konselor/me/photo', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      if (res.data.success) {
        const newUrl = res.data.data.foto_profil;
        // Update form & semua ref agar polling tidak menimpa foto baru
        setKonselorField('foto_profil', newUrl);
        if (myProfileDataRef.current) {
          myProfileDataRef.current = { ...myProfileDataRef.current, foto_profil: newUrl };
        }
        setMyProfileData(prev => prev ? { ...prev, foto_profil: newUrl } : prev);
        setSuccess('Foto profil berhasil diperbarui.');
        // Tetap tampilkan blob lokal; hanya ganti ke server URL setelah gambar berhasil dimuat
        const img = new Image();
        img.onload = () => {
          setProfilePhotoPreview(null);
          URL.revokeObjectURL(objectUrl);
        };
        img.onerror = () => {
          // Jika server URL gagal dimuat, tetap pakai blob preview
        };
        img.src = newUrl;
      }
    } catch (err) {
      setKonselorFormError(err.response?.data?.message || 'Gagal mengupload foto profil.');
      URL.revokeObjectURL(objectUrl);
      setProfilePhotoPreview(null);
    } finally {
      setProfilePhotoUploading(false);
      e.target.value = '';
    }
  };

  const handleRegisterAdmin = async (e) => {
    e.preventDefault();
    setAdminRegisterError('');
    setAdminRegisterSuccess('');
    const pwd = newAdminForm.password;
    if (pwd.length < 8) {
      setAdminRegisterError('Password minimal 8 karakter.');
      return;
    }
    if (!/\d/.test(pwd)) {
      setAdminRegisterError('Password harus mengandung setidaknya satu angka.');
      return;
    }
    if (!/[@#$%^&*!_]/.test(pwd)) {
      setAdminRegisterError('Password harus mengandung karakter khusus (@, #, $, %, ^, &, *, !, _).');
      return;
    }
    setAdminRegistering(true);
    try {
      // POST /konselor membuat user sesuai role yang dipilih (admin / superadmin).
      const res = await axios.post('/konselor', {
        nama: newAdminForm.nama,
        email: newAdminForm.email,
        password: newAdminForm.password,
        nomor_telepon: newAdminForm.nomor_telepon || null,
        role: newAdminForm.role,
      });

      if (res.data.success) {
        setAdminRegisterSuccess(res.data.message || 'Akun baru berhasil didaftarkan!');
        setNewAdminForm({ nama: '', email: '', password: '', nomor_telepon: '', role: 'admin' });
        fetchDashboardData();
      }
    } catch (err) {
      console.error(err);
      setAdminRegisterError(err.response?.data?.message || 'Registrasi admin gagal.');
    } finally {
      setAdminRegistering(false);
    }
  };

  const handleOpenEditModal = (counselor) => {
    setEditingCounselor(counselor);
    setEditForm({
      nama: counselor.name || '',
      email: counselor.email || '',
      password: '',
      nomor_telepon: counselor.nomor_telepon || '',
      role: counselor.role || 'admin'
    });
    setShowEditPassword(false);
    setShowEditModal(true);
  };

  const handleSaveEditCounselor = async (e) => {
    e.preventDefault();
    setError('');
    if (editForm.password) {
      const pwd = editForm.password;
      if (pwd.length < 8) {
        setError('Password minimal 8 karakter.');
        return;
      }
      if (!/\d/.test(pwd)) {
        setError('Password harus mengandung setidaknya satu angka.');
        return;
      }
      if (!/[@#$%^&*!_]/.test(pwd)) {
        setError('Password harus mengandung karakter khusus (@, #, $, %, ^, &, *, !, _).');
        return;
      }
    }
    setLoading(true);
    try {
      const payload = {
        nama: editForm.nama,
        email: editForm.email,
        nomor_telepon: editForm.nomor_telepon,
        role: editForm.role,
      };
      if (editForm.password) {
        payload.password = editForm.password;
      }
      
      const res = await axios.post(`/konselor/${editingCounselor.id}`, payload);
      if (res.data.success) {
        setSuccess('Data admin/konselor berhasil diperbarui.');
        setShowEditModal(false);
        fetchDashboardData();
      }
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.message || 'Gagal memperbarui data.');
    } finally {
      setLoading(false);
    }
  };

  const promptDeleteCounselor = (id) => {
    setCounselorIdToDelete(id);
    setShowDeleteCounselorConfirm(true);
  };

  const confirmDeleteCounselor = async () => {
    if (!counselorIdToDelete) return;
    setDeleteCounselorLoading(true);
    setError('');
    try {
      const res = await axios.delete(`/konselor/${counselorIdToDelete}`);
      if (res.data.success) {
        setSuccess('Akun berhasil dihapus.');
        setShowDeleteCounselorConfirm(false);
        setCounselorIdToDelete(null);
        fetchDashboardData();
      }
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.message || 'Gagal menghapus akun.');
    } finally {
      setDeleteCounselorLoading(false);
    }
  };

  const handleResetPasswordPrompt = (u) => {
    setResettingUser(u);
    setResetPasswordForm({ password: '', showPassword: false });
    setShowResetPasswordModal(true);
  };

  const handleSaveResetPassword = async (e) => {
    e.preventDefault();
    const pwd = resetPasswordForm.password;
    if (pwd.length < 8) {
      setError('Kata sandi minimal 8 karakter.');
      return;
    }
    if (!/\d/.test(pwd)) {
      setError('Kata sandi harus mengandung setidaknya satu angka.');
      return;
    }
    if (!/[@#$%^&*!_]/.test(pwd)) {
      setError('Kata sandi harus mengandung karakter khusus (@, #, $, _).');
      return;
    }
    setLoading(true);
    setError('');
    try {
      const res = await axios.post(`/mahasiswa/${resettingUser.id}/reset-password`, {
        password: pwd,
      });
      if (res.data.success) {
        setSuccessAlertMsg(`Kata sandi mahasiswa "${resettingUser.nama}" berhasil direset.`);
        setShowSuccessAlert(true);
        setShowResetPasswordModal(false);
        fetchDashboardData();
        setTimeout(() => {
          setShowSuccessAlert(false);
        }, 2500);
      }
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.message || 'Gagal mereset kata sandi.');
    } finally {
      setLoading(false);
    }
  };

  // Live Chat Logic
  const startChatSession = (session) => {
    setChatMessages([]);
    setActiveChatSession(session);
    setActiveTab('chat');
  };

  const fetchChatMessages = async (sessionId) => {
    try {
      const res = await axios.get(`/chat/${sessionId}`);
      if (res.data.success) {
        const messages = res.data.data;
        const updatedStatus = res.data.status;
        setChatMessages(messages);
        setSessions(prev => prev.map(s => {
          if (s.id === sessionId) {
            return {
              ...s,
              status: updatedStatus || s.status,
              pesan: messages
            };
          }
          return s;
        }));
        setActiveChatSession(prev => {
          if (prev && prev.id === sessionId) {
            if (prev.status === updatedStatus) {
              return prev;
            }
            return {
              ...prev,
              status: updatedStatus || prev.status
            };
          }
          return prev;
        });
      }
    } catch (err) {
      console.error('Gagal mengambil pesan chat:', err);
    }
  };

  const pollChatMessages = async (sessionId) => {
    try {
      const res = await axios.get(`/chat/${sessionId}`);
      if (res.data.success) {
        const messages = res.data.data;
        const updatedStatus = res.data.status;
        setChatMessages(messages);
        setSessions(prev => prev.map(s => {
          if (s.id === sessionId) {
            return {
              ...s,
              status: updatedStatus || s.status,
              pesan: messages
            };
          }
          return s;
        }));
        setActiveChatSession(prev => {
          if (prev && prev.id === sessionId) {
            if (prev.status === updatedStatus) {
              return prev;
            }
            return {
              ...prev,
              status: updatedStatus || prev.status
            };
          }
          return prev;
        });
      }
    } catch (err) {
      console.error('Error polling messages:', err);
    }
  };

  const handleSendChatMessage = async (e) => {
    e.preventDefault();
    if (!newMessageText.trim() && !chatImageFile) return;
    if (!activeChatSession) return;
    const txt = newMessageText;
    const imgFile = chatImageFile;
    setNewMessageText('');
    handleCancelChatImage();
    try {
      let res;
      if (imgFile) {
        const formData = new FormData();
        formData.append('konseling_id', activeChatSession.id);
        formData.append('isi_pesan', txt || 'Lampiran Gambar');
        formData.append('gambar', imgFile);
        res = await axios.post('/chat', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        });
      } else {
        res = await axios.post('/chat', {
          konseling_id: activeChatSession.id,
          isi_pesan: txt
        });
      }
      if (res.data.success) {
        const newMsg = res.data.data;
        setChatMessages(prev => [...prev, newMsg]);
        setSessions(prev => prev.map(s => {
          if (s.id === activeChatSession.id) {
            return {
              ...s,
              pesan: s.pesan ? [...s.pesan, newMsg] : [newMsg]
            };
          }
          return s;
        }));
      }
    } catch {
      setError('Gagal mengirim pesan.');
    }
  };

  // Auto-dismiss Alerts
  useEffect(() => {
    if (success) {
      const t = setTimeout(() => setSuccess(''), 4000);
      return () => clearTimeout(t);
    }
  }, [success]);

  if (!token) {
    return (
      <div className="login-container">
        <div className="card login-card">
          <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
            <div style={{ margin: '0 auto 1rem', display: 'flex', justifyContent: 'center' }}>
              <LogoIcon size={60} />
            </div>
            <h1 className="logo-text" style={{ fontSize: '1.75rem', background: 'linear-gradient(to right, var(--primary), var(--secondary))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>Polinema Care+</h1>
            <p style={{ color: 'var(--text-secondary)', marginTop: '0.5rem' }}>Administrator Login Portal</p>
          </div>

          {error && <div style={{ background: 'var(--danger-bg)', border: '1px solid var(--danger-border)', padding: '0.75rem 1rem', borderRadius: '8px', color: 'var(--danger)', marginBottom: '1.5rem', fontSize: '0.9rem' }}>{error}</div>}

          <form onSubmit={handleLogin}>
            <div className="form-group">
              <label>Email Admin</label>
              <input
                type="email"
                placeholder="admin@gmail.com"
                value={loginEmail}
                onChange={(e) => setLoginEmail(e.target.value)}
                required
              />
            </div>
            <div className="form-group" style={{ marginBottom: '2rem' }}>
              <label>Password</label>
              <input
                type="password"
                placeholder="••••••"
                value={loginPassword}
                onChange={(e) => setLoginPassword(e.target.value)}
                required
              />
            </div>
            <button className="btn btn-primary" type="submit" style={{ width: '100%' }} disabled={loading}>
              {loading ? 'Menghubungkan...' : 'Sign In'}
            </button>
          </form>
        </div>
      </div>
    );
  }

  const hasNewReports = reports.some(r => r.status === 'Menunggu');
  const hasNewSessions = sessions.some(s => s.status === 'Diajukan');
  const hasUnreadChats = sessions.some(s => 
    (s.status === 'Diterima' || s.status === 'Berlangsung') &&
    s.pesan?.some(m => m.sender_id !== user?.id && m.status_pesan === 'Terkirim')
  );

  return (
    <div className="app-container">
      {/* Sidebar */}
      <aside className={`sidebar ${sidebarCollapsed ? 'collapsed' : ''}`}>
        <div className="sidebar-header" style={{ display: 'flex', alignItems: 'center', justifyContent: sidebarCollapsed ? 'center' : 'space-between', marginBottom: '2rem', width: '100%' }}>
          {!sidebarCollapsed && (
            <div style={{ display: 'flex', alignItems: 'center', gap: '0.85rem' }}>
              <LogoIcon size={32} />
              <span className="logo-text" style={{ fontSize: '1.2rem', fontWeight: '700', background: 'linear-gradient(to right, var(--primary), var(--secondary))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>Polinema Care+</span>
            </div>
          )}
          <button className="sidebar-toggle-btn" onClick={toggleSidebar} style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer', padding: '6px', borderRadius: '8px', display: 'flex', alignItems: 'center', justifyContent: 'center', transition: 'var(--transition-fast)' }} title={sidebarCollapsed ? "Buka Menu" : "Tutup Menu"}>
            <IconMenu />
          </button>
        </div>
        <nav style={{ width: '100%' }}>
          <ul className="menu-list">
            {user && user.role === 'superadmin' ? (
              <>
                <li className={`menu-item ${activeTab === 'konselor' ? 'active' : ''}`} onClick={() => { setActiveTab('konselor'); setActiveChatSession(null); }} title={sidebarCollapsed ? "Kelola Admin & Konselor" : ""}>
                  <IconCounselor />
                  {!sidebarCollapsed && <span>Kelola Admin & Konselor</span>}
                </li>
                <li className={`menu-item ${activeTab === 'users' ? 'active' : ''}`} onClick={() => { setActiveTab('users'); setActiveChatSession(null); }} title={sidebarCollapsed ? "Data Mahasiswa" : ""}>
                  <IconUsers />
                  {!sidebarCollapsed && <span>Data Mahasiswa</span>}
                </li>
                <li className={`menu-item ${activeTab === 'superadmin' ? 'active' : ''}`} onClick={() => { setActiveTab('superadmin'); setActiveChatSession(null); }} title={sidebarCollapsed ? "Data Super Admin" : ""}>
                  <IconShieldUser />
                  {!sidebarCollapsed && <span>Data Super Admin</span>}
                </li>
              </>
            ) : (
              <>
                <li className={`menu-item ${activeTab === 'dashboard' ? 'active' : ''}`} onClick={() => { setActiveTab('dashboard'); setActiveChatSession(null); }} title={sidebarCollapsed ? "Dashboard" : ""}>
                  <IconDashboard />
                  {!sidebarCollapsed && <span>Dashboard</span>}
                </li>
                <li className={`menu-item ${activeTab === 'konselor' ? 'active' : ''}`} onClick={() => { setActiveTab('konselor'); setActiveChatSession(null); }} title={sidebarCollapsed ? "Profil Konselor Saya" : ""}>
                  <IconCounselor />
                  {!sidebarCollapsed && <span>Profil Konselor Saya</span>}
                </li>
                <li className={`menu-item ${activeTab === 'laporan' ? 'active' : ''}`} onClick={() => { setActiveTab('laporan'); setActiveChatSession(null); }} style={sidebarCollapsed ? { justifyContent: 'center' } : { display: 'flex', justifyContent: 'space-between', alignItems: 'center' }} title={sidebarCollapsed ? "Laporan Perundungan" : ""}>
                  {sidebarCollapsed ? (
                    <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                      <IconReport />
                      {hasNewReports && (
                        <span style={{ position: 'absolute', top: '-4px', right: '-4px', width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#ef4444' }} />
                      )}
                    </div>
                  ) : (
                    <>
                      <span style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                        <IconReport />
                        <span>Laporan Perundungan</span>
                      </span>
                      {hasNewReports && (
                        <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#ef4444', marginRight: '8px' }} />
                      )}
                    </>
                  )}
                </li>

                <li className={`menu-item ${activeTab === 'konseling' ? 'active' : ''}`} onClick={() => { setActiveTab('konseling'); setActiveChatSession(null); }} style={sidebarCollapsed ? { justifyContent: 'center' } : { display: 'flex', justifyContent: 'space-between', alignItems: 'center' }} title={sidebarCollapsed ? "Pemesanan Konseling" : ""}>
                  {sidebarCollapsed ? (
                    <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                      <IconBooking />
                      {hasNewSessions && (
                        <span style={{ position: 'absolute', top: '-4px', right: '-4px', width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#ef4444' }} />
                      )}
                    </div>
                  ) : (
                    <>
                      <span style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                        <IconBooking />
                        <span>Pemesanan Konseling</span>
                      </span>
                      {hasNewSessions && (
                        <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#ef4444', marginRight: '8px' }} />
                      )}
                    </>
                  )}
                </li>
                <li className={`menu-item ${activeTab === 'chat' ? 'active' : ''}`} onClick={() => { setActiveTab('chat'); }} style={sidebarCollapsed ? { justifyContent: 'center' } : { display: 'flex', justifyContent: 'space-between', alignItems: 'center' }} title={sidebarCollapsed ? "Chat Konseling" : ""}>
                  {sidebarCollapsed ? (
                    <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
                      <IconChat />
                      {hasUnreadChats && (
                        <span style={{ position: 'absolute', top: '-4px', right: '-4px', width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#ef4444' }} />
                      )}
                    </div>
                  ) : (
                    <>
                      <span style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                        <IconChat />
                        <span>Chat Konseling</span>
                      </span>
                      {hasUnreadChats && (
                        <span style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#ef4444', marginRight: '8px' }} />
                      )}
                    </>
                  )}
                </li>
                <li className={`menu-item ${activeTab === 'users' ? 'active' : ''}`} onClick={() => { setActiveTab('users'); setActiveChatSession(null); }} title={sidebarCollapsed ? "Data Mahasiswa" : ""}>
                  <IconUsers />
                  {!sidebarCollapsed && <span>Data Mahasiswa</span>}
                </li>
              </>
            )}
            <li className="menu-item logout-btn" onClick={() => setShowLogoutConfirm(true)} style={{ marginTop: sidebarCollapsed ? '2rem' : '3rem' }} title={sidebarCollapsed ? "Sign Out" : ""}>
              <IconSignOut />
              {!sidebarCollapsed && <span>Sign Out</span>}
            </li>
          </ul>
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className={`main-content ${sidebarCollapsed ? 'sidebar-collapsed' : ''}`}>
        <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '1rem' }}>
          <div>
            <h1 style={{ fontSize: '1.75rem', fontWeight: '700' }}>
              {activeTab === 'dashboard' && 'Dashboard Overview'}
              {activeTab === 'konselor' && (user && user.role === 'superadmin' ? 'Kelola Admin & Konselor' : 'Profil Konselor Saya')}
              {activeTab === 'laporan' && 'Laporan Perundungan'}

              {activeTab === 'konseling' && 'Daftar Pengajuan & Sesi Konseling'}
              {activeTab === 'chat' && 'Ruang Chat Konseling'}
              {activeTab === 'users' && 'Daftar Mahasiswa Terdaftar'}
              {activeTab === 'superadmin' && 'Data Super Admin'}
            </h1>
            <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', marginTop: '0.25rem' }}>Selamat datang kembali, {user.nama} ({user && user.role === 'superadmin' ? 'Super Admin' : 'Admin'})</p>
          </div>
          <button className="btn btn-secondary btn-sm" onClick={() => fetchDashboardData(false)} disabled={loading} style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
            <IconRefresh spinning={loading} /> Refresh Data
          </button>
        </header>

        {/* Global Notifications */}
        {success && (
          <div style={{ background: 'var(--success-bg)', border: '1px solid var(--success-border)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--success)', marginBottom: '1.5rem', fontSize: '0.95rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <IconCheckCircle size={18} /> {success}
          </div>
        )}
        {error && (
          <div style={{ background: 'var(--danger-bg)', border: '1px solid var(--danger-border)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--danger)', marginBottom: '1.5rem', fontSize: '0.95rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <IconWarning size={18} /> {error}
          </div>
        )}

        {/* LOADING INDICATOR / SKELETON WIREFRAME */}
        {loading ? (
          <SkeletonWireframe activeTab={activeTab} isSuper={user && user.role === 'superadmin'} />
        ) : (
          <>
            {/* TAB 1: DASHBOARD */}
            {activeTab === 'dashboard' && (
          <>
            <div className="grid-stats">
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Total Laporan</h3>
                  <p>{reports.length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'var(--info-bg)', color: 'var(--info)' }}><IconStatLaporan /></div>
              </div>
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Menunggu Verifikasi</h3>
                  <p>{reports.filter(r => r.status === 'Menunggu').length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'var(--warning-bg)', color: 'var(--warning)' }}><IconStatVerifikasi /></div>
              </div>
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Konseling Aktif</h3>
                  <p>{sessions.filter(s => s.status === 'Diterima' || s.status === 'Berlangsung').length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'var(--primary-glow)', color: 'var(--primary)' }}><IconStatKonseling /></div>
              </div>
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Slot Jadwal Tersedia</h3>
                  <p>{schedules.filter(s => s.status === 'Tersedia').length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'var(--success-bg)', color: 'var(--success)' }}><IconStatJadwal /></div>
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
        )}

        {/* TAB: PROFIL KONSELOR SAYA */}
        {activeTab === 'konselor' && (
          user && user.role === 'superadmin' ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '2rem' }}>
              {/* Ringkasan jumlah konselor terdaftar */}
              <div className="grid-stats">
                <div className="card stat-card">
                  <div className="stat-info">
                    <h3>Total Admin / Konselor Terdaftar</h3>
                    <p>{allCounselors.length}</p>
                  </div>
                  <div className="stat-icon" style={{ background: 'var(--info-bg)', color: 'var(--info)' }}><IconStatKonseling /></div>
                </div>
                <div className="card stat-card">
                  <div className="stat-info">
                    <h3>Sedang Online</h3>
                    <p>{allCounselors.filter(c => c.is_online).length}</p>
                  </div>
                  <div className="stat-icon" style={{ background: 'var(--success-bg)', color: 'var(--success)' }}><IconCounselor /></div>
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
                              <img
                                src={getBuktiUrl(c.foto_profil) || `https://i.pravatar.cc/40?u=${encodeURIComponent(c.name)}`}
                                alt={c.name}
                                style={{ width: '32px', height: '32px', borderRadius: '50%', objectFit: 'cover' }}
                                onError={(e) => { e.target.src = 'https://via.placeholder.com/40?text=P'; }}
                              />
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
          ) : (
            <div className="card" style={{ maxWidth: '800px', margin: '0 auto' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '1.5rem', marginBottom: '2rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '1.5rem' }}>
                <div
                  style={{ position: 'relative', width: '80px', height: '80px', flexShrink: 0, cursor: 'pointer' }}
                  onClick={() => !profilePhotoUploading && photoInputRef.current?.click()}
                  title="Klik untuk ubah foto profil"
                >
                  <img
                    src={profilePhotoPreview || konselorPhotoBlobUrl || `https://i.pravatar.cc/120?u=${encodeURIComponent(konselorForm.nama)}`}
                    alt={konselorForm.nama}
                    style={{ width: '80px', height: '80px', borderRadius: '50%', objectFit: 'cover', border: '3px solid var(--primary)', display: 'block', opacity: profilePhotoUploading ? 0.5 : 1, transition: 'opacity 0.2s' }}
                    onError={(e) => { e.target.src = 'https://via.placeholder.com/120?text=Profile'; }}
                  />
                  <div style={{
                    position: 'absolute', bottom: 2, right: 2,
                    width: '24px', height: '24px', borderRadius: '50%',
                    background: 'var(--primary)',
                    border: '2px solid #fff',
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    pointerEvents: 'none',
                  }}>
                    {profilePhotoUploading ? (
                      <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" style={{ animation: 'spin 1s linear infinite' }}><path d="M21.5 2v6h-6"/><path d="M21.34 15.57a10 10 0 1 1-.57-8.38"/></svg>
                    ) : (
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
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
                    {(() => {
                      const existingDatesSet = new Set(schedules.map(s => String(s.tanggal).substring(0, 10)));
                      const uniqueDayCount = existingDatesSet.size;
                      const isDateNew = newSchedDate && !existingDatesSet.has(newSchedDate);
                      const isMaxDayReached = uniqueDayCount >= 3 && isDateNew;
                      const isFormDisabled = addSchedLoading;
                      return (
                        <>
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
                        </>
                      );
                    })()}

                    {/* Current slots list */}
                    {schedules.length > 0 && (
                      <div style={{ marginTop: '1.5rem', borderTop: '1px solid rgba(16, 104, 163, 0.08)', paddingTop: '1.25rem' }}>
                        <h4 style={{ fontSize: '0.9rem', fontWeight: '600', marginBottom: '0.75rem', color: 'var(--text-secondary)' }}>
                          Daftar Slot Jadwal Aktif
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
          )
        )}

        {/* TAB 2: LAPORAN PERUNDUNGAN */}
        {activeTab === 'laporan' && (
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
                  {/* Kiri: Info jumlah */}
                  <div style={{ color: 'var(--text-secondary)', fontSize: '0.9rem' }}>
                    Menampilkan {filteredReports.length === 0 ? 0 : indexOfFirstReport + 1}–{Math.min(indexOfLastReport, filteredReports.length)} dari {filteredReports.length} laporan
                  </div>

                  {/* Kanan: Tombol paginasi */}
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
        )}



        {/* TAB 4: PEMESANAN KONSELING */}
        {activeTab === 'konseling' && (
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
                  {sessions.filter(s => s.tipe !== 'laporan').map(s => (
                    <tr key={s.id}>
                      <td style={{ fontWeight: '700', color: 'var(--primary)' }}>Q-{s.nomor_antrian || '0'}</td>
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
                  {sessions.filter(s => s.tipe !== 'laporan').length === 0 && (
                    <tr><td colSpan="7" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada pengajuan konseling.</td></tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* TAB 5: CHAT ROOM */}
        {activeTab === 'chat' && (
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
        )}

        {/* TAB 6: USERS */}
        {activeTab === 'users' && (
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
        )}

        {/* TAB: DATA SUPER ADMIN */}
        {activeTab === 'superadmin' && (
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
        )}
          </>
        )}
      </main>

      {/* DETAIL MODAL: LAPORAN PERUNDUNGAN */}
      {selectedReport && (
        <div className="modal-overlay" onClick={() => setSelectedReport(null)}>
          <div className="modal-content" onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.75rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.75rem' }}>
              <h2 style={{ fontSize: '1.25rem', fontWeight: '700', background: 'linear-gradient(135deg, var(--primary), var(--secondary))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', margin: 0 }}>Detail Laporan Perundungan</h2>
              <button className="modal-close-btn" onClick={() => setSelectedReport(null)}><IconX size={14} /></button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
              <div className="info-item">
                <span className="info-label">Judul Pelaporan</span>
                <span className="info-value-highlight">{selectedReport.judul_pelaporan}</span>
              </div>

              <div className="info-grid">
                <div className="info-item">
                  <span className="info-label">Nama Pelapor</span>
                  <span className="info-value">{selectedReport.pelapor?.nama || 'Mahasiswa'}</span>
                </div>
                <div className="info-item">
                  <span className="info-label">NIM / Prodi</span>
                  <span className="info-value">{selectedReport.pelapor?.profil_mahasiswa?.nim || '-'} ({selectedReport.pelapor?.profil_mahasiswa?.program_studi || '-'})</span>
                </div>
              </div>

              <div className="info-grid">
                <div className="info-item">
                  <span className="info-label">Tanggal Kejadian / Waktu</span>
                  <span className="info-value">
                    {selectedReport.tanggal_kejadian ? (
                      (() => {
                        const d = new Date(selectedReport.tanggal_kejadian);
                        const dateFormatted = d.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
                        const hasTime = selectedReport.tanggal_kejadian.includes(':') || selectedReport.tanggal_kejadian.includes('T');
                        if (hasTime) {
                          const timeFormatted = d.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' });
                          return `${dateFormatted}, ${timeFormatted}`;
                        }
                        return dateFormatted;
                      })()
                    ) : '-'}
                  </span>
                </div>
                <div className="info-item">
                  <span className="info-label">Lokasi</span>
                  <span className="info-value">{selectedReport.lokasi || '-'}</span>
                </div>
              </div>

              <div className="info-item">
                <span className="info-label">Jenis Perundungan</span>
                <div style={{ display: 'inline-flex' }}>
                  <span className="badge badge-pending" style={{ fontSize: '0.8rem', textTransform: 'none', padding: '0.35rem 0.85rem', display: 'flex', alignItems: 'center', gap: '0.25rem' }}>
                    <IconWarning size={14} style={{ color: 'var(--warning)' }} /> {selectedReport.jenis_perundungan || '-'}
                  </span>
                </div>
              </div>

              <div className="info-item">
                <span className="info-label">Kronologi Kejadian</span>
                <div className="premium-text-block">{selectedReport.kronologi}</div>
              </div>

              {selectedReport.deskripsi_pelaku && (
                <div className="info-item">
                  <span className="info-label">Deskripsi Pelaku</span>
                  <div className="premium-text-block">{selectedReport.deskripsi_pelaku}</div>
                </div>
              )}

              <div className="info-item">
                <span className="info-label">Lampiran Bukti</span>
                <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.25rem' }}>
                  {selectedReport.bukti?.map(b => {
                    const url = getBuktiUrl(b.path_file);
                    const type = getBuktiType(b.nama_file || b.path_file);
                    return (
                      <button
                        key={b.id}
                        onClick={() => {
                          if (type === 'other') {
                            window.open(url, '_blank', 'noopener,noreferrer');
                          } else {
                            setPreviewBukti({ url, name: b.nama_file || 'File Bukti', type });
                          }
                        }}
                        className="attachment-link"
                        style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 0, font: 'inherit' }}
                      >
                        <IconPaperclip size={14} /> {b.nama_file || 'File Bukti'}
                      </button>
                    );
                  })}
                  {(!selectedReport.bukti || selectedReport.bukti.length === 0) && (
                    <p style={{ color: 'var(--text-muted)', fontSize: '0.9rem', margin: 0 }}>Tidak ada lampiran bukti diunggah.</p>
                  )}
                </div>
              </div>

              <div style={{ marginTop: '1rem', borderTop: '1px solid var(--border-color)', paddingTop: '1.25rem' }}>
                <style>{`
                  @keyframes spin {
                    to { transform: rotate(360deg); }
                  }
                `}</style>
                <span className="info-label" style={{ marginBottom: '0.75rem', display: 'block' }}>Moderasi Status Laporan</span>
                <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
                  {selectedReport.status === 'Menunggu' && (
                    <>
                      <button
                        className="btn btn-primary btn-sm"
                        onClick={() => handleUpdateReportStatus(selectedReport.id, 'Diterima')}
                        disabled={reportStatusUpdating !== null}
                        style={{ background: 'var(--primary)', color: '#fff', border: 'none', position: 'relative', minWidth: '95px', padding: '0.5rem 1rem' }}
                      >
                        {reportStatusUpdating === 'Diterima' ? (
                          <>
                            <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                            Terima...
                          </>
                        ) : 'Terima'}
                      </button>

                      <button
                        className="btn btn-danger btn-sm"
                        onClick={() => handleUpdateReportStatus(selectedReport.id, 'Ditolak')}
                        disabled={reportStatusUpdating !== null}
                        style={{ position: 'relative', minWidth: '85px', padding: '0.5rem 1rem' }}
                      >
                        {reportStatusUpdating === 'Ditolak' ? (
                          <>
                            <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                            Tolak...
                          </>
                        ) : 'Tolak'}
                      </button>
                    </>
                  )}

                  {(selectedReport.status === 'Diterima' || selectedReport.status === 'Diproses') && (
                    <>
                      <button
                        className="btn btn-secondary btn-sm"
                        onClick={() => handleStartChatForReport(selectedReport)}
                        disabled={loadingChatForReport}
                        style={{ background: 'var(--primary)', color: '#fff', border: 'none', position: 'relative', minWidth: '140px', padding: '0.5rem 1rem', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.4rem' }}
                      >
                        {loadingChatForReport ? (
                          <>
                            <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                            Menghubungkan...
                          </>
                        ) : (
                          <>
                            <IconMessageSquare size={16} /> Hubungi Pelapor
                          </>
                        )}
                      </button>

                      {selectedReport.status === 'Diterima' && (
                        <button
                          className="btn btn-sm"
                          onClick={() => handleUpdateReportStatus(selectedReport.id, 'Diproses')}
                          disabled={reportStatusUpdating !== null}
                          style={{ background: '#6b7280', color: '#fff', border: 'none', position: 'relative', minWidth: '95px', padding: '0.5rem 1rem' }}
                        >
                          {reportStatusUpdating === 'Diproses' ? (
                            <>
                              <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                              Proses...
                            </>
                          ) : 'Proses'}
                        </button>
                      )}

                      <button
                        className="btn btn-primary btn-sm"
                        style={{ background: 'var(--success)', position: 'relative', minWidth: '115px', padding: '0.5rem 1rem' }}
                        onClick={() => handleUpdateReportStatus(selectedReport.id, 'Selesai')}
                        disabled={reportStatusUpdating !== null}
                      >
                        {reportStatusUpdating === 'Selesai' ? (
                          <>
                            <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                            Selesai...
                          </>
                        ) : 'Selesaikan'}
                      </button>

                      <button
                        className="btn btn-danger btn-sm"
                        onClick={() => handleUpdateReportStatus(selectedReport.id, 'Ditolak')}
                        disabled={reportStatusUpdating !== null}
                        style={{ position: 'relative', minWidth: '85px', padding: '0.5rem 1rem' }}
                      >
                        {reportStatusUpdating === 'Ditolak' ? (
                          <>
                            <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                            Tolak...
                          </>
                        ) : 'Tolak'}
                      </button>
                    </>
                  )}

                  {(selectedReport.status === 'Selesai' || selectedReport.status === 'Ditolak') && (
                    <span style={{ color: 'var(--text-secondary)', fontStyle: 'italic', fontSize: '0.9rem' }}>
                      Laporan ini telah selesai/ditutup.
                    </span>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* PREVIEW BUKTI MODAL */}
      {previewBukti && (
        <div
          style={{
            position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.88)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            zIndex: 9999, padding: '1rem',
          }}
          onClick={() => setPreviewBukti(null)}
        >
          <div
            style={{
              background: '#1a1a1a', borderRadius: '12px', overflow: 'hidden',
              maxWidth: '90vw', maxHeight: '90vh', display: 'flex', flexDirection: 'column',
              minWidth: previewBukti.type === 'audio' ? '320px' : 'auto',
            }}
            onClick={e => e.stopPropagation()}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0.6rem 1rem', borderBottom: '1px solid #333', gap: '1rem' }}>
              <span style={{ color: '#d1d5db', fontSize: '0.82rem', fontWeight: 600, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', maxWidth: '260px' }}>
                {previewBukti.name}
              </span>
              <button
                onClick={() => setPreviewBukti(null)}
                style={{ background: 'none', border: 'none', color: '#9ca3af', cursor: 'pointer', padding: '2px', display: 'flex', alignItems: 'center', flexShrink: 0 }}
              >
                <IconX size={18} />
              </button>
            </div>
            <div style={{ overflow: 'auto', flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '0.75rem' }}>
              {previewBukti.type === 'image' && (
                <img
                  src={previewBukti.url}
                  alt={previewBukti.name}
                  style={{ maxWidth: '80vw', maxHeight: '70vh', objectFit: 'contain', borderRadius: '6px', display: 'block' }}
                  onError={() => console.error('[preview] img failed:', previewBukti.url)}
                />
              )}
              {previewBukti.type === 'video' && (
                <iframe
                  key={previewBukti.url}
                  src={previewBukti.url}
                  title={previewBukti.name}
                  allow="autoplay"
                  style={{ width: '80vw', maxWidth: '860px', height: '60vh', border: 'none', borderRadius: '6px', background: '#000', display: 'block' }}
                />
              )}
              {previewBukti.type === 'audio' && (
                <div style={{ padding: '1.5rem 2rem', textAlign: 'center', width: '100%' }}>
                  <div style={{ fontSize: '2.5rem', marginBottom: '0.75rem' }}>🎵</div>
                  <audio
                    key={previewBukti.url}
                    src={previewBukti.url}
                    controls
                    style={{ width: '100%', minWidth: '260px', maxWidth: '400px' }}
                    onError={() => console.error('[preview] audio failed:', previewBukti.url)}
                  />
                </div>
              )}
            </div>
          </div>
        </div>
      )}

      {/* DETAIL MODAL: PEMESANAN KONSELING */}
      {selectedSession && (
        <div className="modal-overlay" onClick={() => setSelectedSession(null)}>
          <div className="modal-content" onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.75rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.75rem' }}>
              <h2 style={{ fontSize: '1.25rem', fontWeight: '700', background: 'linear-gradient(135deg, var(--primary), var(--secondary))', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', margin: 0 }}>Detail Sesi Konseling</h2>
              <button className="modal-close-btn" onClick={() => setSelectedSession(null)}><IconX size={14} /></button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span className="info-label">Nomor Antrian</span>
                <span style={{ fontSize: '1.35rem', fontWeight: '800', color: 'var(--primary)' }}>Q-{selectedSession.nomor_antrian}</span>
              </div>

              <div className="info-grid">
                <div className="info-item">
                  <span className="info-label">Mahasiswa</span>
                  <span className="info-value">{selectedSession.mahasiswa?.nama}</span>
                </div>
                <div className="info-item">
                  <span className="info-label">NIM / Prodi</span>
                  <span className="info-value">{selectedSession.mahasiswa?.profil_mahasiswa?.nim || '-'} ({selectedSession.mahasiswa?.profil_mahasiswa?.program_studi || '-'})</span>
                </div>
              </div>

              <div className="info-item">
                <span className="info-label">Jadwal Konseling</span>
                {selectedSession.jadwal_konseling ? (
                  <div style={{ padding: '0.85rem', background: 'rgba(16, 104, 163, 0.03)', border: '1px dashed rgba(16, 104, 163, 0.2)', borderRadius: '10px', fontSize: '0.95rem', lineHeight: '1.6', display: 'flex', flexDirection: 'column', gap: '0.4rem' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                      <IconCalendar size={14} style={{ color: 'var(--primary)' }} />
                      <span>{new Date(selectedSession.jadwal_konseling.tanggal).toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</span>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                      <IconClock size={14} style={{ color: 'var(--primary)' }} />
                      <span>{selectedSession.jadwal_konseling.jam_mulai.substring(0, 5)} - {selectedSession.jadwal_konseling.jam_selesai.substring(0, 5)}</span>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                      <IconMapPin size={14} style={{ color: 'var(--primary)' }} />
                      <span>{selectedSession.jadwal_konseling.lokasi || 'TBA'}</span>
                    </div>
                  </div>
                ) : (
                  <span className="info-value" style={{ color: 'var(--text-muted)' }}>Jadwal dihapus</span>
                )}
              </div>

              <div className="info-item">
                <span className="info-label">Keluhan Mahasiswa</span>
                <div className="premium-text-block">{selectedSession.keluhan || 'Tidak ada keluhan tertulis'}</div>
              </div>

              <div className="info-grid">
                <div className="info-item">
                  <span className="info-label">Konselor (Admin)</span>
                  <span className="info-value">{selectedSession.admin?.nama || 'Belum ditugaskan'}</span>
                </div>
                <div className="info-item">
                  <span className="info-label">Status Konseling</span>
                  <div style={{ display: 'inline-flex' }}>
                    <span className={`badge ${selectedSession.status === 'Diajukan' ? 'badge-pending' :
                      selectedSession.status === 'Diterima' ? 'badge-process' :
                        selectedSession.status === 'Berlangsung' ? 'badge-process' :
                          selectedSession.status === 'Selesai' ? 'badge-success' : 'badge-danger'
                      }`} style={{ fontSize: '0.75rem', padding: '0.35rem 0.85rem' }}>{selectedSession.status}</span>
                  </div>
                </div>
              </div>

              <div style={{ marginTop: '1rem', borderTop: '1px solid var(--border-color)', paddingTop: '1.25rem' }}>
                <span className="info-label" style={{ marginBottom: '0.75rem', display: 'block' }}>Tindakan Admin</span>
                <div style={{ display: 'flex', gap: '0.5rem', marginTop: '0.5rem', flexWrap: 'wrap' }}>
                  {selectedSession.status === 'Diajukan' && (
                    <button className="btn btn-primary btn-sm" style={{ padding: '0.5rem 1rem' }} onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Diterima')}>Terima Pengajuan</button>
                  )}
                  {selectedSession.status === 'Diterima' && (
                    <>
                      <button className="btn btn-primary btn-sm" style={{ padding: '0.5rem 1rem' }} onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Berlangsung')}>Mulai Konseling</button>
                      <button className="btn btn-secondary btn-sm" style={{ padding: '0.5rem 1rem' }} onClick={() => { setSelectedSession(null); startChatSession(selectedSession); }}>Buka Chat</button>
                    </>
                  )}
                  {selectedSession.status === 'Berlangsung' && (
                    <>
                      <button className="btn btn-primary btn-sm" style={{ background: 'var(--success)', padding: '0.5rem 1rem' }} onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Selesai')}>Selesaikan Konseling</button>
                      <button className="btn btn-secondary btn-sm" style={{ padding: '0.5rem 1rem' }} onClick={() => { setSelectedSession(null); startChatSession(selectedSession); }}>Buka Chat</button>
                    </>
                  )}
                  {selectedSession.status !== 'Selesai' && selectedSession.status !== 'Dibatalkan' && (
                    <button className="btn btn-danger btn-sm" style={{ padding: '0.5rem 1rem' }} onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Dibatalkan')}>Batalkan</button>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* EDIT MODAL: ADMIN / KONSELOR */}
      {showEditModal && editingCounselor && (
        <div className="modal-overlay" onClick={() => setShowEditModal(false)}>
          <div className="card modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: '500px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.5rem' }}>
              <h2 style={{ fontSize: '1.2rem' }}>Edit Akun Admin / Konselor</h2>
              <button className="btn btn-secondary btn-sm" onClick={() => setShowEditModal(false)} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}><IconX size={14} /></button>
            </div>

            <form onSubmit={handleSaveEditCounselor} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              <div className="form-group">
                <label>Nama Lengkap *</label>
                <input
                  type="text"
                  value={editForm.nama}
                  onChange={e => setEditForm({ ...editForm, nama: e.target.value })}
                  required
                />
              </div>

              <div className="form-group">
                <label>Email *</label>
                <input
                  type="email"
                  value={editForm.email}
                  onChange={e => setEditForm({ ...editForm, email: e.target.value })}
                  required
                />
              </div>

              <div className="form-group">
                <label>Password (Kosongkan jika tidak diubah)</label>
                <div style={{ position: 'relative' }}>
                  <input
                    type={showEditPassword ? 'text' : 'password'}
                    placeholder="Min. 8 karakter, angka, dan karakter khusus"
                    value={editForm.password}
                    onChange={e => setEditForm({ ...editForm, password: e.target.value })}
                    style={{ paddingRight: '2.75rem' }}
                  />
                  <button
                    type="button"
                    onClick={() => setShowEditPassword(v => !v)}
                    style={{ position: 'absolute', right: '0.75rem', top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', cursor: 'pointer', color: 'var(--text-secondary)', padding: 0, display: 'flex', alignItems: 'center' }}
                  >
                    {showEditPassword ? <IconEyeOff size={16} /> : <IconEye size={16} />}
                  </button>
                </div>
              </div>

              <div className="form-group">
                <label>Nomor Telepon</label>
                <input
                  type="text"
                  value={editForm.nomor_telepon}
                  onChange={e => setEditForm({ ...editForm, nomor_telepon: e.target.value })}
                  placeholder="cth: 08123456789"
                />
              </div>

              <div className="form-group">
                <label>Role *</label>
                <select
                  value={editForm.role}
                  onChange={e => setEditForm({ ...editForm, role: e.target.value })}
                  required
                >
                  <option value="admin">Admin / Konselor</option>
                  <option value="superadmin">Super Admin</option>
                </select>
              </div>

              <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end', marginTop: '1rem' }}>
                <button type="button" className="btn btn-secondary" onClick={() => setShowEditModal(false)}>Batal</button>
                <button type="submit" className="btn btn-primary">Simpan Perubahan</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* PREMIUM SUCCESS ALERT MODAL */}
      {showSuccessAlert && (
        <div className="modal-overlay" style={{ zIndex: 1100 }}>
          <div className="card modal-content" style={{ maxWidth: '380px', padding: '2rem', textAlign: 'center', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '1.25rem', border: '1px solid rgba(16, 185, 129, 0.3)', boxShadow: '0 0 30px rgba(16, 185, 129, 0.15)' }}>
            <style>{`
              @keyframes scaleUp {
                from { transform: scale(0.85); opacity: 0; }
                to { transform: scale(1); opacity: 1; }
              }
            `}</style>
            <div style={{
              width: '64px',
              height: '64px',
              borderRadius: '50%',
              background: 'rgba(16, 185, 129, 0.12)',
              border: '2px solid var(--success)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: 'var(--success)',
              boxShadow: '0 0 15px rgba(16, 185, 129, 0.2)',
              animation: 'scaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)'
            }}>
              <IconCheck size={28} />
            </div>
            <div>
              <h3 style={{ fontSize: '1.25rem', fontWeight: '700', color: '#fff', marginBottom: '0.5rem' }}>Berhasil!</h3>
              <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: '1.5' }}>
                {successAlertMsg}
              </p>
            </div>
            <button
              className="btn btn-primary btn-sm"
              style={{ width: '100%', background: 'var(--success)', boxShadow: '0 4px 12px rgba(16, 185, 129, 0.3)', border: 'none', marginTop: '0.5rem' }}
              onClick={() => setShowSuccessAlert(false)}
            >
              Kembali ke Daftar
            </button>
          </div>
        </div>
      )}

      {/* RESET PASSWORD MODAL: MAHASISWA */}
      {showResetPasswordModal && resettingUser && (
        <div className="modal-overlay" onClick={() => setShowResetPasswordModal(false)} style={{ zIndex: 1100 }}>
          <div className="card modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: '500px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.5rem' }}>
              <h2 style={{ fontSize: '1.2rem' }}>Reset Kata Sandi Mahasiswa</h2>
              <button className="btn btn-secondary btn-sm" onClick={() => setShowResetPasswordModal(false)} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}><IconX size={14} /></button>
            </div>

            <form onSubmit={handleSaveResetPassword} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.25rem', padding: '0.75rem', backgroundColor: 'var(--bg-secondary)', borderRadius: '8px', border: '1px solid var(--border-color)' }}>
                <span style={{ fontSize: '0.85rem', color: 'var(--text-secondary)' }}>Mahasiswa:</span>
                <strong style={{ color: 'var(--text-primary)' }}>{resettingUser.nama}</strong>
                <span style={{ fontSize: '0.85rem', color: 'var(--text-secondary)' }}>NIM: {resettingUser.profil_mahasiswa?.nim || resettingUser.nim || '-'}</span>
              </div>

              {error && (
                <div style={{ padding: '0.65rem 0.9rem', backgroundColor: '#fff0f0', border: '1px solid #ffcdd2', borderRadius: '8px', color: '#c62828', fontSize: '0.85rem', fontWeight: '500' }}>
                  {error}
                </div>
              )}

              <div className="form-group" style={{ marginBottom: 0 }}>
                <label>Kata Sandi Baru *</label>
                <div style={{ position: 'relative' }}>
                  <input
                    type={resetPasswordForm.showPassword ? 'text' : 'password'}
                    placeholder="Masukkan minimal 8 karakter"
                    value={resetPasswordForm.password}
                    onChange={e => { setResetPasswordForm(prev => ({ ...prev, password: e.target.value })); setError(''); }}
                    required
                    style={{ paddingRight: '2.75rem' }}
                  />
                  <button
                    type="button"
                    onClick={() => setResetPasswordForm(prev => ({ ...prev, showPassword: !prev.showPassword }))}
                    style={{ position: 'absolute', right: '0.75rem', top: '50%', transform: 'translateY(-50%)', background: 'none', border: 'none', cursor: 'pointer', color: 'var(--text-secondary)', padding: 0, display: 'flex', alignItems: 'center' }}
                  >
                    {resetPasswordForm.showPassword ? <IconEyeOff size={16} /> : <IconEye size={16} />}
                  </button>
                </div>

                {resetPasswordForm.password.length > 0 && (() => {
                  const pwd = resetPasswordForm.password;
                  const hasMin = pwd.length >= 8;
                  const hasNum = /\d/.test(pwd);
                  const hasSpecial = /[@#$%^&*!_]/.test(pwd);
                  const score = (hasMin ? 1 : 0) + (hasNum ? 1 : 0) + (hasSpecial ? 1 : 0);
                  const label = score <= 1 ? 'Lemah' : score === 2 ? 'Sedang' : 'Kuat';
                  const color = score <= 1 ? '#E53935' : score === 2 ? '#2A7B8A' : '#2A9B6E';
                  return (
                    <div style={{ marginTop: '0.85rem' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem', marginBottom: '0.4rem' }}>
                        <span style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', fontWeight: '500' }}>Kekuatan:</span>
                        <span style={{ fontSize: '0.8rem', fontWeight: '700', color }}>{label}</span>
                      </div>
                      <div style={{ display: 'flex', gap: '4px', marginBottom: '0.75rem' }}>
                        {[0, 1, 2].map(i => (
                          <div key={i} style={{ flex: 1, height: '4px', borderRadius: '4px', backgroundColor: i < score ? color : 'var(--border-color)', transition: 'background-color 0.2s' }} />
                        ))}
                      </div>
                      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.35rem' }}>
                        {[
                          { label: 'Minimal 8 karakter', ok: hasMin },
                          { label: 'Mengandung setidaknya satu angka', ok: hasNum },
                          { label: 'Mengandung karakter khusus (@, #, $, _)', ok: hasSpecial },
                        ].map(({ label: lbl, ok }) => (
                          <div key={lbl} style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                            <span style={{ fontSize: '15px', color: ok ? '#2A9B6E' : 'var(--text-secondary)', lineHeight: 1 }}>{ok ? '✓' : '○'}</span>
                            <span style={{ fontSize: '0.78rem', color: ok ? '#2A9B6E' : 'var(--text-secondary)', fontWeight: ok ? '600' : '400' }}>{lbl}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  );
                })()}
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem', marginTop: '0.5rem', borderTop: '1px solid var(--border-color)', paddingTop: '1rem' }}>
                <button type="button" className="btn btn-secondary" onClick={() => setShowResetPasswordModal(false)}>Batal</button>
                <button type="submit" className="btn btn-primary" disabled={loading}>
                  {loading ? 'Menyimpan...' : 'Reset Kata Sandi'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* SELESAI SESI FORM MODAL */}
      {showSelesaiModal && (
        <div className="modal-overlay" onClick={() => setShowSelesaiModal(false)} style={{ zIndex: 1100 }}>
          <div className="card modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: '600px', width: '90%' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.5rem' }}>
              <h2 style={{ fontSize: '1.2rem', color: 'var(--success)' }}>Form Catatan Sesi & Pemulihan</h2>
              <button className="btn btn-secondary btn-sm" onClick={() => setShowSelesaiModal(false)} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}><IconX size={14} /></button>
            </div>

            <form onSubmit={handleSubmitSelesaiSession} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
              <p style={{ fontSize: '0.9rem', color: 'var(--text-secondary)', margin: 0 }}>
                Sebelum menyelesaikan sesi ini, mohon lengkapi catatan sesi konseling dan rekomendasi pemulihan untuk mahasiswa. Informasi ini akan ditampilkan di riwayat sesi mereka.
              </p>

              <div className="form-group" style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label style={{ fontWeight: '600', fontSize: '0.9rem' }}>Catatan Sesi (Rangkuman) *</label>
                <textarea
                  placeholder="Tuliskan rangkuman hasil sesi konseling..."
                  value={catatanKonselor}
                  onChange={e => setCatatanKonselor(e.target.value)}
                  style={{
                    width: '100%',
                    minHeight: '120px',
                    padding: '0.75rem',
                    borderRadius: '8px',
                    backgroundColor: 'var(--bg-secondary)',
                    border: '1px solid var(--border-color)',
                    color: 'var(--text-primary)',
                    fontFamily: 'inherit',
                    fontSize: '0.9rem',
                    resize: 'vertical'
                  }}
                  required
                />
              </div>

              <div className="form-group" style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                <label style={{ fontWeight: '600', fontSize: '0.9rem' }}>Rekomendasi Pemulihan (Tindakan Lanjut) *</label>
                <textarea
                  placeholder="Tuliskan rekomendasi tindakan atau pemulihan untuk mahasiswa..."
                  value={rekomendasiPemulihan}
                  onChange={e => setRekomendasiPemulihan(e.target.value)}
                  style={{
                    width: '100%',
                    minHeight: '120px',
                    padding: '0.75rem',
                    borderRadius: '8px',
                    backgroundColor: 'var(--bg-secondary)',
                    border: '1px solid var(--border-color)',
                    color: 'var(--text-primary)',
                    fontFamily: 'inherit',
                    fontSize: '0.9rem',
                    resize: 'vertical'
                  }}
                  required
                />
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem', marginTop: '1rem', borderTop: '1px solid var(--border-color)', paddingTop: '1rem' }}>
                <button type="button" className="btn btn-secondary" onClick={() => setShowSelesaiModal(false)}>Batal</button>
                <button type="submit" className="btn btn-primary" style={{ backgroundColor: 'var(--success)', borderColor: 'var(--success)' }}>
                  Selesaikan Sesi & Simpan Catatan
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* LOGOUT CONFIRMATION MODAL */}
      {showLogoutConfirm && (
        <div className="modal-overlay" style={{ zIndex: 1100 }}>
          <div className="card modal-content modal-logout-card">
            {logoutLoading ? (
              <>
                <div className="logout-spinner" />
                <div style={{ marginTop: '0.5rem' }}>
                  <h3 style={{ fontSize: '1.25rem', fontWeight: '700', color: '#ef4444', marginBottom: '0.5rem' }}>Sign Out</h3>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: '1.5' }}>
                    Sedang memutuskan sesi Anda dengan aman...
                  </p>
                </div>
              </>
            ) : (
              <>
                <div className="logout-icon-container">
                  <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                    <polyline points="16 17 21 12 16 7" />
                    <line x1="21" y1="12" x2="9" y2="12" />
                  </svg>
                </div>
                <div>
                  <h3 style={{ fontSize: '1.25rem', fontWeight: '700', color: '#ef4444', marginBottom: '0.5rem' }}>Sign Out</h3>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: '1.5' }}>
                    Apakah Anda yakin ingin keluar dari akun <strong>{user?.nama}</strong>? Anda harus masuk kembali untuk mengelola sistem.
                  </p>
                </div>
                <div style={{ display: 'flex', gap: '0.75rem', width: '100%', marginTop: '0.5rem' }}>
                  <button
                    type="button"
                    className="btn btn-secondary btn-logout-cancel"
                    onClick={() => setShowLogoutConfirm(false)}
                    disabled={logoutLoading}
                  >
                    Batal
                  </button>
                  <button
                    type="button"
                    className="btn btn-danger btn-logout-confirm"
                    onClick={handleLogout}
                    disabled={logoutLoading}
                  >
                    Ya, Keluar
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}
      {/* DELETE SCHEDULE CONFIRMATION MODAL */}
      {showDeleteSchedConfirm && (
        <div className="modal-overlay" style={{ zIndex: 1100 }}>
          <div className="card modal-content modal-confirm-card">
            {deleteSchedLoading ? (
              <>
                <div className="confirm-spinner" />
                <div style={{ marginTop: '0.5rem' }}>
                  <h3 style={{ fontSize: '1.25rem', fontWeight: '700', color: '#ef4444', marginBottom: '0.5rem' }}>Menghapus Jadwal</h3>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: '1.5' }}>
                    Sedang menghapus slot jadwal...
                  </p>
                </div>
              </>
            ) : (
              <>
                <div className="confirm-icon-container">
                  <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                    <polyline points="3 6 5 6 21 6" />
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                    <line x1="10" y1="11" x2="10" y2="17" />
                    <line x1="14" y1="11" x2="14" y2="17" />
                  </svg>
                </div>
                <div>
                  <h3 style={{ fontSize: '1.25rem', fontWeight: '700', color: '#ef4444', marginBottom: '0.5rem' }}>Hapus Slot Jadwal</h3>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: '1.5' }}>
                    Apakah Anda yakin ingin menghapus slot jadwal praktik ini? Tindakan ini tidak dapat dibatalkan.
                  </p>
                </div>
                <div style={{ display: 'flex', gap: '0.75rem', width: '100%', marginTop: '0.5rem' }}>
                  <button
                    type="button"
                    className="btn btn-secondary btn-confirm-no"
                    onClick={() => { setShowDeleteSchedConfirm(false); setSchedIdToDelete(null); }}
                    disabled={deleteSchedLoading}
                  >
                    Batal
                  </button>
                  <button
                    type="button"
                    className="btn btn-danger btn-confirm-yes"
                    onClick={confirmDeleteSchedule}
                    disabled={deleteSchedLoading}
                  >
                    Hapus
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}

      {/* DELETE COUNSELOR CONFIRMATION MODAL */}
      {showDeleteCounselorConfirm && (
        <div className="modal-overlay" style={{ zIndex: 1100 }}>
          <div className="card modal-content modal-confirm-card">
            {deleteCounselorLoading ? (
              <>
                <div className="confirm-spinner" />
                <div style={{ marginTop: '0.5rem' }}>
                  <h3 style={{ fontSize: '1.25rem', fontWeight: '700', color: '#ef4444', marginBottom: '0.5rem' }}>Menghapus Akun</h3>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: '1.5' }}>
                    Sedang menghapus akun admin/konselor...
                  </p>
                </div>
              </>
            ) : (
              <>
                <div className="confirm-icon-container">
                  <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                    <polyline points="3 6 5 6 21 6" />
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                    <line x1="10" y1="11" x2="10" y2="17" />
                    <line x1="14" y1="11" x2="14" y2="17" />
                  </svg>
                </div>
                <div>
                  <h3 style={{ fontSize: '1.25rem', fontWeight: '700', color: '#ef4444', marginBottom: '0.5rem' }}>Hapus Akun Konselor</h3>
                  <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: '1.5' }}>
                    Apakah Anda yakin ingin menghapus akun admin/konselor ini? Semua data terkait (jadwal, konseling, pesan) juga akan terhapus.
                  </p>
                </div>
                <div style={{ display: 'flex', gap: '0.75rem', width: '100%', marginTop: '0.5rem' }}>
                  <button
                    type="button"
                    className="btn btn-secondary btn-confirm-no"
                    onClick={() => { setShowDeleteCounselorConfirm(false); setCounselorIdToDelete(null); }}
                    disabled={deleteCounselorLoading}
                  >
                    Batal
                  </button>
                  <button
                    type="button"
                    className="btn btn-danger btn-confirm-yes"
                    onClick={confirmDeleteCounselor}
                    disabled={deleteCounselorLoading}
                  >
                    Hapus
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}

    </div>
  );
}

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

// Skeleton Loading / Wireframe Component
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

export default App;
