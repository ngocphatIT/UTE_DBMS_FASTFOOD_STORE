-- Create a new database called 'QUANLYCUAHANG'

-- Connect to the 'master' database to run this snippet

USE master

GO

-- Create the new database if it does not exist already

IF NOT EXISTS (

    SELECT [name]

        FROM sys.databases

        WHERE [name] = N'QUANLYCUAHANG'

)

CREATE DATABASE QUANLYCUAHANG

GO

/*
Create the table in the specified schema
*/

USE QUANLYCUAHANG;

-- Create a new table called '[NhanVien]' in schema '[dbo]'

-- Drop the table if it already exists

IF OBJECT_ID('[dbo].[NhanVien]', 'U') IS NOT NULL
    DROP TABLE [dbo].[NhanVien];
CREATE TABLE [dbo].[NhanVien]
(
    [MaNV] NCHAR(10) NOT NULL, -- Primary Key column
	[MatKhau] CHAR(20) NOT NULL,
    [TenNV] NVARCHAR(50) NOT NULL,
    [GioiTinh] TINYINT NOT NULL,
    [LoaiNV] TINYINT NOT NULL, -- 0: part-time or 1: full-time

    [Luong] INT,
    [ChucVu] TINYINT NOT NULL, -- 1: quản lý ; 2: nhân viên ; 3: pha chế ; 4: chăm sóc khách hàng

    [DaXoa] BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_NhanVien
        PRIMARY KEY (MaNV),
    CONSTRAINT Check_Luong CHECK (Luong > 0
                                  AND Luong % 1000 = 0
                                 )
);

/*
Create a new table called '[NhaCungCap]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[NhaCungCap]', 'U') IS NOT NULL
    DROP TABLE [dbo].[NhaCungCap];
CREATE TABLE [dbo].[NhaCungCap]
(
    [MaNCC] NCHAR(10) NOT NULL, -- Primary Key column

    [TenNCC] NVARCHAR(50) NOT NULL,
    [DiaChi] NVARCHAR(50) NOT NULL,
    [DaXoa] BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_NhaCungCap
        PRIMARY KEY (MaNCC)
);

/*
Create a new table called '[NguyenLieu]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[NguyenLieu]', 'U') IS NOT NULL
    DROP TABLE [dbo].[NguyenLieu];
CREATE TABLE [dbo].[NguyenLieu]
(
    [MaNL] NCHAR(10) NOT NULL,        -- Primary Key column

    [TenNL] NVARCHAR(50) NOT NULL,
    [MaNCC] NCHAR(10),
    [SoLuong] INT NOT NULL,
    [DonGia] INT NOT NULL,
    [DaXoa] BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_NguyenLieu
        PRIMARY KEY (MaNL),
    CONSTRAINT Check_SL_DG CHECK (SoLuong > 0
                                  AND DonGia > 0
                                  AND DonGia % 1000 = 0
                                 ),
    CONSTRAINT FK_MaNCC
        FOREIGN KEY (MaNCC)
        REFERENCES NhaCungCap (MaNCC) 
		ON DELETE SET NULL
		ON UPDATE CASCADE

);

/*
Create a new table called '[SanPham]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[SanPham]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SanPham];
CREATE TABLE [dbo].[SanPham]
(
    [MaSP] NCHAR(10) NOT NULL, -- Primary Key column

    [TenSP] NVARCHAR(50) NOT NULL,
    [GiaBan] INT NOT NULL,
    [ChiPhi] INT NOT NULL,
    [SoLuongTon] INT NOT NULL,
    [SoLuongDaBan] INT NOT NULL,
    [NgayCapNhat] DATE ,
    [DonViTinh] NVARCHAR(20) NOT NULL,
    [MoTa] NVARCHAR(50),
    [DaXoa] BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_SanPham
        PRIMARY KEY (MaSP),
    CONSTRAINT Check_GiaBan CHECK (GiaBan > 0
                                   AND GiaBan % 1000 = 0
                                  ),
    CONSTRAINT Check_ChiPhi CHECK (ChiPhi > 0
                                   AND ChiPhi % 1000 = 0
                                   AND ChiPhi < GiaBan
                                  ),
    CONSTRAINT Check_SoLuong CHECK (SoLuongTon >= 0
                                    AND SoLuongDaBan >= 0
                                   )
);

/*
Create a new table called '[CheBien]' in schema '[dbo]'
*/

/*
Drop the table if it already exists
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[CheBien]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CheBien];
CREATE TABLE [dbo].[CheBien]
(
    [MaSP] NCHAR(10),
    [MaNL] NCHAR(10),
    [SoLuong] INT NOT NULL,
    CONSTRAINT FK_MaSP
        FOREIGN KEY (MaSP)
        REFERENCES SanPham (MaSP)
		ON UPDATE CASCADE,    -- Foreign key

    CONSTRAINT FK_MaNL
        FOREIGN KEY (MaNL)
        REFERENCES NguyenLieu (MaNL)
		ON UPDATE CASCADE, -- Foreign key

    CONSTRAINT PK_CheBien
        PRIMARY KEY (
                        MaSP,
                        MaNL
                    ),                -- Primary Key

    CONSTRAINT Check_SL CHECK (SoLuong > 0)
);

/*
Create a new table called '[LichLamViec]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[LichLamViec]', 'U') IS NOT NULL
    DROP TABLE [dbo].[LichLamViec];
CREATE TABLE [dbo].[LichLamViec]
(
    [MaLLV] NCHAR(10) NOT NULL, -- Primary Key column

    [NgayLV] DATE NOT NULL,
    [CaLV] TINYINT NOT NULL,    -- 1,2,3 or 4

    CONSTRAINT PK_LLV
        PRIMARY KEY (MaLLV)
);

/*
Create a new table called '[ThamGiaLamViec]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[ThamGiaLamViec]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ThamGiaLamViec];
CREATE TABLE [dbo].[ThamGiaLamViec]
(
    [MaLLV] NCHAR(10),
    [MaNV] NCHAR(10),
    CONSTRAINT FK_MaLLV
        FOREIGN KEY (MaLLV)
        REFERENCES LichLamViec (MaLLV)
		ON UPDATE CASCADE, -- Foreign key

    CONSTRAINT FK_MaNV
        FOREIGN KEY (MaNV)
        REFERENCES NhanVien (MaNV)
		ON UPDATE CASCADE,     -- Foreign key

    CONSTRAINT PK_TGLV
        PRIMARY KEY (
                        MaLLV,
                        MaNV
                    )                   -- Primary Key

);

/*
Create a new table called '[MaGiamGia]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[MaGiamGia]', 'U') IS NOT NULL
    DROP TABLE [dbo].[MaGiamGia];
CREATE TABLE [dbo].[MaGiamGia]
(
    [MaGG] NCHAR(10) NOT NULL, -- Primary Key column

    [SoTienGiam] INT NOT NULL CHECK (SoTienGiam > 0),
    [Soluong] INT NOT NULL,
    CONSTRAINT PK_MaGG
        PRIMARY KEY (MaGG),
    CONSTRAINT Check_SoTien CHECK (SoTienGiam > 0
                                   AND SoTienGiam % 1000 = 0
                                  ),
    CONSTRAINT Check_SLMGG CHECK (Soluong >= 0)
);

/*
Create a new table called '[DonHangMua]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[DonHangMua]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DonHangMua];
CREATE TABLE [dbo].[DonHangMua]
(
    [MaDH] NCHAR(10) NOT NULL,      -- Primary Key column

    [NgayTao] DATE,
    [MaNV] NCHAR(10),
    [MaGG] NCHAR(10),
    [ThanhTien] INT,
        CONSTRAINT PK_DonHangMua
        PRIMARY KEY (MaDH),
    CONSTRAINT Check_ThanhTien CHECK (ThanhTien > 0),
    CONSTRAINT FK_MaNVDonHang
        FOREIGN KEY (MaNV)
        REFERENCES NhanVien (MaNV)
		ON DELETE SET NULL
		ON UPDATE CASCADE, -- Foreign key

    CONSTRAINT FK_MaGG
        FOREIGN KEY (MaGG)
        REFERENCES MaGiamGia (MaGG)
		ON DELETE SET NULL
		ON UPDATE CASCADE -- Foreign key

);

/*
Create a new table called '[ChiTietDonHang]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[ChiTietDonHang]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ChiTietDonHang];
CREATE TABLE [dbo].[ChiTietDonHang]
(
    [MaDH] NCHAR(10),
    [MaSP] NCHAR(10),
    [SoLuong] INT NOT NULL,
    [TongGiaTri] INT ,
    CONSTRAINT FK_MaDH
        FOREIGN KEY (MaDH)
        REFERENCES DonHangMua (MaDH)
		ON UPDATE CASCADE, -- foreign key
    CONSTRAINT FK_MaSPDonHang
        FOREIGN KEY (MaSP)
        REFERENCES SanPham (MaSP)
		ON UPDATE CASCADE, -- foreign key
    CONSTRAINT PK_ChiTietDH
        PRIMARY KEY (
                        MaDH,
                        MaSP
                    ), -- Primary Key 
    CONSTRAINT Check_TongGiaTri CHECK (TongGiaTri > 0
                                      AND TongGiaTri % 1000 = 0
                                     )
);

/*
Create a new table called '[DoanhThu]' in schema '[dbo]'
*/

/*
Create the table in the specified schema
*/

IF OBJECT_ID('[dbo].[DoanhThu]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DoanhThu];
CREATE TABLE [dbo].[DoanhThu]
(
    [Ngay] DATE , -- Primary Key column

    [TongThu] INT,
	[TongChi] INT,
	[TienLai] INT,
    CONSTRAINT PK_DoanhThu
        PRIMARY KEY (Ngay)
);
GO
CREATE TRIGGER tg_LuongNV ON  [dbo].[NhanVien]
    AFTER INSERT AS
    BEGIN
    DECLARE @manv NCHAR(10), @luong int, @loainv TINYINT, @chucvu TINYINT;
	SELECT @manv = ne.MaNV, @loainv = ne.LoaiNV, @chucvu = ne.ChucVu 
		FROM inserted ne;
		
	IF (@loainv = 1 AND @chucvu = 1)
	UPDATE dbo.NhanVien SET Luong = 8000000 WHERE MaNV = @manv;
	IF (@loainv = 0 AND @chucvu = 1)
	UPDATE dbo.NhanVien SET Luong = 6000000 WHERE MaNV = @manv;
	IF (@loainv = 1 AND @chucvu = 2)
	UPDATE dbo.NhanVien SET Luong = 5000000 WHERE MaNV = @manv;
	IF (@loainv = 0 AND @chucvu = 2)
	UPDATE dbo.NhanVien SET Luong = 3000000 WHERE MaNV = @manv;
    END
GO 
INSERT INTO [dbo].[NhanVien] ( [MaNV],[MatKhau],[TenNV],[GioiTinh],[LoaiNV],[ChucVu])

VALUES ('NV010', '123', N'Nguyễn Ngọc Phát', 1  , 1, 2)

select Luong from NhanVien where MaNV='NV010'
GO
CREATE TRIGGER tg_NgayCapNhatSP ON  [dbo].[SanPham]
    AFTER INSERT, UPDATE  AS
    BEGIN
	UPDATE dbo.SanPham SET NgayCapNhat = GETDATE() WHERE MaSP IN (SELECT MaSP FROM inserted);
    END
GO
CREATE TRIGGER tg_NgayTaoDH ON  [dbo].[DonHangMua]
    AFTER INSERT  AS
    BEGIN
	UPDATE dbo.DonHangMua SET NgayTao = GETDATE() WHERE MaDH IN (SELECT MaDH FROM inserted);
    END
GO
CREATE TRIGGER tg_TongGiaTriCTDH ON  [dbo].[ChiTietDonHang]
    AFTER INSERT AS
    BEGIN
	DECLARE @masp NCHAR(10), @madh NCHAR(10);
	SELECT @masp = ne.MaSP, @madh = ne.MaDH FROM inserted ne;
	UPDATE dbo.ChiTietDonHang 
	SET TongGiaTri = (SELECT GiaBan FROM dbo.SanPham WHERE MaSP = @masp)*SoLuong
	WHERE MaDH = @madh AND  MaSP = @masp;

	DECLARE @magg NCHAR(10);
	SELECT @magg = DonHangMua.MaGG FROM dbo.DonHangMua WHERE MaDH = @madh;
	UPDATE dbo.DonHangMua
	SET ThanhTien = (SELECT SUM(TongGiaTri) FROM dbo.ChiTietDonHang WHERE MaDH = @madh) - ISNULL((SELECT  SoTienGiam FROM dbo.MaGiamGia WHERE MaGG = @magg),0)
	WHERE MaDH = @madh;
    END

INSERT INTO [dbo].[DonHangMua]

(

    [MaDH],

	[NgayTao],

    [MaNV],

    [MaGG]

)

VALUES

('DH012', '2022-11-22', 'NV010', 'MGG001')

INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])

VALUES ('DH012', 'SP001', 2)

Go

select thanhtien from DonHangMua where MaDH='DH012'



/*
tạo đơn hàng trước, sau đó thêm sản phẩm vào bảng ctdh, số tiền trong đơn hàng sẽ tự tính, sau đó tự thêm vào bảng doanh thu
*/
GO
CREATE TRIGGER tg_TongThuDT ON  [dbo].[DonHangMua]
    AFTER INSERT, UPDATE  AS
    BEGIN
	DECLARE @ngay DATETIME, @tongthu INT;
	SELECT @ngay = ne.NgayTao FROM inserted ne;
	SELECT @tongthu = SUM(ThanhTien) FROM dbo.DonHangMua WHERE NgayTao = @ngay
	IF EXISTS(SELECT Ngay FROM dbo.DoanhThu WHERE Ngay = @ngay)
		UPDATE dbo.DoanhThu SET TongThu = @tongthu
	ELSE INSERT dbo.DoanhThu (Ngay, TongThu)
	VALUES (@ngay, @tongthu) 
    END

select TongThu from DoanhThu where Ngay ='2022-11-28'
GO
CREATE TRIGGER tg_TongChiDT ON  [dbo].[NguyenLieu]
    AFTER INSERT, UPDATE  AS
    BEGIN
	DECLARE @tongchi INT;
	SELECT @tongchi = SUM(Inserted.DonGia) FROM Inserted 
	IF EXISTS(SELECT Ngay FROM dbo.DoanhThu WHERE Ngay = GETDATE())
		UPDATE dbo.DoanhThu SET TongChi = @tongchi
	ELSE INSERT dbo.DoanhThu (Ngay, TongChi)
	VALUES (GETDATE(), @tongchi)
    END
GO
CREATE TRIGGER tg_TienLaiDT ON  [dbo].[DoanhThu]
    AFTER INSERT, UPDATE  AS
    BEGIN
	UPDATE dbo.DoanhThu SET TienLai = TongThu - TongChi
    END


-- xoá tất cả dữ liệu trong từng bảng
DELETE FROM dbo.ChiTietDonHang;

DELETE FROM dbo.DonHangMua;

DELETE FROM dbo.MaGiamGia;

DELETE FROM dbo.ThamGiaLamViec;

DELETE FROM dbo.LichLamViec;

DELETE FROM dbo.CheBien;

DELETE FROM dbo.SanPham;

DELETE FROM dbo.NguyenLieu;

DELETE FROM dbo.NhaCungCap;

DELETE FROM dbo.NhanVien;

INSERT INTO [dbo].[NhanVien] ( [MaNV],[MatKhau],[TenNV],[GioiTinh],[LoaiNV],[ChucVu])
VALUES ('NV001', '123', N'Trần Phúc Khánh', 1, 1, 1)

INSERT INTO [dbo].[NhanVien] ( [MaNV],[MatKhau],[TenNV],[GioiTinh],[LoaiNV],[ChucVu])
VALUES('NV002', '123', N'Quang Trung', 1, 0, 1)

INSERT INTO [dbo].[NhanVien] ( [MaNV],[MatKhau],[TenNV],[GioiTinh],[LoaiNV],[ChucVu])
VALUES('NV003', '123', N'Nguyễn Huệ', 1, 1, 1)

INSERT INTO [dbo].[NhanVien] ( [MaNV],[MatKhau],[TenNV],[GioiTinh],[LoaiNV],[ChucVu])
VALUES('NV004', '123', N'Quan Vũ', 1, 1, 2)

INSERT INTO [dbo].[NhanVien] ( [MaNV],[MatKhau],[TenNV],[GioiTinh],[LoaiNV],[ChucVu])
VALUES('NV005', '123', N'Tào Tháo', 1, 0, 2)

INSERT INTO [dbo].[NhaCungCap]
(
    [MaNCC],
    [TenNCC],
    [DiaChi]
)
VALUES
('NCC001', N'Công Ty A', '38 Hoàng Diệu 2'),
('NCC002', N'Công Ty B', '23 Tô Ngọc Vân'),
('NCC003', N'Công Ty C', '69 Ngã Tư Thủ Đức'),
('NCC004', N'Công Ty D', '113 Đường số 6');

INSERT INTO [dbo].[NguyenLieu]
(
    [MaNL],
    [TenNL],
    [MaNCC],
    [SoLuong],
    [DonGia]
)
VALUES
('NL001', N'Burger', 'NCC001', 100, 300000),
('NL002', N'Gà không cay', 'NCC002', 60, 500000),
('NL003', N'Gà cay', 'NCC002', 50, 550000),
('NL004', N'Bột không cay', 'NCC002', 15, 400000),
('NL005', N'Túi đựng gà chiên', 'NCC003', 1000, 10000),
('NL006', N'Găng tay', 'NCC003', 300, 150000),
('NL007', N'Bột cay', 'NCC002', 20, 455000),
('NL008', N'Kem', 'NCC004', 100, 90000);

INSERT INTO [dbo].[SanPham]
(
    [MaSP],
    [TenSP],
    [GiaBan],
    [ChiPhi],
    [SoLuongTon],
    [SoLuongDaBan],
    [DonViTinh],
    [MoTa]
    
)
VALUES
('SP001', N'Cơm gà chiên bột cay', 55000, 30000, 3, 10, 1, N'Một phần cơm và một miếng gà chiên bột cay'  ),
('SP002', N'Burger gà', 40000, 20000, 10, 20, 1, N'Bánh burger với rau và một miếng gà'),
('SP003', N'Kem cone', 10000, 5000, 15, 30, 1, N'Một cây kem cuống'),
('SP004', N'Gà chiên bột không cay', 30000, 15000, 12, 10, 2, N'Một miếng gà chiên bột không cay'),
('SP005', N'Gà chiên bột cay', 30000, 15000, 15, 22, 2, N'Một miếng gà chiên bột cay');

INSERT INTO [dbo].[CheBien]
(
    [MaSP],
    [MaNL],
    [SoLuong]
)
VALUES
('SP001', 'NL003', 5),
('SP002', 'NL001', 15),
('SP003', 'NL008', 25);

INSERT INTO [dbo].[LichLamViec]
(
    [MaLLV],
    [NgayLV],
    [CaLV]
)
VALUES
('LLV001', '2022-01-09', 1),
('LLV002', '2022-01-09', 3),
('LLV003', '2022-02-09', 2),
('LLV005', '2022-03-09', 4),
('LLV006', '2022-04-09', 1);

INSERT INTO [dbo].[ThamGiaLamViec]
(
    [MaLLV],
    [MaNV]
)
VALUES
('LLV001', 'NV001'),
('LLV001', 'NV002'),
('LLV002', 'NV003'),
('LLV002', 'NV004'),
('LLV003', 'NV001'),
('LLV006', 'NV004'),
('LLV005', 'NV005');

INSERT INTO [dbo].[MaGiamGia]
(
    [MaGG],
    [SoTienGiam],
    [Soluong]
)
VALUES
('MGG001', '30000', 2),
('MGG002', '45000', 3),
('MGG003', '20000', 4),
('MGG004', '60000', 3),
('MGG005', '32000', 4),
('MGG006', '12000', 22);

INSERT INTO [dbo].[DonHangMua]
(
    [MaDH],
	[NgayTao],
    [MaNV],
    [MaGG]
)
VALUES
('DH001', '2022-11-22', 'NV001', 'MGG001'),
('DH002', '2022-11-22', 'NV002', 'MGG002'),
('DH003', '2022-11-22', 'NV003', 'MGG003'),
('DH004', '2022-11-22', 'NV001', NULL),
('DH005', '2022-11-22', 'NV005', NULL),
('DH006', '2022-11-22', 'NV004', 'MGG005');

INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH001', 'SP001', 2)
INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH002', 'SP003', 5)
INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH003', 'SP002', 3)
INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH004', 'SP004', 3)
INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH005', 'SP005', 4)
INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH006', 'SP002', 2)
INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH006', 'SP003', 3)
INSERT INTO [dbo].[ChiTietDonHang] ([MaDH],[MaSP], [SoLuong])
VALUES ('DH002', 'SP005', 3)

/*
1. Liệt kê các thông tin chi tiết của đơn hàng tương ứng với mã sản phẩm cụ thể.
*/

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'sp_ThongTinDonHangTheoSanPham'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.sp_ThongTinDonHangTheoSanPham
GO
CREATE PROC sp_ThongTinDonHangTheoSanPham
@maSanPham nvarchar(50)
AS
	SELECT *
	FROM ChiTietDonHang
	Where ChiTietDonHang.MaSP = @maSanPham
GO 


execute sp_ThongTinDonHangTheoSanPham "SP002";

/*
2. Liệt kê doanh thu của tất cả các ngày trong một tháng cụ thể
*/

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'sp_DoanhThuNgayTheoThang'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.sp_DoanhThuNgayTheoThang
GO
CREATE PROC sp_DoanhThuNgayTheoThang
@thang int
AS
	SELECT *
	FROM DoanhThu
	Where MONTH(DoanhThu.Ngay) = @thang

EXEC sp_DoanhThuNgayTheoThang 12;

/*
GO
*/

/*
3. Tổng số tiền của tất cả đơn hàng đã trừ đi số tiền đã giảm (của mã giảm giá).
*/

/*
GO
*/

/*
Tổng số loại mã giảm giá đã sử dụng.
*/

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'sf_TongSoMaGiamGia'
    AND ROUTINE_TYPE = N'FUNCTION'
)
DROP FUNCTION dbo.sf_TongSoMaGiamGia
GO
CREATE FUNCTION sf_TongSoMaGiamGia(@maGiamGia nvarchar(10))
RETURNS int
AS
BEGIN
	RETURN
		(SELECT COUNT(*)
		FROM DonHangMua
		WHERE MaGG = @maGiamGia)
END
GO
SELECT [dbo].[sf_TongSoMaGiamGia]('MGG005');

/*
GO
*/

/*
5. Tổng số đơn một nhân viên cụ thể đã thực hiện.
*/

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'sf_SoDonCuaNhanVien'
    AND ROUTINE_TYPE = N'FUNCTION'
)
DROP FUNCTION dbo.sf_SoDonCuaNhanVien
GO
CREATE FUNCTION sf_SoDonCuaNhanVien(@maNhanVien nvarchar(10))
RETURNS int
AS
BEGIN
	RETURN
		(SEleCT COUNT(*)
		FROM DonHangMua
		WHERE MaNV = @maNhanvien)
END
GO
SELECT [dbo].[sf_SoDonCuaNhanVien]('NV001')

/*
GO
*/
GO
CREATE FUNCTION sf_ThongTinDonHang(@ngayBatDau DATE, @ngayKetThuc DATE)
Returns TABLE
AS
	RETURN
		(SELECT *
		FROM DonHangMua
		WHERE NgayTao BETWEEN @ngayBatDau AND @ngayKetThuc)
GO
SELECT * FROM [dbo].[sf_ThongTinDonHang]('2022-10-1','2022-12-1');

/*
GO
*/

USE QUANLYCUAHANG

---------------------------------------------------------- STORED PROCEDURE NO PARAMETER

-- Create a new stored procedure called 'sp_DanhSach_NhanVien' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'sp_DanhSach_NhanVien'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.sp_DanhSach_NhanVien

/*
Create a new stored procedure called 'sp_DanhSach_NhanVienVoiLuong' in schema 'dbo'
*/

/*
Drop the stored procedure if it already exists
*/

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'sp_DanhSach_NhanVienVoiLuong'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.sp_DanhSach_NhanVienVoiLuong

/*
Create the stored procedure in the specified schema
*/
GO
CREATE PROCEDURE dbo.sp_DanhSach_NhanVienVoiLuong
    @min  int  = 0, 
    @max  int  = 0 
AS
BEGIN
    -- body of the stored procedure
    -- Select rows from a Table or View '[NhanVien]' in schema '[dbo]'
    SELECT * FROM [dbo].[NhanVien]
    WHERE Luong >= @min AND Luong <= @max
END

/*
example to execute the stored procedure we just created
*/

EXECUTE dbo.sp_DanhSach_NhanVienVoiLuong 3000000,4000000

/*
-------------------------------------------------------- SCALAR FUNCTIONS
*/
GO
CREATE FUNCTION sf_TongLuong_ChucVu(@chucvu INT)
RETURNS INT 
AS 
BEGIN
	DECLARE @tongluong int
	SELECT @tongluong = AVG(Luong) FROM NhanVien WHERE ChucVu = @chucvu
	RETURN @tongluong
END
GO
SELECT dbo.sf_TongLuong_ChucVu(2)

/*
-------------------------------------------------------- INLINE TABLE-VALUE FUNCTIONS
*/
GO
CREATE FUNCTION sf_DanhSach_LLVTrongNgay(@ngay date)
RETURNS TABLE 
AS RETURN (SELECT * FROM LichLamViec WHERE NgayLV = @ngay)
GO
select * from sf_DanhSach_LLVTrongNgay('2022-01-09')

/*
-------------------------------------------------------- MULTI-STATEMENT TABLE-VALUE FUNCTIONS
*/
GO
CREATE FUNCTION sf_DanhSach_LamViecNgayCa(@ngay date, @ca int)
RETURNS @table TABLE (MaNV nchar(10) null, TenNV nvarchar(50) null, NgayLV date null, Ca int null ) 
AS 
BEGIN
	insert into @table(MaNV,TenNV)   select NhanVien.MaNV, NhanVien.TenNV
									from NhanVien inner join ThamGiaLamViec 
									on NhanVien.MaNV = ThamGiaLamViec.MaNV
									where ThamGiaLamViec.MaLLV in (select MaLLV
																	from LichLamViec
																	where NgayLV = @ngay and CaLV = @ca);
	UPDATE @table SET NgayLV = @ngay;
	UPDATE @table SET Ca = @ca;
	return
END
GO
select * from sf_DanhSach_LamViecNgayCa('2022-01-09',1)

GO
CREATE FUNCTION sf_nv_LocNhanVienTheoChucVu(@chucVu tinyint)
RETURNS table 
as 
return(
select* from NhanVien where ChucVu=@chucVu
)
GO
CREATE FUNCTION sf_nv_LocNhanVienTheoGioiTinh(@gioiTinh tinyint)
RETURNS table 
as 
return(
select* from NhanVien where GioiTinh=@gioiTinh
)
GO
select * from  sf_nv_LocNhanVienTheoGioiTinh(1);

/*
1\. Tạo view xem thông tin của nhân viên đang còn làm việc tại của hàng
*/


GO
create view NhanVienHienTai as select MaNV, TenNV, GioiTinh, LoaiNV, Luong,ChucVu from NhanVien where DaXoa=0
GO
select * from NhanVienHienTai

/*
2\. View hiển thị sản phẩm đã bán được
*/
GO
create view SP_Da_Ban

as

    select hd.MaSP, sp.TenSP, sp.GiaBan

    from [dbo].ChiTietDonHang as hd, [dbo].SanPham as sp

    where hd.MaSP = sp.MaSP
GO




select * from SP_Da_Ban
GO
create view NguyenLieuCuaSanPham

as

select SP.MaSP, SP.TenSP, NL.MaNL, NL.TenNL, CB.SoLuong

from NguyenLieu as NL, CheBien as CB, SanPham as SP

where SP.MaSP = CB.MaSP and CB.MaNL = NL.MaNL 
GO
select * from NguyenLieuCuaSanPham;



USE QUANLYCUAHANG

-- tạo nhóm quyền

CREATE ROLE Admini

CREATE ROLE NhanVien

-- cấp quyền cho nhóm

GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.NhanVien TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.NhaCungCap TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.NguyenLieu TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.SanPham TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.LichLamViec TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.ThamGiaLamViec TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT ON dbo.DonHangMua TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT ON dbo.ChiTietDonHang TO Admini WITH GRANT OPTION

GRANT SELECT,INSERT,UPDATE,DELETE ON dbo.MaGiamGia TO Admini WITH GRANT OPTION



Grant execute to Admini

Grant Select to Admini



GRANT SELECT ON dbo.SanPham TO NhanVien WITH GRANT OPTION

GRANT SELECT ON dbo.LichLamViec TO NhanVien WITH GRANT OPTION

GRANT SELECT ON dbo.ThamGiaLamViec TO NhanVien WITH GRANT OPTION

GRANT SELECT,INSERT ON dbo.DonHangMUA TO NhanVien WITH GRANT OPTION

GRANT SELECT,INSERT ON dbo.ChiTietDonHang TO NhanVien WITH GRANT OPTION



-- thực thi các stored

-- tạo login

CREATE LOGIN admin007 WITH PASSWORD = 'iamadmin007'

CREATE LOGIN nhanvien002 WITH PASSWORD = 'iamstaff002'

-- tạo user

CREATE USER  admin007 FOR LOGIN Admin007

CREATE USER nhanvien002 FOR LOGIN Nhanvien002

-- phân quyền cho user

go

SP_addRoleMember 'Admini','admin007'

go

SP_addRoleMember 'NhanVien','nhanvien002'