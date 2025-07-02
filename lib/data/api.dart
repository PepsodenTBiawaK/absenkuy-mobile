class Api {
  static const baseUrl = 'https://absenkuy.onrender.com/api';

  // AUTH
  static const login = '$baseUrl/auth/login';

  // -- Api role guru -- 
  // kelas diampu guru
  static const kelasGuru = '$baseUrl/kelas/guru';

  // siswa berdasarkan id kelas (gunakan fungsi agar bisa dinamis)
  static String siswaByKelas(int kelasId) => '$baseUrl/siswa/kelas?kelas_id=$kelasId';

  // post absensi
  static const absensi = '$baseUrl/absensi';

  //api untuk riwayat absensi berdasarkan id kelas
  static String riwayatByKelas(int kelasId) => '$baseUrl/laporan/guru/kelas/$kelasId';


  //--Api role siswa--
  //rekap absensi siswa (untuk halaman homepage siswa)
  static const laporanSiswa ='$baseUrl/laporan/saya';

}
