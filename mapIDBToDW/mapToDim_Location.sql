USE OLAP;
GO

CREATE OR ALTER PROCEDURE sp_Load_Dim_Location
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa dữ liệu cũ trong Dim_Location trước khi nạp dữ liệu mới
    DELETE FROM dbo.Dim_Location;

    -- Trích xuất dữ liệu từ Representative_Office trong IDB và chuyển đổi
    INSERT INTO dbo.Dim_Location (Location_Key, City, State)
    SELECT 
        City_ID AS Location_Key,  -- Sử dụng City_ID làm Location_Key
        City_Name AS City,        -- Đổi tên City_Name thành City
        State                     -- Giữ nguyên State
    FROM IDB.dbo.Representative_Office;

    PRINT 'Dữ liệu đã được đồng bộ vào Dim_Location thành công';
END;
GO

-- Thực thi procedure để đồng bộ dữ liệu
EXEC sp_Load_Dim_Location;
