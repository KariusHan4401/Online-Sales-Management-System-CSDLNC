﻿USE QUANLYCONCUNG
GO

CREATE OR ALTER PROC USP_XEM_THONGTIN_SP
@MASP INT, @TENSP NVARCHAR(100)
AS
BEGIN
	IF NOT EXISTS(SELECT @MASP FROM SAN_PHAM SP WHERE SP.MASP = @MASP) AND NOT EXISTS(SELECT @MASP FROM SAN_PHAM SP WHERE SP.TEN_SP = @TENSP)
	BEGIN
		PRINT N'KIỂM TRA LẠI THÔNG TIN CẦN TÌM KIẾM'
		RETURN-- Tìm kiếm thất bại
	END
	--THÔNG TIN SP (TÊN, MÃ SP, GIÁ, TÊN THƯƠNG HIỆU, SỐ LƯỢNG TỒN)
	SELECT SP.MASP, SP.TEN_SP, SP.GIA_BAN, TH.TEN_TH, B.SO_LUONG_TON, B.MACN
	FROM SAN_PHAM SP JOIN BAN B ON B.MASP = SP.MASP AND B.SO_LUONG_TON > 0
	JOIN THUONG_HIEU TH ON SP.MATH = TH.MATH
	WHERE SP.MASP = @MASP AND SP.TEN_SP = @TENSP

	/*
	--THÔNG TIN CHI NHÁNH CÒN HÀNG
	SELECT B.MACN, B.SO_LUONG_TON, CN.SO_NHA_DUONG, CN.PHUONG_XA, CN.QUAN_TP, CN.TP_TINH, CN.SDT_CN
	FROM BAN B JOIN CHI_NHANH CN ON B.MACN = CN.MACN
	WHERE B.MASP = @MASP AND B.SO_LUONG_TON > 0*/

	--NỘI DUNG CÁC BÌNH LUẬN CỦA SẢN PHẨM
	SELECT SP.MASP, SP.TEN_SP, KH.TENKH, BL.NOI_DUNG, BL.NGAY_DANG
	FROM SAN_PHAM SP JOIN BINH_LUAN BL ON BL.MASP = SP.MASP
	JOIN KHACH_HANG KH ON KH.MAKH = BL.MAKH
	WHERE SP.MASP = @MASP AND SP.TEN_SP = @TENSP

	SELECT COUNT(*) 'Tổng số bình luận'
	FROM BINH_LUAN BL JOIN SAN_PHAM SP ON BL.MASP = SP.MASP
	WHERE BL.MASP = @MASP
	
	SELECT COUNT(*) AS 'Tổng số lượt yêu thích'
	FROM YEUTHICH YT JOIN SAN_PHAM SP ON SP.MASP = YT.MASP
	WHERE YT.MASP = @MASP
END
GO

CREATE OR ALTER PROC USP_XEM_TTCHINHANH_DU_SLT_SP
@MASP INT, @MACN INT
AS
BEGIN
	IF NOT EXISTS(SELECT @MASP FROM SAN_PHAM SP WHERE SP.MASP = @MASP) AND NOT EXISTS(SELECT @MACN FROM CHI_NHANH CN WHERE CN.MACN = @MACN)
	BEGIN
		PRINT N'KIỂM TRA LẠI THÔNG TIN CẦN TÌM KIẾM'
		RETURN-- Tìm kiếm thất bại
	END
	--THÔNG TIN CHI NHÁNH CÒN HÀNG
	SELECT B.MACN, B.SO_LUONG_TON, CN.SO_NHA_DUONG, CN.PHUONG_XA, CN.QUAN_TP, CN.TP_TINH, CN.SDT_CN
	FROM BAN B JOIN CHI_NHANH CN ON B.MACN = CN.MACN
	WHERE B.MASP = @MASP AND CN.MACN = @MACN AND B.SO_LUONG_TON > 0
END
GO

EXEC USP_XEM_THONGTIN_SP 'SP000011', N'Dép lớp unicorn 2'
EXEC USP_XEM_TTCHINHANH_DU_SLT_SP 'SP000011', 'CN000003'