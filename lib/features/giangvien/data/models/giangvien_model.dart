  class GiangVien {
    final String maGV;
    final String ten;
    final String khoa;
    final String email;
    String sdt;
    String hocVi;
    String chuyenNganh;
    String gioiThieu;
    String avatarPath;

    GiangVien({
      required this.maGV,
      required this.ten,
      required this.khoa,
      required this.email,
      required this.sdt,
      required this.hocVi,
      required this.chuyenNganh,
      required this.gioiThieu,
      required this.avatarPath,
    });
  }

  // ===== DỮ LIỆU MẪU =====
  final GiangVien currentGV = GiangVien(
    maGV: "GV001",
    ten: "Nguyễn Văn A",
    khoa: "Công nghệ Thông tin",
    email: "thang@university.edu.vn",
    sdt: "0987 654 321",
    hocVi: "Thạc sĩ",
    chuyenNganh: "Phát triển phần mềm",
    gioiThieu:
    "Giảng viên có nhiều năm kinh nghiệm giảng dạy các môn Lập trình Android, Phát triển phần mềm và Quản lý dự án CNTT.",
    avatarPath: "assets/images/teacher.jpg",
  );
