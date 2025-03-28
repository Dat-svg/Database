﻿CREATE DATABASE QuanLyDatPhongKhachSan
USE QuanLyDatPhongKhachSan

--TẠO BẢNG DICHVU
CREATE TABLE DICHVU(
	MADICHVU VARCHAR(20) NOT NULL,
	GIADICHVU INT DEFAULT 0,
	TENDICHVU NVARCHAR(50),
	CONSTRAINT PK_MADICHVU PRIMARY KEY(MADICHVU)
)

--TẠO BẢNG KHACHHANG
CREATE TABLE KHACHHANG(
	MAKHACHHANG VARCHAR(20) NOT NULL,
	TENKHACHHANG NVARCHAR(30),
	THEDINHDANH CHAR(20),
	CONSTRAINT PK_MAKHACHHANG PRIMARY KEY(MAKHACHHANG)
)

--TẠO BẢNG HOADON
CREATE TABLE HOADON(
	MAHOADON VARCHAR(20) NOT NULL,
	NGAYTHANHTOAN DATE,
	TONGSOTIEN INT DEFAULT 0,
	MADATPHONG VARCHAR(20),
	CONSTRAINT PK_MAHOADON PRIMARY KEY(MAHOADON)
)

--TẠO BẢNG LOAIHOADON
CREATE TABLE LOAIHOADON(
	MAHOADON VARCHAR(20) NOT NULL,
	HOADONDO NVARCHAR(30),
	HOADONTRANG NVARCHAR(30),
	CONSTRAINT PK_LOAIHOADON_MAHOADON PRIMARY KEY (MAHOADON),
	CONSTRAINT FK_LOAIHOADON_MAHOADON FOREIGN KEY(MAHOADON) REFERENCES HOADON(MAHOADON)
)

--TẠO BẢNG PHONG
CREATE TABLE PHONG(
	MAPHONG VARCHAR(20) NOT NULL,
	SOLUONGGIUONG INT DEFAULT 0,
	TIENICHPHONG NVARCHAR(30),
	MADICHVU VARCHAR(20),
	CONSTRAINT PK_MAPHONG PRIMARY KEY(MAPHONG),
	CONSTRAINT FK_MADICHVU FOREIGN KEY(MADICHVU) REFERENCES DICHVU(MADICHVU)
)

--TẠO BẢNG PHIEUDATPHONG
CREATE TABLE PHIEUDATPHONG(
	MADATPHONG VARCHAR(20) NOT NULL,
	MAKHACHHANG VARCHAR(20),
	MAPHONG VARCHAR(20),
	NGAYCHECKIN DATE,
	SONGAYO INT DEFAULT 0,
	MAHOADON VARCHAR(20),
	CONSTRAINT PK_MADATPHONG PRIMARY KEY(MADATPHONG),
	CONSTRAINT FK_MAKHACHHANG FOREIGN KEY(MAKHACHHANG) REFERENCES KHACHHANG(MAKHACHHANG),
	CONSTRAINT FK_MAHOADON FOREIGN KEY(MAHOADON) REFERENCES HOADON(MAHOADON),
	CONSTRAINT FK_MAPHONG FOREIGN KEY(MAPHONG) REFERENCES PHONG(MAPHONG)
)

--TẠO BẢNG PHONGTIEUCHUAN
CREATE TABLE PHONGTIEUCHUAN(
	MAPHONG VARCHAR(20) NOT NULL,
	GIATIEN INT DEFAULT 0,
	CONSTRAINT PK_PHONGTIEUCHUAN_MAPHONG PRIMARY KEY(MAPHONG),
	CONSTRAINT FK_PHONGTIEUCHUAN_MAPHONG FOREIGN KEY(MAPHONG) REFERENCES PHONG(MAPHONG)
)

--TẠO BẢNG PHONGVIP
CREATE TABLE PHONGVIP(
	MAPHONG VARCHAR(20) NOT NULL,
	GIATIEN INT DEFAULT 0,
	UUDAI NVARCHAR(30),
	CONSTRAINT PK_PHONGVIP_MAPHONG PRIMARY KEY (MAPHONG),
	CONSTRAINT FK_PHONGVIP_MAPHONG FOREIGN KEY(MAPHONG) REFERENCES PHONG(MAPHONG)
)

--YÊU CẦU 2
--HÀM PHÁT SINH MÃ CHO BẢNG DICHVU
CREATE FUNCTION AUTO_MADICHVU()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MADICHVU, 3) AS INT)), 0) + 1
    FROM DICHVU

    SELECT @ID = CASE
        WHEN @NEWID < 10 THEN 'DV000' + CAST(@NEWID AS CHAR(1))
        WHEN @NEWID < 100 THEN 'DV00' + CAST(@NEWID AS CHAR(2))
        WHEN @NEWID < 1000 THEN 'DV0' + CAST(@NEWID AS CHAR(3))
        WHEN @NEWID < 10000 THEN 'DV' + CAST(@NEWID AS CHAR(4))
    END

    RETURN @ID
END
GO

--HÀM THÊM DỮ LIỆU TỰ ĐỘNG CHO BẢNG DICHVU
CREATE PROCEDURE INSERT_DICHVU
    @GIADICHVU INT,
    @TENDICHVU NVARCHAR(50)
AS
    DECLARE @MADICHVU VARCHAR(20)
    SET @MADICHVU = dbo.AUTO_MADICHVU()

    IF NOT EXISTS (SELECT * FROM DICHVU WHERE MADICHVU = @MADICHVU)
    BEGIN
        PRINT('DICH VU KHONG TON TAI')
    END  
        INSERT INTO DICHVU VALUES (@MADICHVU, @GIADICHVU, @TENDICHVU)
GO

--THÊM ÍT NHẤT 10 DÒNG DỮ LIỆU
INSERT INTO DICHVU VALUES
(dbo.AUTO_MADICHVU(), 100000, 'SPA'),
(dbo.AUTO_MADICHVU(), 150000, 'FITNESS'),
(dbo.AUTO_MADICHVU(), 500000, N'BUFFET SÁNG'),
(dbo.AUTO_MADICHVU(), 600000, N'ĐƯA ĐÓN SÂN BAY'),
(dbo.AUTO_MADICHVU(), 200000, 'BAR'),
(dbo.AUTO_MADICHVU(), 80000, N'GIẶT ỦI'),
(dbo.AUTO_MADICHVU(), 300000, N'THAY GA GIƯỜNG'),
(dbo.AUTO_MADICHVU(), 250000, N'BỂ BƠI BỐN MÙA'),
(dbo.AUTO_MADICHVU(), 400000, N'PHÒNG HỌP TRỰC TIẾP'),
(dbo.AUTO_MADICHVU(), 350000, N'GOLF VÀ TENNIS')

--HÀM PHÁT SINH MÃ CHO BẢNG KHACHHANG
CREATE FUNCTION AUTO_MAKHACHHANG()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MAKHACHHANG, 3) AS INT)), 0) + 1
    FROM KHACHHANG

    SELECT @ID = 'KH' + RIGHT('000' + CAST(@NEWID AS VARCHAR(4)), 4)

    RETURN @ID
END
GO

--THÊM DỮ LIỆU CHO KHACHHANG
INSERT INTO KHACHHANG VALUES
(dbo.AUTO_MAKHACHHANG(), N'NUYỄN VĂN TÈO', '21783427192'),
(dbo.AUTO_MAKHACHHANG(), 'YING YING', '418927652862X'),
(dbo.AUTO_MAKHACHHANG(), N'LÊ MINH HÔ','AS216374218724'),
(dbo.AUTO_MAKHACHHANG(), N'PHẠM THỊ NỞ', '08075213023'),
(dbo.AUTO_MAKHACHHANG(), N'VŨ AO HỒ', '72148279372'),
(dbo.AUTO_MAKHACHHANG(), N'PHAN VĂN TÈO', '21783427192'),
(dbo.AUTO_MAKHACHHANG(), 'LIU YING', '418927652862X'),
(dbo.AUTO_MAKHACHHANG(), N'ĐỖ THỊ HÔ','AS216374218724'),
(dbo.AUTO_MAKHACHHANG(), N'NGÔ QUỲNH NHỜ', '08075213023'),
(dbo.AUTO_MAKHACHHANG(), N'PHẠM NHẬT VÙNG', '72148279372')

--HÀM TẠO MÃ TỰ ĐỘNG CHO BẢNG PHONG
CREATE FUNCTION AUTO_MAPHONG()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MAPHONG, 3) AS INT)), 0) + 1
    FROM PHONG

    SELECT @ID = CASE
        WHEN @NEWID < 10 THEN 'MP000' + CAST(@NEWID AS CHAR(1))
        WHEN @NEWID < 100 THEN 'MP00' + CAST(@NEWID AS CHAR(2))
        WHEN @NEWID < 1000 THEN 'MP0' + CAST(@NEWID AS CHAR(3))
        WHEN @NEWID < 10000 THEN 'MP' + CAST(@NEWID AS CHAR(4))
    END

    RETURN @ID
END
GO

--THÊM DỮ LIỆU CHO PHONG
INSERT INTO PHONG VALUES
(dbo.AUTO_MAPHONG(), 2, N'WIFI', 'DV0001'),
(dbo.AUTO_MAPHONG(), 1, N'MINI BAR', 'DV0002'),
(dbo.AUTO_MAPHONG(), 2, N'BỒN TẮM NẰM', 'DV0003'),
(dbo.AUTO_MAPHONG(), 1, N'BỒN TẮM ĐỨNG', 'DV0004'),
(dbo.AUTO_MAPHONG(), 2, N'BẾP NẤU', 'DV0005'),
(dbo.AUTO_MAPHONG(), 1, N'MÁY GIẶT', 'DV0006'),
(dbo.AUTO_MAPHONG(), 2, N'MÁY PHA CÀ PHÊ', 'DV0007'),
(dbo.AUTO_MAPHONG(), 1, N'BỂ BƠI', 'DV0008'),
(dbo.AUTO_MAPHONG(), 2, N'KHU VUI CHƠI', 'DV0009'),
(dbo.AUTO_MAPHONG(), 1, N'GIƯỜNG TẦNG', 'DV0010')

-- HÀM TẠO MÃ TỰ ĐỘNG CHO BẢNG HOADON
CREATE FUNCTION AUTO_MAHOADON()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MAHOADON, 3) AS INT)), 0) + 1
    FROM HOADON

    SELECT @ID = 'HD' + RIGHT('000' + CAST(@NEWID AS VARCHAR(4)), 4)

    RETURN @ID
END
GO

--THÊM DỮ LIỆU CHO HOADON
INSERT INTO HOADON VALUES
(dbo.AUTO_MAHOADON(), '2020-03-27', 5600000, 'DP0001'),
(dbo.AUTO_MAHOADON(), '2018-11-03', 1600000, 'DP0002'),
(dbo.AUTO_MAHOADON(), '2022-02-18', 6400000, 'DP0003'),
(dbo.AUTO_MAHOADON(), '2019-08-15', 8000000, 'DP0004'),
(dbo.AUTO_MAHOADON(), '2021-05-27', 4000000, 'DP0005'),
(dbo.AUTO_MAHOADON(), '2021-10-10', 800000, 'DP0006'),
(dbo.AUTO_MAHOADON(), '2022-11-30', 4800000, 'DP0007'),
(dbo.AUTO_MAHOADON(), '2020-04-15', 2400000, 'DP0008'),
(dbo.AUTO_MAHOADON(), '2019-06-22', 3200000, 'DP0009'),
(dbo.AUTO_MAHOADON(), '2023-03-08', 11200000, 'DP0010')

--HÀM TẠO MÃ TỰ ĐỘNG CHO PHIEUDATPHONG
CREATE FUNCTION AUTO_MADATPHONG()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MADATPHONG, 3) AS INT)), 0) + 1
    FROM PHIEUDATPHONG

    SELECT @ID = CASE
        WHEN @NEWID < 10 THEN 'MDP000' + CAST(@NEWID AS CHAR(1))
        WHEN @NEWID < 100 THEN 'MDP00' + CAST(@NEWID AS CHAR(2))
        WHEN @NEWID < 1000 THEN 'MDP0' + CAST(@NEWID AS CHAR(3))
        WHEN @NEWID < 10000 THEN 'MDP' + CAST(@NEWID AS CHAR(4))
    END

    RETURN @ID
END
GO

--THÊM DỮ LIỆU CHO BẢNG PHIEUDATPHONG
INSERT INTO PHIEUDATPHONG VALUES
(dbo.AUTO_MADATPHONG(), 'KH0001', 'MP0001', '2020-03-20', 7, 'HD0001'),
(dbo.AUTO_MADATPHONG(), 'KH0002', 'MP0002', '2018-11-01', 2, 'HD0002'),
(dbo.AUTO_MADATPHONG(), 'KH0003', 'MP0003', '2022-02-10', 8, 'HD0003'),
(dbo.AUTO_MADATPHONG(), 'KH0004', 'MP0004', '2019-08-05', 10, 'HD0004'),
(dbo.AUTO_MADATPHONG(), 'KH0005', 'MP0005', '2021-05-22', 5, 'HD0005'),
(dbo.AUTO_MADATPHONG(), 'KH0006', 'MP0006', '2021-10-09', 1, 'HD0006'),
(dbo.AUTO_MADATPHONG(), 'KH0007', 'MP0007', '2022-11-24', 6, 'HD0007'),
(dbo.AUTO_MADATPHONG(), 'KH0008', 'MP0008', '2020-04-22', 3, 'HD0008'),
(dbo.AUTO_MADATPHONG(), 'KH0009', 'MP0009', '2019-06-18', 4, 'HD0009'),
(dbo.AUTO_MADATPHONG(), 'KH0010', 'MP0010', '2023-02-09', 14, 'HD0010')

--HÀM TẠO MÃ TỰ ĐỘNG CHO BẢNG LOAIHOADON
CREATE FUNCTION AUTO_MAHOADON_LOAIHOADON()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MAHOADON, 3) AS INT)), 0) + 1
    FROM LOAIHOADON

    SELECT @ID = 'LH' + RIGHT('000' + CAST(@NEWID AS VARCHAR(4)), 4)

    RETURN @ID
END
GO

--THÊM DỮ LIỆU CHO LOAIHOADON
INSERT INTO LOAIHOADON VALUES
('HD0001', N'ĐÃ THANH TOÁN', NULL),
('HD0002', NULL, N'CHƯA THANH TOÁN'),
('HD0003', N'CHƯA THANH TOÁN', NULL),
('HD0004', NULL, N'ĐÃ THANH TOÁN'),
('HD0005', N'ĐÃ THANH TOÁN', NULL),
('HD0006', N'CHƯA THANH TOÁN', NULL),
('HD0007', NULL, N'CHƯA THANH TOÁN'),
('HD0008', N'CHƯA THANH TOÁN', NULL),
('HD0009', NULL, N'ĐÃ THANH TOÁN'),
('HD0010', N'ĐÃ THANH TOÁN', NULL)

--HÀM TẠO MÃ TỰ ĐỘNG CHO BẢNG PHONGTIEUCHUAN
CREATE FUNCTION AUTO_MAPHONG_PHONGTIEUCHUAN()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MAPHONG, 3) AS INT)), 0) + 1
    FROM PHONGTIEUCHUAN

    SELECT @ID = 'PTC' + RIGHT('000' + CAST(@NEWID AS VARCHAR(4)), 4)

    RETURN @ID
END
GO

--THÊM DỮ LIỆU CHO BẢNG PHONGTIEUCHUAN
INSERT INTO PHONGTIEUCHUAN VALUES
('MP0001', 400000),
('MP0002', 300000),
('MP0003', 350000),
('MP0004', 450000),
('MP0005', 500000),
('MP0006', 250000),
('MP0007', 400000),
('MP0008', 350000),
('MP0009', 300000),
('MP0010', 500000)

--HÀM TẠO MÃ TỰ ĐỘNG CHO PHONGVIP
CREATE FUNCTION AUTO_MAPHONG_PHONGVIP()
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ID VARCHAR(20)
    DECLARE @NEWID INT

    SELECT @NEWID = ISNULL(MAX(CAST(RIGHT(MAPHONG, 3) AS INT)), 0) + 1
    FROM PHONGVIP

    SELECT @ID = 'PV' + RIGHT('000' + CAST(@NEWID AS VARCHAR(4)), 4)

    RETURN @ID
END
GO

--THÊM DỮ LIỆU CHO BẢNG PHONGVIP
INSERT INTO PHONGVIP VALUES
('MP0001', 2000000, N'TẶNG GIỎ TRÁI CÂY TRONG PHÒNG'),
('MP0002', 2000000, N'TẶNG GIỎ TRÁI CÂY TRONG PHÒNG'),
('MP0003', 2000000, N'TẶNG GIỎ TRÁI CÂY TRONG PHÒNG'),
('MP0004', 2000000, N'TẶNG GIỎ TRÁI CÂY TRONG PHÒNG'),
('MP0005', 1000000, NULL),
('MP0006', 1000000, NULL),
('MP0007', 3000000, N'ĐƯA ĐÓN 1 CHIỀU SÂN BAY'),
('MP0008', 3000000, N'ĐƯA ĐÓN 1 CHIỀU SÂN BAY'),
('MP0009', 3000000, N'ĐƯA ĐÓN 1 CHIỀU SÂN BAY'),
('MP0010', 5000000, N'BUFFET SÁNG')

--YÊU CẦU 3
--TRIGGER RÀNG BUỘC KHÓA NGOẠI
CREATE TRIGGER TR_PHIEUDATPHONG_FK
ON PHIEUDATPHONG
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra ràng buộc khoá ngoại với bảng KHACHHANG
    IF EXISTS (SELECT * FROM INSERTED I WHERE NOT EXISTS (SELECT * FROM KHACHHANG WHERE MAKHACHHANG = I.MAKHACHHANG))
    BEGIN
        PRINT 'LOI. MA KHACH HANG KHONG TON TAI.'
        ROLLBACK
        RETURN
    END

    -- Kiểm tra ràng buộc khoá ngoại với bảng HOADON
    IF EXISTS (SELECT * FROM INSERTED I WHERE NOT EXISTS (SELECT * FROM HOADON WHERE MAHOADON = I.MAHOADON))
    BEGIN
        PRINT 'LOI. MA HOA DON KHONG TON TAI.'
        ROLLBACK
        RETURN
    END
END

--TRIGGER CHO BẢNG HOADON
CREATE TRIGGER TR_HOADON_FK
ON HOADON
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra ràng buộc khoá ngoại với bảng PHIEUDATPHONG
    IF EXISTS (SELECT * FROM INSERTED i WHERE NOT EXISTS (SELECT * FROM PHIEUDATPHONG WHERE MADATPHONG = i.MADATPHONG))
    BEGIN
        PRINT 'LOI. MA DAT PHONG KHONG TON TAI!'
        ROLLBACK;
        RETURN;
    END
END

--CODE THÊM VỀ TẠO TRIGGER
-- Trigger kiểm tra ràng buộc miền giá trị cho DICHVU
CREATE TRIGGER CHECKGIADICHVU
ON DICHVU
AFTER INSERT
AS
BEGIN
    DECLARE @HASNEGATIVEGIADICHVU BIT;

    SELECT @HASNEGATIVEGIADICHVU = 1
    FROM INSERTED
    WHERE GIADICHVU < 0;

    IF @HASNEGATIVEGIADICHVU = 1
    BEGIN
        PRINT N'Không thể thêm giá dịch vụ âm. Giao dịch bị hủy!'
    END
END

INSERT INTO DICHVU (MADICHVU, GIADICHVU, TENDICHVU) VALUES ('DV0012', -50000, N'SÂN BÓNG')

--TRIGGER TRƯỚC KHI CHÈN MỘT KHÁCH HÀNG MỚI
CREATE TRIGGER TRUOCKHICHENKHACHHANG
ON KHACHHANG
AFTER INSERT
AS
BEGIN
    UPDATE KHACHHANG
    SET TENKHACHHANG = UPPER(TENKHACHHANG)
    WHERE MAKHACHHANG IN (SELECT MAKHACHHANG FROM INSERTED)
END
INSERT INTO KHACHHANG (MAKHACHHANG, TENKHACHHANG, THEDINHDANH) VALUES
('KH0012', N'NGUYỄN VĂN ĐẠT', '12898612DAS'),
('KH0013', N'TRẦN HẢO HUYỀN', 'ASD123DSA')
SELECT * FROM KHACHHANG

--TĂNG GIÁ DỊCH VỤ
CREATE TRIGGER TANGGIADICHVU
ON DICHVU
AFTER INSERT
AS
BEGIN
    DECLARE @GIAMOIVAO INT

    SELECT @GIAMOIVAO = GIADICHVU
    FROM INSERTED;

    -- Tăng giá dịch vụ lên, ví dụ, tăng 10%
    SET @GIAMOIVAO = @GIAMOIVAO * 1.1

    -- Cập nhật giá dịch vụ mới
    UPDATE DICHVU
    SET GIADICHVU = @GIAMOIVAO
    WHERE MADICHVU IN (SELECT MADICHVU FROM INSERTED)
END

INSERT INTO DICHVU (MADICHVU, GIADICHVU, TENDICHVU) VALUES ('DV0011', 800000, N'BUFFET SÁNG 3 HÔM')
SELECT * FROM DICHVU WHERE MADICHVU = 'DV0011'
GO

--CODE THÊM VỀ TẠO FUNCTION
---- HÀM PHÁT SINH MÃ CHO DICHVU
CREATE FUNCTION dbo.PHATSINHMADICHVU()
RETURNS CHAR(20)
AS
BEGIN
    DECLARE @NextID INT
    SELECT @NextID = ISNULL(MAX(CAST(SUBSTRING(MADICHVU, 3, LEN(MADICHVU)) AS INT)), 0) + 1
    FROM DICHVU

    DECLARE @NewID CHAR(20)
    SET @NewID = 'DV' + RIGHT('0000' + CAST(@NextID AS VARCHAR(4)), 4)

    -- Kiểm tra xem giá trị mới có tồn tại không
    WHILE EXISTS (SELECT 1 FROM DICHVU WHERE MADICHVU = @NewID)
    BEGIN
        SET @NextID = @NextID + 1
        SET @NewID = 'DV' + RIGHT('0000' + CAST(@NextID AS VARCHAR(4)), 4)
    END

    RETURN @NewID
END

SELECT dbo.PHATSINHMADICHVU() AS NewID

--CODE THÊM TẠO PROCEDURE
--LẤY THÔNG TIN ĐẶT PHÒNG CỦA MỘT KHÁCH HÀNG CỤ THỂ
CREATE PROCEDURE LAYTHONGTINDATPHONGCUAKHACHHANG
    @p_MAKHACHHANG CHAR(20)
AS
BEGIN
    SELECT *
    FROM PHIEUDATPHONG
    WHERE MAKHACHHANG = @p_MAKHACHHANG
END

EXEC LAYTHONGTINDATPHONGCUAKHACHHANG @p_MAKHACHHANG = 'KH0003'

--THÊM MỚI MỘT KHÁCH HÀNG
CREATE PROCEDURE THEMMOIKHACHHANG
    @MAKHACHHANG CHAR(20),
    @TENKHACHHANG NVARCHAR(30),
    @THEDINHDANH CHAR(20)
AS
BEGIN
    INSERT INTO KHACHHANG (MAKHACHHANG, TENKHACHHANG, THEDINHDANH)
    VALUES (@MAKHACHHANG, @TENKHACHHANG, @THEDINHDANH)
END

EXEC THEMMOIKHACHHANG @MAKHACHHANG = 'KH0011', @TENKHACHHANG = N'NGUYỄN TRƯƠNG THAO', @THEDINHDANH = '214671273X7213'

--TÌM KHÁCH HÀNG THANH TOÁN SAU NẰM 2020
CREATE PROCEDURE TIMKHACHHANGTHANHTOANSAU2020
AS
BEGIN
    SELECT DISTINCT KHACHHANG.*
    FROM KHACHHANG
    JOIN PHIEUDATPHONG ON KHACHHANG.MAKHACHHANG = PHIEUDATPHONG.MAKHACHHANG
    JOIN HOADON ON PHIEUDATPHONG.MAHOADON = HOADON.MAHOADON
    WHERE YEAR(HOADON.NGAYTHANHTOAN) > 2020
END

EXEC TIMKHACHHANGTHANHTOANSAU2020
	