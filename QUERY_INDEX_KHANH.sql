﻿USE QUANLYCONCUNG
GO

CREATE OR ALTER PROC USP_TIM_SANPHAM
@Find NVARCHAR(255)
AS
BEGIN
	DECLARE @FLAG AS BIT
	--THÔNG TIN SP (TÊN, MÃ SP, GIÁ, TÊN THƯƠNG HIỆU, SỐ LƯỢNG TỒN)
	IF NOT EXISTS (SELECT SP.MASP
					FROM SAN_PHAM SP
					WHERE SP.TEN_SP LIKE '%' + @Find + '%')
	BEGIN
		SET @FLAG = 0 -- TÌM THẤT BẠI
		PRINT N'TÌM KIẾM THẤT BẠI'
	END
		
	ELSE
		SET @FLAG = 1 --TÌM THÀNH CÔNG

	IF(@FLAG = 1)
	BEGIN
		--THÔNG TIN SP (TÊN, MÃ SP, GIÁ, TÊN THƯƠNG HIỆU)
		SELECT SP.MASP, SP.TEN_SP, SP.GIA_BAN, TH.TEN_TH
		FROM SAN_PHAM SP JOIN THUONG_HIEU TH ON SP.MATH = TH.MATH
		WHERE SP.TEN_SP LIKE '%' + @Find + '%'

		--TỔNG SỐ LƯỢNG BÌNH LUẬN
		SELECT SP.MASP, SP.TEN_SP, COUNT(SP.MASP) 'Tổng số bình luận'
		FROM BINH_LUAN BL JOIN SAN_PHAM SP ON BL.MASP = SP.MASP
		WHERE SP.TEN_SP LIKE '%' + @Find + '%'
		GROUP BY SP.MASP, SP.TEN_SP

		--TỔNG SỐ LƯỢT YÊU THÍCH
		SELECT SP.MASP, SP.TEN_SP, COUNT(SP.MASP) AS 'Tổng số lượt yêu thích'
		FROM YEUTHICH YT JOIN SAN_PHAM SP ON SP.MASP = YT.MASP
		WHERE SP.TEN_SP LIKE '%' + @Find + '%'
		GROUP BY SP.MASP, SP.TEN_SP
	END
END
GO

CREATE OR ALTER PROC USP_XEM_THONGTIN_SP
@MaSP INT
AS
BEGIN
	--THÔNG TIN SP (TÊN, MÃ SP, GIÁ, TÊN THƯƠNG HIỆU, SỐ LƯỢNG TỒN)
	SELECT SP.*, TH.TEN_TH
	FROM SAN_PHAM SP JOIN THUONG_HIEU TH ON SP.MATH = TH.MATH
	WHERE SP.MASP = @MaSP

	--NỘI DUNG CÁC BÌNH LUẬN CỦA SẢN PHẨM
	SELECT SP.MASP, SP.TEN_SP, KH.TENKH, BL.NOI_DUNG, BL.NGAY_DANG
	FROM SAN_PHAM SP JOIN BINH_LUAN BL ON BL.MASP = SP.MASP
	JOIN KHACH_HANG KH ON KH.MAKH = BL.MAKH
	WHERE SP.MASP = @MaSP
END
GO

--*
CREATE OR ALTER PROC USP_XEM_TTCHINHANH_DU_SLT_SP
@MASP INT
AS
BEGIN
	--THÔNG TIN CHI NHÁNH CÒN HÀNG
	SELECT B.MACN, B.SO_LUONG_TON, CN.SO_NHA_DUONG, CN.PHUONG_XA, CN.QUAN_TP, CN.TP_TINH, CN.SDT_CN
	FROM BAN B JOIN CHI_NHANH CN ON B.MACN = CN.MACN
	WHERE B.MASP = @MASP AND B.SO_LUONG_TON > 0
END
GO

--EXEC USP_TIM_SANPHAM N'Dép'
--EXEC USP_XEM_THONGTIN_SP 
--EXEC USP_XEM_TTCHINHANH_DU_SLT_SP