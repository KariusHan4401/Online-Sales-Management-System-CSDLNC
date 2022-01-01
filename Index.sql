﻿DELETE FROM LICH_SU_LUONG
DELETE FROM DOANH_THU
DELETE FROM CHAM_CONG
DELETE FROM YEUTHICH
DELETE FROM BINH_LUAN
DELETE FROM BAN
DELETE FROM CHI_TIET_NHAP_HANG
DELETE FROM PHIEU_NHAP_HANG
DELETE FROM NHA_CUNG_CAP
DELETE FROM CHI_TIET_DON_HANG
DELETE FROM SAN_PHAM
DELETE FROM DON_HANG
DELETE FROM NHAN_VIEN
DELETE FROM CHI_NHANH
DELETE FROM VOUCHER
DELETE FROM LOAI_HANG
DELETE FROM THUONG_HIEU
DELETE FROM EM_BE
DELETE FROM DIA_CHI_KH
DELETE FROM KHACH_HANG
DELETE FROM THE


use QUANLYCONCUNG
go

SELECT KHACH_HANG.*
INTO KHACH_HANG_INDEX
FROM KHACH_HANG

CREATE NONCLUSTERED INDEX IDX_KH_SDT
ON KHACH_HANG_INDEX(SDT_KH)

DECLARE @StartTime datetime
DECLARE @EndTime datetime

SELECT @StartTime=GETDATE()
	SELECT * FROM KHACH_HANG_INDEX WHERE SDT_KH = '0906772604'

SELECT @EndTime=GETDATE()

--This will return execution time of your query
SELECT 'YES' AS 'Nonclustered index in price',DATEDIFF(MS,@StartTime,@EndTime) AS [Duration in millisecs]


SELECT @StartTime=GETDATE()
	SELECT * FROM KHACH_HANG WHERE SDT_KH = '0906772604'

SELECT @EndTime=GETDATE()

--This will return execution time of your query
SELECT 'NO' AS 'Nonclustered index in price',DATEDIFF(MS,@StartTime,@EndTime) AS [Duration in millisecs]





-- KHACH_HANG_INDEX
GO
CREATE TABLE KHACH_HANG_INDEX (
	MAKH INT IDENTITY(100000,1),
	TENKH NVARCHAR(100),
	EMAIL_KH VARCHAR(60),
	SDT_KH CHAR(10) UNIQUE,
	NGSINH_KH DATE,
	TONG_DIEM_TICH_LUY INT DEFAULT 0,
	MAT_KHAU VARCHAR(50) NOT NULL,
	TAI_KHOAN VARCHAR(50) NOT NULL UNIQUE,
	MA_THE INT,

	CONSTRAINT PK_KH_IDX PRIMARY KEY(MAKH),
	CONSTRAINT FK_KH_IDX_THE FOREIGN KEY(MA_THE) REFERENCES THE(MA_THE)

)
SET IDENTITY_INSERT KHACH_HANG_INDEX ON
INSERT INTO KHACH_HANG_INDEX(MAKH,TENKH,EMAIL_KH,SDT_KH,NGSINH_KH,TONG_DIEM_TICH_LUY,MAT_KHAU,TAI_KHOAN,MA_THE)
SELECT KHACH_HANG. *
FROM KHACH_HANG
SET IDENTITY_INSERT KHACH_HANG_INDEX OFF

----END ---

-- DON_HANG INDEX---
GO
CREATE TABLE DON_HANG_INDEX (
	MADH INT IDENTITY(100000,1) PRIMARY KEY,
	MAKH INT,
	MANV INT,
	MACN INT,
	MA_VOUCHER INT,
	PHI_SAN_PHAM MONEY DEFAULT 0,
	PHI_VAN_CHUYEN MONEY DEFAULT 0,
	PHI_GIAM MONEY DEFAULT 0,
	HINH_THUC_THANH_TOAN NVARCHAR(50) CHECK(HINH_THUC_THANH_TOAN IN (N'COD',N'ATM',N'VNPAY-QR',N'VISA',N'MASTERCARD',N'JCB',N'ZALOPAY',N'MOMO')),
	TONG_PHI AS (PHI_SAN_PHAM + PHI_VAN_CHUYEN - PHI_GIAM),
	SO_NHA_DUONG NVARCHAR(60),
	PHUONG_XA NVARCHAR(40),
	QUAN_TP NVARCHAR(40),
	TP_TINH NVARCHAR(40),
	TG_LAP_DH DATETIME NOT NULL,
	TRANG_THAI NVARCHAR(10) CHECK(TRANG_THAI IN (N'Chờ giao', N'Đã giao', N'Đã hủy')),
	TG_TRANG_THAI DATETIME,
	DIEM_TICH_LUY INT DEFAULT 0,

	CONSTRAINT FK_DH_IDX_KH FOREIGN KEY (MAKH)  REFERENCES KHACH_HANG(MAKH),
	CONSTRAINT FK_DH_IDX_NV  FOREIGN KEY (MANV)  REFERENCES NHAN_VIEN (MANV),
	CONSTRAINT FK_DH_IDX_CN  FOREIGN KEY (MACN)  REFERENCES CHI_NHANH (MACN),
	CONSTRAINT FK_DH_IDX_VOUCHER FOREIGN KEY (MA_VOUCHER) REFERENCES VOUCHER(MA_VOUCHER)
)

CREATE NONCLUSTERED INDEX IDX_DH_NGAYLAP
ON DON_HANG_INDEX(TG_LAP_DH) 

-- COPY DỮ LIỆU --
SET IDENTITY_INSERT DON_HANG_INDEX ON
INSERT INTO DON_HANG_INDEX(MADH, MAKH, MANV, MACN, MA_VOUCHER, PHI_SAN_PHAM, PHI_VAN_CHUYEN, PHI_GIAM, HINH_THUC_THANH_TOAN, 
SO_NHA_DUONG, PHUONG_XA, QUAN_TP, TP_TINH, TG_LAP_DH, TRANG_THAI,  TG_TRANG_THAI, DIEM_TICH_LUY)
SELECT MADH, MAKH, MANV, MACN, MA_VOUCHER, PHI_SAN_PHAM, PHI_VAN_CHUYEN, PHI_GIAM, HINH_THUC_THANH_TOAN, 
SO_NHA_DUONG, PHUONG_XA, QUAN_TP, TP_TINH, TG_LAP_DH, TRANG_THAI,  TG_TRANG_THAI, DIEM_TICH_LUY
FROM DON_HANG
SET IDENTITY_INSERT DON_HANG_INDEX OFF


DECLARE @StartTime datetime
DECLARE @EndTime datetime

SELECT @StartTime=GETDATE()

SELECT * FROM DON_HANG_INDEX WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, TG_LAP_DH))= '2020-10-05 0:0:0'


SELECT @EndTime=GETDATE()

--This will return execution time of your query
SELECT 'YES' AS 'Nonclustered index in price',DATEDIFF(MS,@StartTime,@EndTime) AS [Duration in millisecs]


SELECT @StartTime=GETDATE()
-- SELECT * FROM DON_HANG WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, TG_LAP_DH)) = '2020-10-05 0:0:0'
SELECT * FROM DON_HANG WHERE YEAR(TG_LAP_DH) = 2016


SELECT @EndTime=GETDATE()

--This will return execution time of your query
SELECT 'NO' AS 'Nonclustered index in price',DATEDIFF(MS,@StartTime,@EndTime) AS [Duration in millisecs]


-- SAN_PHAM INDEX--
CREATE TABLE SAN_PHAM_INDEX (
	MASP INT IDENTITY(100000,1),
	MALH INT,
	MATH INT NOT NULL,
	TEN_SP NVARCHAR(100),
	HINH_ANH VARCHAR(500),
	MO_TA NVARCHAR(1000),
	LUOT_YEU_THICH INT DEFAULT 0,
	LUOT_BINH_LUAN INT DEFAULT 0,
	GIA_BAN MONEY,

	CONSTRAINT PK_SAN_PHAM_IDX PRIMARY KEY(MASP),
	CONSTRAINT FK_SPIDX_LH FOREIGN KEY (MALH) REFERENCES LOAI_HANG (MALH),
	CONSTRAINT FK_SPIDX_TH FOREIGN KEY (MATH) REFERENCES THUONG_HIEU (MATH)
)
CREATE NONCLUSTERED INDEX IDX_SP_GIA
ON SAN_PHAM_INDEX(GIA_BAN)

-- COPY DỮ LIỆU --
SET IDENTITY_INSERT SAN_PHAM_INDEX ON
INSERT INTO SAN_PHAM_INDEX(MASP, MALH, MATH, TEN_SP, HINH_ANH, MO_TA, LUOT_YEU_THICH, LUOT_BINH_LUAN, GIA_BAN)
SELECT SAN_PHAM.*
FROM SAN_PHAM
SET IDENTITY_INSERT SAN_PHAM_INDEX OFF

SELECT * FROM SAN_PHAM WHERE GIA_BAN BETWEEN 50000 AND 60000
-- INDEX TẠI (TP_TINH, QUAN_TP) CỦA DON_HANG --
GO
CREATE NONCLUSTERED INDEX IDX_DH_DIACHI
ON DON_HANG_INDEX(TP_TINH, QUAN_TP)
INCLUDE (MAKH, MANV, MACN, MA_VOUCHER, PHI_SAN_PHAM, PHI_VAN_CHUYEN, PHI_GIAM, HINH_THUC_THANH_TOAN, TONG_PHI, SO_NHA_DUONG, PHUONG_XA, TG_LAP_DH, TRANG_THAI, TG_TRANG_THAI, DIEM_TICH_LUY) 

-- INDEX --
--1. DON_HANG(TG_LAP_DH)
--2. DON_HANG(TP_TINH, QUAN_TP)
CREATE
--ALTER
PROC USP_XEM_DH_THEO_KV
@TP_Tinh NVARCHAR(40),
@Q_TP NVARCHAR(40)
AS
BEGIN
	--THÔNG TIN ĐƠN HÀNG THEO KHU VỰC 
	IF EXISTS (SELECT MADH
				FROM DON_HANG_INDEX WHERE TP_TINH = @TP_Tinh AND QUAN_TP = @Q_TP)
	BEGIN
		SELECT MADH, MAKH, MANV, MACN, MA_VOUCHER, PHI_SAN_PHAM, PHI_VAN_CHUYEN, PHI_GIAM, HINH_THUC_THANH_TOAN, TONG_PHI, SO_NHA_DUONG, PHUONG_XA, QUAN_TP, TP_TINH, TG_LAP_DH, TRANG_THAI, TG_TRANG_THAI, DIEM_TICH_LUY 
		FROM DON_HANG_INDEX WHERE TP_TINH = @TP_Tinh AND QUAN_TP = @Q_TP
		RETURN
	END
	
	IF EXISTS (SELECT MADH
				FROM DON_HANG_INDEX WHERE TP_TINH = @TP_Tinh)
	BEGIN
		SELECT MADH, MAKH, MANV, MACN, MA_VOUCHER, PHI_SAN_PHAM, PHI_VAN_CHUYEN, PHI_GIAM, HINH_THUC_THANH_TOAN, TONG_PHI, SO_NHA_DUONG, PHUONG_XA, QUAN_TP, TP_TINH, TG_LAP_DH, TRANG_THAI, TG_TRANG_THAI, DIEM_TICH_LUY 
		FROM DON_HANG_INDEX WHERE TP_TINH = @TP_Tinh
		RETURN
	END

	PRINT N'Vui lòng nhập thành phố (tỉnh) hoặc quận (thành phố)!!!'
END
GO

SELECT MADH, MAKH, MANV, MACN, MA_VOUCHER, PHI_SAN_PHAM, PHI_VAN_CHUYEN, PHI_GIAM, HINH_THUC_THANH_TOAN, TONG_PHI, SO_NHA_DUONG, PHUONG_XA, QUAN_TP, TP_TINH, TG_LAP_DH, TRANG_THAI, TG_TRANG_THAI, DIEM_TICH_LUY 
FROM DON_HANG WHERE TP_TINH = N'Thái Nguyên' AND QUAN_TP = N'Bình Thạnh'
GO

SELECT MADH, MAKH, MANV, MACN, MA_VOUCHER, PHI_SAN_PHAM, PHI_VAN_CHUYEN, PHI_GIAM, HINH_THUC_THANH_TOAN, TONG_PHI, SO_NHA_DUONG, PHUONG_XA, QUAN_TP, TP_TINH, TG_LAP_DH, TRANG_THAI, TG_TRANG_THAI, DIEM_TICH_LUY 
FROM DON_HANG_INDEX WHERE TP_TINH = N'Thái Nguyên' AND QUAN_TP = N'Bình Thạnh'
GO
--3. KHACH_HANG(SDT_KH)
--4. SAN_PHAM(GIA_BAN)