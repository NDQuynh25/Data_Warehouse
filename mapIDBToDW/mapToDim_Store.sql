USE DW;
GO

CREATE OR ALTER PROCEDURE sp_Load_Dim_Store
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Xóa dữ liệu cũ trong Dim_Store (nếu cần làm sạch trước khi nạp lại)
        DELETE FROM dbo.Dim_Store;

        -- Chèn dữ liệu hợp lệ từ IDB.dbo.Store (có Location_Key tồn tại trong Dim_Location)
        INSERT INTO dbo.Dim_Store (Store_Key, Location_Key)
        SELECT 
            Store_ID AS Store_Key,
            City_ID AS Location_Key
        FROM IDB.dbo.Store
        WHERE City_ID IN (SELECT Location_Key FROM dbo.Dim_Location);

        PRINT N'Dữ liệu đã được đồng bộ vào Dim_Store thành công';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi đồng bộ Dim_Store: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Thực thi procedure
EXEC sp_Load_Dim_Store;
