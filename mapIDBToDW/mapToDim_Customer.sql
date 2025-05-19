USE DW;
GO

CREATE OR ALTER PROCEDURE sp_Load_Dim_Customer
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa dữ liệu cũ trong Dim_Customer trước khi nạp dữ liệu mới
    DELETE FROM dbo.Dim_Customer;

    -- Trích xuất dữ liệu từ bảng Customer, Tourist_Customer và Postal_Customer
    INSERT INTO dbo.Dim_Customer (Customer_Key, Customer_Name, Customer_Type, Location_Key)
    SELECT 
        C.Customer_ID AS Customer_Key,  -- Gán Customer_ID làm Customer_Key
        C.Customer_Name,                -- Lấy Customer_Name từ bảng Customer
        CASE 
            WHEN TC.Customer_ID IS NOT NULL AND PC.Customer_ID IS NOT NULL THEN 'Tourist_Postal'
            WHEN TC.Customer_ID IS NOT NULL THEN 'Tourist'
            WHEN PC.Customer_ID IS NOT NULL THEN 'Postal'
            ELSE 'Unknown' -- Trường hợp không có thông tin về loại khách hàng
        END AS Customer_Type,           -- Xác định Customer_Type dựa trên Tourist_Customer và Postal_Customer
        C.City_ID AS Location_Key       -- Gán City_ID làm Location_Key để liên kết với Dim_Location
    FROM IDB.dbo.Customer C
    LEFT JOIN IDB.dbo.Tourist_Customer TC ON C.Customer_ID = TC.Customer_ID
    LEFT JOIN IDB.dbo.Postal_Customer PC ON C.Customer_ID = PC.Customer_ID;

    PRINT 'Dữ liệu đã được đồng bộ vào Dim_Customer thành công';
END;
GO

-- Thực thi procedure để đồng bộ dữ liệu
EXEC sp_Load_Dim_Customer;
