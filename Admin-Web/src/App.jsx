import React, { useState, useEffect, useRef } from 'react';
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

const IconSchedule = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0 }}>
    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
    <line x1="16" y1="2" x2="16" y2="6" />
    <line x1="8" y1="2" x2="8" y2="6" />
    <line x1="3" y1="10" x2="21" y2="10" />
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
    <path d="M8 18h.01" />
    <path d="M12 18h.01" />
    <path d="M16 18h.01" />
  </svg>
);

// Configure Axios defaults
axios.defaults.baseURL = 'http://127.0.0.1:8000/api';

// Add request interceptor to attach bearer token
axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('admin_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Hari praktik untuk form konselor
const KONSELOR_DAYS = [
  { v: 1, l: 'Sen' }, { v: 2, l: 'Sel' }, { v: 3, l: 'Rab' },
  { v: 4, l: 'Kam' }, { v: 5, l: 'Jum' }, { v: 6, l: 'Sab' }, { v: 7, l: 'Min' },
];

const emptyKonselorForm = {
  nama: '', email: '', password: '', nomor_telepon: '',
  spesialisasi: '', rating: '5.0', pengalaman_tahun: '', tentang: '',
  spesialisasi_list: '', jam_tersedia: '', hari_praktik: [],
  foto_profil: '', is_online: false, pendidikan: [], pengalaman: [],
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
  const [newAdminForm, setNewAdminForm] = useState({ nama: '', email: '', password: '', nomor_telepon: '', role: 'admin' });
  const [adminRegistering, setAdminRegistering] = useState(false);
  const [adminRegisterError, setAdminRegisterError] = useState('');
  const [adminRegisterSuccess, setAdminRegisterSuccess] = useState('');

  // Edit/Delete Counselor States
  const [editingCounselor, setEditingCounselor] = useState(null);
  const [editForm, setEditForm] = useState({ nama: '', email: '', password: '', nomor_telepon: '', role: 'admin' });
  const [showEditModal, setShowEditModal] = useState(false);

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

  // Detail Modal States
  const [selectedReport, setSelectedReport] = useState(null);
  const [selectedSession, setSelectedSession] = useState(null);
  const [showSuccessAlert, setShowSuccessAlert] = useState(false);
  const [successAlertMsg, setSuccessAlertMsg] = useState('');
  const [reportStatusUpdating, setReportStatusUpdating] = useState(null);

  // Form States (New Schedule)
  const [newSchedDate, setNewSchedDate] = useState('');
  const [newSchedStart, setNewSchedStart] = useState('');
  const [newSchedEnd, setNewSchedEnd] = useState('');
  const [newSchedLoc, setNewSchedLoc] = useState('');

  // Chat Room States
  const [activeChatSession, setActiveChatSession] = useState(null);
  const [chatMessages, setChatMessages] = useState([]);
  const [newMessageText, setNewMessageText] = useState('');
  const chatEndRef = useRef(null);
  const chatPollInterval = useRef(null);

  // Check Auth & Fetch Initial Data
  useEffect(() => {
    if (token) {
      fetchDashboardData();
    }
  }, [token]);

  // Clean up chat polling when component unmounts or active chat changes
  useEffect(() => {
    return () => {
      if (chatPollInterval.current) {
        clearInterval(chatPollInterval.current);
      }
    };
  }, [activeChatSession]);

  // Scroll to bottom on new messages
  useEffect(() => {
    if (chatEndRef.current) {
      chatEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [chatMessages]);

  const fetchDashboardData = async () => {
    setLoading(true);
    setError('');
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

      const results = await Promise.all([
        axios.get('/laporan'),
        axios.get('/jadwal'),
        axios.get('/konseling'),
        axios.get('/mahasiswa'),
        axios.get('/konselor/me'),
      ]);
      const [repRes, schedRes, sessRes, mhsRes, lastRes] = results;

      if (repRes.data.success) setReports(repRes.data.data);
      if (schedRes.data.success) setSchedules(schedRes.data.data);
      if (sessRes.data.success) setSessions(sessRes.data.data);
      if (mhsRes.data.success) setUsers(mhsRes.data.data);

      if (lastRes && lastRes.data.success) {
        applyMyKonselorProfile(lastRes.data.data);
        setKonselorLoaded(true);
      }
    } catch (err) {
      console.error(err);
      setError('Gagal memuat data dari server.');
    } finally {
      setLoading(false);
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
    try {
      await axios.post('/logout');
    } catch (err) {
      console.error('Logout error on server', err);
    }
    localStorage.removeItem('admin_token');
    localStorage.removeItem('admin_user');
    setToken(null);
    setUser(null);
    setActiveChatSession(null);
    setChatMessages([]);
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
    } catch (err) {
      setError('Gagal memperbarui status laporan.');
    } finally {
      setReportStatusUpdating(null);
    }
  };

  // Schedule Management Actions
  const handleAddSchedule = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post('/jadwal', {
        tanggal: newSchedDate,
        jam_mulai: newSchedStart,
        jam_selesai: newSchedEnd,
        lokasi: newSchedLoc
      });
      if (res.data.success) {
        setSuccess('Jadwal berhasil ditambahkan.');
        setSchedules([...schedules, res.data.data]);
        setNewSchedDate('');
        setNewSchedStart('');
        setNewSchedEnd('');
        setNewSchedLoc('');
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal menambahkan jadwal.');
    }
  };

  const handleDeleteSchedule = async (schedId) => {
    if (!window.confirm('Apakah Anda yakin ingin menghapus jadwal ini?')) return;
    try {
      const res = await axios.delete(`/jadwal/${schedId}`);
      if (res.data.success) {
        setSuccess('Jadwal berhasil dihapus.');
        setSchedules(schedules.filter(s => s.id !== schedId));
      }
    } catch (err) {
      setError(err.response?.data?.message || 'Gagal menghapus jadwal.');
    }
  };

  // Counseling Booking Actions
  const handleUpdateSessionStatus = async (sessionId, newStatus) => {
    try {
      const res = await axios.post(`/konseling/${sessionId}/status`, { status: newStatus });
      if (res.data.success) {
        setSuccess(`Sesi konseling berhasil diupdate menjadi ${newStatus}`);
        fetchDashboardData();
        if (selectedSession && selectedSession.id === sessionId) {
          setSelectedSession({ ...selectedSession, status: newStatus, admin_id: user.id, admin: user });
        }
      }
    } catch (err) {
      setError('Gagal memperbarui status sesi konseling.');
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

  const toggleKonselorDay = (d) => {
    setKonselorForm((f) => ({
      ...f,
      hari_praktik: f.hari_praktik.includes(d)
        ? f.hari_praktik.filter((x) => x !== d)
        : [...f.hari_praktik, d].sort((a, b) => a - b),
    }));
  };

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
    const payload = {
      nama: f.nama,
      spesialisasi: f.spesialisasi,
      rating: parseFloat(f.rating) || 5.0,
      pengalaman_tahun: f.pengalaman_tahun,
      tentang: f.tentang,
      spesialisasi_list: f.spesialisasi_list.split(',').map((s) => s.trim()).filter(Boolean),
      jam_tersedia: f.jam_tersedia.split(',').map((s) => s.trim()).filter(Boolean),
      hari_praktik: f.hari_praktik,
      foto_profil: f.foto_profil || null,
      nomor_telepon: f.nomor_telepon || null,
      pendidikan: f.pendidikan.filter((r) => r.title || r.subtitle),
      pengalaman: f.pengalaman.filter((r) => r.title || r.subtitle),
    };
    try {
      const res = await axios.post('/konselor/me', payload);
      if (res.data.success) {
        applyMyKonselorProfile(res.data.data);
        setSuccess('Profil konselor Anda berhasil diperbarui.');
      }
    } catch (err) {
      setKonselorFormError(err.response?.data?.message || 'Gagal menyimpan profil konselor.');
    } finally {
      setKonselorSaving(false);
    }
  };

  const handleRegisterAdmin = async (e) => {
    e.preventDefault();
    setAdminRegistering(true);
    setAdminRegisterError('');
    setAdminRegisterSuccess('');
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
    setShowEditModal(true);
  };

  const handleSaveEditCounselor = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
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

  const handleDeleteCounselor = async (id) => {
    if (!window.confirm('Apakah Anda yakin ingin menghapus akun admin/konselor ini? Semua data terkait (jadwal, konseling, pesan) juga akan terhapus.')) {
      return;
    }
    setLoading(true);
    setError('');
    try {
      const res = await axios.delete(`/konselor/${id}`);
      if (res.data.success) {
        setSuccess('Akun berhasil dihapus.');
        fetchDashboardData();
      }
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.message || 'Gagal menghapus akun.');
    } finally {
      setLoading(false);
    }
  };

  // Live Chat Logic
  const startChatSession = (session) => {
    setActiveChatSession(session);
    setActiveTab('chat');
    fetchChatMessages(session.id);

    // Setup Polling every 3 seconds
    if (chatPollInterval.current) {
      clearInterval(chatPollInterval.current);
    }
    chatPollInterval.current = setInterval(() => {
      pollChatMessages(session.id);
    }, 3000);
  };

  const fetchChatMessages = async (sessionId) => {
    try {
      const res = await axios.get(`/chat/${sessionId}`);
      if (res.data.success) {
        setChatMessages(res.data.data);
      }
    } catch (err) {
      console.error('Gagal mengambil pesan chat:', err);
    }
  };

  const pollChatMessages = async (sessionId) => {
    try {
      const res = await axios.get(`/chat/${sessionId}`);
      if (res.data.success) {
        setChatMessages(res.data.data);
      }
    } catch (err) {
      console.error('Error polling messages:', err);
    }
  };

  const handleSendChatMessage = async (e) => {
    e.preventDefault();
    if (!newMessageText.trim() || !activeChatSession) return;
    const txt = newMessageText;
    setNewMessageText('');
    try {
      const res = await axios.post('/chat', {
        konseling_id: activeChatSession.id,
        isi_pesan: txt
      });
      if (res.data.success) {
        setChatMessages([...chatMessages, res.data.data]);
      }
    } catch (err) {
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
            <h1 className="logo-text" style={{ fontSize: '1.75rem', background: 'linear-gradient(to right, #ffffff, #6366f1)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>Polinema Care+</h1>
            <p style={{ color: 'var(--text-secondary)', marginTop: '0.5rem' }}>Administrator Login Portal</p>
          </div>

          {error && <div style={{ background: 'rgba(239, 68, 68, 0.15)', border: '1px solid rgba(239, 68, 68, 0.3)', padding: '0.75rem 1rem', borderRadius: '8px', color: 'var(--danger)', marginBottom: '1.5rem', fontSize: '0.9rem' }}>{error}</div>}

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

  return (
    <div className="app-container">
      {/* Sidebar */}
      <aside className="sidebar">
        <div className="logo-container" style={{ gap: '0.85rem' }}>
          <LogoIcon size={32} />
          <span className="logo-text">Polinema Care+</span>
        </div>
        <nav>
          <ul className="menu-list">
            {user && user.role === 'superadmin' ? (
              <>
                <li className={`menu-item ${activeTab === 'konselor' ? 'active' : ''}`} onClick={() => { setActiveTab('konselor'); setActiveChatSession(null); }}>
                  <IconCounselor /> Kelola Admin & Konselor
                </li>
                <li className={`menu-item ${activeTab === 'users' ? 'active' : ''}`} onClick={() => { setActiveTab('users'); setActiveChatSession(null); }}>
                  <IconUsers /> Data Mahasiswa
                </li>
                <li className={`menu-item ${activeTab === 'superadmin' ? 'active' : ''}`} onClick={() => { setActiveTab('superadmin'); setActiveChatSession(null); }}>
                  <IconShieldUser /> Data Super Admin
                </li>
              </>
            ) : (
              <>
                <li className={`menu-item ${activeTab === 'dashboard' ? 'active' : ''}`} onClick={() => { setActiveTab('dashboard'); setActiveChatSession(null); }}>
                  <IconDashboard /> Dashboard
                </li>
                <li className={`menu-item ${activeTab === 'konselor' ? 'active' : ''}`} onClick={() => { setActiveTab('konselor'); setActiveChatSession(null); }}>
                  <IconCounselor /> Profil Konselor Saya
                </li>
                <li className={`menu-item ${activeTab === 'laporan' ? 'active' : ''}`} onClick={() => { setActiveTab('laporan'); setActiveChatSession(null); }}>
                  <IconReport /> Laporan Perundungan
                </li>
                <li className={`menu-item ${activeTab === 'jadwal' ? 'active' : ''}`} onClick={() => { setActiveTab('jadwal'); setActiveChatSession(null); }}>
                  <IconSchedule /> Jadwal Konseling
                </li>
                <li className={`menu-item ${activeTab === 'konseling' ? 'active' : ''}`} onClick={() => { setActiveTab('konseling'); setActiveChatSession(null); }}>
                  <IconBooking /> Pemesanan Konseling
                </li>
                <li className={`menu-item ${activeTab === 'chat' ? 'active' : ''}`} onClick={() => { setActiveTab('chat'); }}>
                  <IconChat /> Chat Konseling
                </li>
                <li className={`menu-item ${activeTab === 'users' ? 'active' : ''}`} onClick={() => { setActiveTab('users'); setActiveChatSession(null); }}>
                  <IconUsers /> Data Mahasiswa
                </li>
              </>
            )}
            <li className="menu-item logout-btn" onClick={handleLogout} style={{ marginTop: '3rem' }}>
              <IconSignOut /> Sign Out
            </li>
          </ul>
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className="main-content">
        <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '1rem' }}>
          <div>
            <h1 style={{ fontSize: '1.75rem', fontWeight: '700' }}>
              {activeTab === 'dashboard' && 'Dashboard Overview'}
              {activeTab === 'konselor' && (user && user.role === 'superadmin' ? 'Kelola Admin & Konselor' : 'Profil Konselor Saya')}
              {activeTab === 'laporan' && 'Laporan Perundungan'}
              {activeTab === 'jadwal' && 'Manajemen Jadwal Konseling'}
              {activeTab === 'konseling' && 'Daftar Pengajuan & Sesi Konseling'}
              {activeTab === 'chat' && 'Ruang Chat Konseling'}
              {activeTab === 'users' && 'Daftar Mahasiswa Terdaftar'}
              {activeTab === 'superadmin' && 'Data Super Admin'}
            </h1>
            <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', marginTop: '0.25rem' }}>Selamat datang kembali, {user.nama} ({user && user.role === 'superadmin' ? 'Super Admin' : 'Admin'})</p>
          </div>
          <button className="btn btn-secondary btn-sm" onClick={fetchDashboardData} disabled={loading} style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
            <IconRefresh spinning={loading} /> Refresh Data
          </button>
        </header>

        {/* Global Notifications */}
        {success && (
          <div style={{ background: 'rgba(16, 185, 129, 0.15)', border: '1px solid rgba(16, 185, 129, 0.3)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--success)', marginBottom: '1.5rem', fontSize: '0.95rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <span>✅</span> {success}
          </div>
        )}
        {error && (
          <div style={{ background: 'rgba(239, 68, 68, 0.15)', border: '1px solid rgba(239, 68, 68, 0.3)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--danger)', marginBottom: '1.5rem', fontSize: '0.95rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <span>⚠️</span> {error}
          </div>
        )}

        {/* LOADING INDICATOR */}
        {loading && <div style={{ color: 'var(--primary)', fontWeight: '600', marginBottom: '1.5rem' }}>Memuat data terbaru...</div>}

        {/* TAB 1: DASHBOARD */}
        {activeTab === 'dashboard' && (
          <>
            <div className="grid-stats">
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Total Laporan</h3>
                  <p>{reports.length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'rgba(99, 102, 241, 0.15)', color: 'var(--secondary)' }}><IconStatLaporan /></div>
              </div>
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Menunggu Verifikasi</h3>
                  <p>{reports.filter(r => r.status === 'Menunggu').length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'rgba(245, 158, 11, 0.15)', color: 'var(--warning)' }}><IconStatVerifikasi /></div>
              </div>
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Konseling Aktif</h3>
                  <p>{sessions.filter(s => s.status === 'Diterima' || s.status === 'Berlangsung').length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'rgba(6, 182, 212, 0.15)', color: 'var(--primary)' }}><IconStatKonseling /></div>
              </div>
              <div className="card stat-card">
                <div className="stat-info">
                  <h3>Slot Jadwal Tersedia</h3>
                  <p>{schedules.filter(s => s.status === 'Tersedia').length}</p>
                </div>
                <div className="stat-icon" style={{ background: 'rgba(16, 185, 129, 0.15)', color: 'var(--success)' }}><IconStatJadwal /></div>
              </div>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
              <div className="card">
                <h2 style={{ fontSize: '1.2rem', marginBottom: '1rem' }}>Laporan Terbaru</h2>
                <div className="table-container">
                  <table style={{ tableLayout: 'fixed', width: '100%' }}>
                    <colgroup>
                      <col style={{ width: '18%' }} />
                      <col style={{ width: '10%' }} />
                      <col style={{ width: '25%' }} />
                      <col style={{ width: '12%' }} />
                      <col style={{ width: '13%' }} />
                      <col style={{ width: '12%' }} />
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
                          <td>{r.pelapor?.profil_mahasiswa?.nim || '-'}</td>
                          <td>{r.judul_pelaporan}</td>
                          <td>{r.jenis_perundungan || '-'}</td>
                          <td>{new Date(r.created_at).toLocaleDateString('id-ID')}</td>
                          <td>
                            <span className={`badge ${r.status === 'Menunggu' ? 'badge-pending' :
                              r.status === 'Diproses' ? 'badge-process' :
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
                  <div className="stat-icon" style={{ background: 'rgba(99, 102, 241, 0.15)', color: 'var(--secondary)' }}><IconStatKonseling /></div>
                </div>
                <div className="card stat-card">
                  <div className="stat-info">
                    <h3>Sedang Online</h3>
                    <p>{allCounselors.filter(c => c.is_online).length}</p>
                  </div>
                  <div className="stat-icon" style={{ background: 'rgba(16, 185, 129, 0.15)', color: 'var(--success)' }}><IconCounselor /></div>
                </div>
              </div>

              {/* Form Registrasi Admin Baru */}
              <div className="card" style={{ maxWidth: '600px', margin: '0 auto', width: '100%' }}>
                <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Daftarkan Akun Baru (Admin / Super Admin)</h2>
                <form onSubmit={handleRegisterAdmin} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                  {adminRegisterError && (
                    <div style={{ background: 'rgba(239, 68, 68, 0.15)', border: '1px solid rgba(239, 68, 68, 0.3)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--danger)', fontSize: '0.95rem' }}>
                      ⚠️ {adminRegisterError}
                    </div>
                  )}
                  {adminRegisterSuccess && (
                    <div style={{ background: 'rgba(16, 185, 129, 0.15)', border: '1px solid rgba(16, 185, 129, 0.3)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--success)', fontSize: '0.95rem' }}>
                      ✅ {adminRegisterSuccess}
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
                    <input
                      type="password"
                      value={newAdminForm.password}
                      onChange={e => setNewAdminForm({ ...newAdminForm, password: e.target.value })}
                      required
                      placeholder="Minimal 6 karakter"
                    />
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
                                src={c.foto_profil || `https://i.pravatar.cc/40?u=${encodeURIComponent(c.name)}`}
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
                              <button className="btn btn-danger btn-sm" onClick={() => handleDeleteCounselor(c.id)}>Hapus</button>
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
                <img
                  src={konselorForm.foto_profil || `https://i.pravatar.cc/120?u=${encodeURIComponent(konselorForm.nama)}`}
                  alt={konselorForm.nama}
                  style={{ width: '80px', height: '80px', borderRadius: '50%', objectFit: 'cover', border: '3px solid var(--primary)' }}
                  onError={(e) => { e.target.src = 'https://via.placeholder.com/120?text=Profile'; }}
                />
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
                    <div style={{ background: 'rgba(239, 68, 68, 0.15)', border: '1px solid rgba(239, 68, 68, 0.3)', padding: '0.75rem 1.25rem', borderRadius: '10px', color: 'var(--danger)', fontSize: '0.95rem' }}>
                      ⚠️ {konselorFormError}
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
                    <div className="form-group">
                      <label>URL Foto Profil</label>
                      <input value={konselorForm.foto_profil} onChange={e => setKonselorField('foto_profil', e.target.value)} placeholder="https://..." />
                    </div>
                  </div>

                  <div className="form-group">
                    <label>Tentang / Deskripsi Diri</label>
                    <textarea rows={4} value={konselorForm.tentang} onChange={e => setKonselorField('tentang', e.target.value)} placeholder="Tulis deskripsi diri atau latar belakang Anda..." />
                  </div>

                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                    <div className="form-group">
                      <label>Spesialisasi (Chips, pisah dengan koma)</label>
                      <input value={konselorForm.spesialisasi_list} onChange={e => setKonselorField('spesialisasi_list', e.target.value)} placeholder="cth: Perundungan, Trauma, Cemas" />
                    </div>
                    <div className="form-group">
                      <label>Jam Tersedia (pisah dengan koma)</label>
                      <input value={konselorForm.jam_tersedia} onChange={e => setKonselorField('jam_tersedia', e.target.value)} placeholder="cth: 09:00 WIB, 13:00 WIB" />
                    </div>
                  </div>

                  <div className="form-group">
                    <label>Hari Praktik</label>
                    <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.25rem' }}>
                      {KONSELOR_DAYS.map(d => (
                        <button
                          type="button"
                          key={d.v}
                          onClick={() => toggleKonselorDay(d.v)}
                          className={`btn btn-sm ${konselorForm.hari_praktik.includes(d.v) ? 'btn-primary' : 'btn-secondary'}`}
                          style={{ padding: '0.4rem 0.85rem' }}
                        >
                          {d.l}
                        </button>
                      ))}
                    </div>
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
                  <col style={{ width: '10%' }} />
                  <col style={{ width: '25%' }} />
                  <col style={{ width: '12%' }} />
                  <col style={{ width: '13%' }} />
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
                      <td>{r.pelapor?.profil_mahasiswa?.nim || '-'}</td>
                      <td>{r.judul_pelaporan}</td>
                      <td>{r.jenis_perundungan || '-'}</td>
                      <td>{new Date(r.created_at).toLocaleDateString('id-ID')}</td>
                      <td>
                        <span className={`badge ${r.status === 'Menunggu' ? 'badge-pending' :
                          r.status === 'Diproses' ? 'badge-process' :
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

        {/* TAB 3: JADWAL KONSELING */}
        {activeTab === 'jadwal' && (
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.5fr', gap: '1.5rem' }}>
            {/* Create Schedule Slot */}
            <div className="card">
              <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Tambah Slot Jadwal</h2>
              <form onSubmit={handleAddSchedule}>
                <div className="form-group">
                  <label>Tanggal</label>
                  <input type="date" value={newSchedDate} onChange={e => setNewSchedDate(e.target.value)} required />
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                  <div className="form-group">
                    <label>Jam Mulai</label>
                    <input type="time" value={newSchedStart} onChange={e => setNewSchedStart(e.target.value)} required />
                  </div>
                  <div className="form-group">
                    <label>Jam Selesai</label>
                    <input type="time" value={newSchedEnd} onChange={e => setNewSchedEnd(e.target.value)} required />
                  </div>
                </div>
                <div className="form-group" style={{ marginBottom: '1.5rem' }}>
                  <label>Ruangan / Lokasi</label>
                  <input type="text" placeholder="Ruang Konseling Gd. AX" value={newSchedLoc} onChange={e => setNewSchedLoc(e.target.value)} />
                </div>
                <button type="submit" className="btn btn-primary" style={{ width: '100%' }}>Simpan Slot Jadwal</button>
              </form>
            </div>

            {/* List Schedule Slots */}
            <div className="card">
              <h2 style={{ fontSize: '1.2rem', marginBottom: '1.25rem' }}>Daftar Slot Konseling</h2>
              <div className="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>Tanggal</th>
                      <th>Jam</th>
                      <th>Lokasi</th>
                      <th>Status</th>
                      <th>Aksi</th>
                    </tr>
                  </thead>
                  <tbody>
                    {schedules.map(s => (
                      <tr key={s.id}>
                        <td>{new Date(s.tanggal).toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</td>
                        <td>{s.jam_mulai.substring(0, 5)} - {s.jam_selesai.substring(0, 5)}</td>
                        <td>{s.lokasi || 'TBA'}</td>
                        <td>
                          <span className={`badge ${s.status === 'Tersedia' ? 'badge-success' :
                            s.status === 'Penuh' ? 'badge-pending' : 'badge-danger'
                            }`}>{s.status}</span>
                        </td>
                        <td>
                          <button className="btn btn-danger btn-sm" onClick={() => handleDeleteSchedule(s.id)}>Hapus</button>
                        </td>
                      </tr>
                    ))}
                    {schedules.length === 0 && (
                      <tr><td colSpan="5" style={{ textAlign: 'center', color: 'var(--text-secondary)' }}>Belum ada slot konseling dibuat.</td></tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
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
                  {sessions.map(s => (
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
                  {sessions.length === 0 && (
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
              <h2 style={{ fontSize: '1.1rem', marginBottom: '0.5rem' }}>Sesi Chat Aktif</h2>
              <div className="chat-sessions-list">
                {sessions
                  .filter(s => s.status === 'Diterima' || s.status === 'Berlangsung')
                  .map(s => (
                    <div
                      key={s.id}
                      className={`chat-session-item ${activeChatSession?.id === s.id ? 'active' : ''}`}
                      onClick={() => startChatSession(s)}
                    >
                      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.25rem' }}>
                        <strong>{s.mahasiswa?.nama}</strong>
                        <span style={{ fontSize: '0.8rem', color: 'var(--primary)', fontWeight: '600' }}>Q-{s.nomor_antrian}</span>
                      </div>
                      <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>{s.keluhan || 'Tidak ada keluhan tertulis'}</div>
                    </div>
                  ))}
                {sessions.filter(s => s.status === 'Diterima' || s.status === 'Berlangsung').length === 0 && (
                  <div style={{ color: 'var(--text-muted)', fontSize: '0.9rem', textAlign: 'center', marginTop: '2rem' }}>Tidak ada sesi konseling aktif saat ini.</div>
                )}
              </div>
            </div>

            <div className="chat-main">
              {activeChatSession ? (
                <>
                  <div className="chat-header">
                    <div>
                      <h3 style={{ fontSize: '1.1rem' }}>{activeChatSession.mahasiswa?.nama}</h3>
                      <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)' }}>NIM: {activeChatSession.mahasiswa?.profil_mahasiswa?.nim || '-'} | Status: {activeChatSession.status}</p>
                    </div>
                    <button className="btn btn-secondary btn-sm" onClick={() => handleUpdateSessionStatus(activeChatSession.id, 'Selesai')}>
                      ✔️ Selesaikan Sesi
                    </button>
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
                        <div>{msg.isi_pesan}</div>
                        <div className="message-time">
                          {new Date(msg.created_at).toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })}
                        </div>
                      </div>
                    ))}
                    <div ref={chatEndRef} />
                  </div>

                  <form className="chat-input-area" onSubmit={handleSendChatMessage}>
                    <input
                      type="text"
                      placeholder="Tulis pesan konseling di sini..."
                      value={newMessageText}
                      onChange={e => setNewMessageText(e.target.value)}
                      required
                    />
                    <button type="submit" className="btn btn-primary">Kirim</button>
                  </form>
                </>
              ) : (
                <div style={{ display: 'flex', flex: 1, alignItems: 'center', justifyContent: 'center', flexDirection: 'column', color: 'var(--text-muted)', gap: '1rem' }}>
                  <div style={{ fontSize: '3rem' }}>💬</div>
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
                    <th>Program Studi</th>
                    <th>Email</th>
                    <th>Nomor Telepon</th>
                  </tr>
                </thead>
                <tbody>
                  {users.map(u => (
                    <tr key={u.id}>
                      <td><strong>{u.nama}</strong></td>
                      <td>{u.profil_mahasiswa?.nim || u.nim || '-'}</td>
                      <td>{u.profil_mahasiswa?.program_studi || '-'}</td>
                      <td>{u.email}</td>
                      <td>{u.nomor_telepon || '-'}</td>
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
      </main>

      {/* DETAIL MODAL: LAPORAN PERUNDUNGAN */}
      {selectedReport && (
        <div className="modal-overlay" onClick={() => setSelectedReport(null)}>
          <div className="card modal-content" onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.5rem' }}>
              <h2 style={{ fontSize: '1.2rem' }}>Detail Laporan Perundungan</h2>
              <button className="btn btn-secondary btn-sm" onClick={() => setSelectedReport(null)}>✕</button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              <div>
                <strong>Judul Pelaporan:</strong>
                <p style={{ fontSize: '1.1rem', fontWeight: '500', color: 'var(--primary)', marginTop: '0.2rem' }}>{selectedReport.judul_pelaporan}</p>
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                <div>
                  <strong>Nama Pelapor:</strong>
                  <p>{selectedReport.pelapor?.nama || 'Mahasiswa'}</p>
                </div>
                <div>
                  <strong>NIM / Prodi:</strong>
                  <p>{selectedReport.pelapor?.profil_mahasiswa?.nim || '-'} ({selectedReport.pelapor?.profil_mahasiswa?.program_studi || '-'})</p>
                </div>
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                <div>
                  <strong>Tanggal Kejadian / Waktu :</strong>
                  <p>
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
                  </p>
                </div>
                <div>
                  <strong>Lokasi:</strong>
                  <p>{selectedReport.lokasi || '-'}</p>
                </div>
              </div>
              <div>
                <strong>Jenis Perundungan:</strong>
                <p>{selectedReport.jenis_perundungan || '-'}</p>
              </div>
              <div>
                <strong>Kronologi Kejadian:</strong>
                <p style={{ background: 'rgba(0,0,0,0.2)', padding: '0.75rem', borderRadius: '8px', whiteSpace: 'pre-wrap', border: '1px solid var(--border-color)', fontSize: '0.95rem' }}>{selectedReport.kronologi}</p>
              </div>
              {selectedReport.deskripsi_pelaku && (
                <div>
                  <strong>Deskripsi Pelaku:</strong>
                  <p style={{ background: 'rgba(0,0,0,0.2)', padding: '0.75rem', borderRadius: '8px', whiteSpace: 'pre-wrap', border: '1px solid var(--border-color)', fontSize: '0.95rem' }}>{selectedReport.deskripsi_pelaku}</p>
                </div>
              )}

              <div>
                <strong>Lampiran Bukti:</strong>
                <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginTop: '0.5rem' }}>
                  {selectedReport.bukti?.map(b => (
                    <a
                      key={b.id}
                      href={b.path_file}
                      target="_blank"
                      rel="noopener noreferrer"
                      style={{ padding: '0.5rem 0.85rem', background: 'rgba(255,255,255,0.05)', border: '1px solid var(--border-color)', borderRadius: '6px', fontSize: '0.85rem', textDecoration: 'none', color: 'var(--primary)', display: 'inline-flex', alignItems: 'center', gap: '0.4rem' }}
                    >
                      📎 {b.nama_file || 'File Bukti'}
                    </a>
                  ))}
                  {(!selectedReport.bukti || selectedReport.bukti.length === 0) && (
                    <p style={{ color: 'var(--text-muted)', fontSize: '0.9rem' }}>Tidak ada lampiran bukti diunggah.</p>
                  )}
                </div>
              </div>

              <div style={{ marginTop: '1rem', borderTop: '1px solid var(--border-color)', paddingTop: '1rem' }}>
                <style>{`
                  @keyframes spin {
                    to { transform: rotate(360deg); }
                  }
                `}</style>
                <strong>Moderasi Status Laporan:</strong>
                <div style={{ display: 'flex', gap: '0.5rem', marginTop: '0.5rem' }}>
                  <button
                    className="btn btn-secondary btn-sm"
                    onClick={() => handleUpdateReportStatus(selectedReport.id, 'Diproses')}
                    disabled={reportStatusUpdating !== null}
                    style={{ position: 'relative', minWidth: '90px' }}
                  >
                    {reportStatusUpdating === 'Diproses' ? (
                      <>
                        <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                        Proses...
                      </>
                    ) : 'Diproses'}
                  </button>

                  <button
                    className="btn btn-danger btn-sm"
                    onClick={() => handleUpdateReportStatus(selectedReport.id, 'Ditolak')}
                    disabled={reportStatusUpdating !== null}
                    style={{ position: 'relative', minWidth: '80px' }}
                  >
                    {reportStatusUpdating === 'Ditolak' ? (
                      <>
                        <span style={{ display: 'inline-block', width: '12px', height: '12px', border: '2px solid currentColor', borderRightColor: 'transparent', borderRadius: '50%', animation: 'spin 0.75s linear infinite', marginRight: '6px' }}></span>
                        Tolak...
                      </>
                    ) : 'Tolak'}
                  </button>

                  <button
                    className="btn btn-primary btn-sm"
                    style={{ background: 'var(--success)', position: 'relative', minWidth: '110px' }}
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
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* DETAIL MODAL: PEMESANAN KONSELING */}
      {selectedSession && (
        <div className="modal-overlay" onClick={() => setSelectedSession(null)}>
          <div className="card modal-content" onClick={e => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', borderBottom: '1px solid var(--border-color)', paddingBottom: '0.5rem' }}>
              <h2 style={{ fontSize: '1.2rem' }}>Detail Sesi Konseling</h2>
              <button className="btn btn-secondary btn-sm" onClick={() => setSelectedSession(null)}>✕</button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <strong>Nomor Antrian:</strong>
                <span style={{ fontSize: '1.2rem', fontWeight: '800', color: 'var(--primary)' }}>Q-{selectedSession.nomor_antrian}</span>
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                <div>
                  <strong>Mahasiswa:</strong>
                  <p>{selectedSession.mahasiswa?.nama}</p>
                </div>
                <div>
                  <strong>NIM / Prodi:</strong>
                  <p>{selectedSession.mahasiswa?.profil_mahasiswa?.nim || '-'} ({selectedSession.mahasiswa?.profil_mahasiswa?.program_studi || '-'})</p>
                </div>
              </div>
              <div>
                <strong>Jadwal Konseling:</strong>
                {selectedSession.jadwal_konseling ? (
                  <p>
                    📅 {new Date(selectedSession.jadwal_konseling.tanggal).toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}
                    <br />
                    🕒 {selectedSession.jadwal_konseling.jam_mulai.substring(0, 5)} - {selectedSession.jadwal_konseling.jam_selesai.substring(0, 5)}
                    <br />
                    📍 {selectedSession.jadwal_konseling.lokasi || 'TBA'}
                  </p>
                ) : 'Jadwal dihapus'}
              </div>
              <div>
                <strong>Keluhan Mahasiswa:</strong>
                <p style={{ background: 'rgba(0,0,0,0.2)', padding: '0.75rem', borderRadius: '8px', whiteSpace: 'pre-wrap', border: '1px solid var(--border-color)', fontSize: '0.95rem' }}>{selectedSession.keluhan || 'Tidak ada keluhan tertulis'}</p>
              </div>
              <div>
                <strong>Konselor (Admin):</strong>
                <p>{selectedSession.admin?.nama || 'Belum ditugaskan'}</p>
              </div>
              <div>
                <strong>Status Konseling:</strong>
                <p>
                  <span className={`badge ${selectedSession.status === 'Diajukan' ? 'badge-pending' :
                    selectedSession.status === 'Diterima' ? 'badge-process' :
                      selectedSession.status === 'Berlangsung' ? 'badge-process' :
                        selectedSession.status === 'Selesai' ? 'badge-success' : 'badge-danger'
                    }`}>{selectedSession.status}</span>
                </p>
              </div>

              <div style={{ marginTop: '1rem', borderTop: '1px solid var(--border-color)', paddingTop: '1rem' }}>
                <strong>Tindakan Admin:</strong>
                <div style={{ display: 'flex', gap: '0.5rem', marginTop: '0.5rem', flexWrap: 'wrap' }}>
                  {selectedSession.status === 'Diajukan' && (
                    <button className="btn btn-primary btn-sm" onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Diterima')}>Terima Pengajuan</button>
                  )}
                  {selectedSession.status === 'Diterima' && (
                    <>
                      <button className="btn btn-primary btn-sm" onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Berlangsung')}>Mulai Konseling</button>
                      <button className="btn btn-secondary btn-sm" onClick={() => { setSelectedSession(null); startChatSession(selectedSession); }}>Buka Chat</button>
                    </>
                  )}
                  {selectedSession.status === 'Berlangsung' && (
                    <>
                      <button className="btn btn-primary btn-sm" style={{ background: 'var(--success)' }} onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Selesai')}>Selesaikan Konseling</button>
                      <button className="btn btn-secondary btn-sm" onClick={() => { setSelectedSession(null); startChatSession(selectedSession); }}>Buka Chat</button>
                    </>
                  )}
                  {selectedSession.status !== 'Selesai' && selectedSession.status !== 'Dibatalkan' && (
                    <button className="btn btn-danger btn-sm" onClick={() => handleUpdateSessionStatus(selectedSession.id, 'Dibatalkan')}>Batalkan</button>
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
              <button className="btn btn-secondary btn-sm" onClick={() => setShowEditModal(false)}>✕</button>
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
                <input
                  type="password"
                  placeholder="Minimal 6 karakter"
                  value={editForm.password}
                  onChange={e => setEditForm({ ...editForm, password: e.target.value })}
                />
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
              fontSize: '2rem',
              color: 'var(--success)',
              boxShadow: '0 0 15px rgba(16, 185, 129, 0.2)',
              animation: 'scaleUp 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)'
            }}>
              ✓
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
          <button type="button" className="btn btn-danger btn-sm" onClick={() => onRemove(i)}>✕</button>
        </div>
      ))}
    </div>
  );
}

export default App;
