USE DW;
GO

CREATE OR ALTER PROCEDURE sp_Load_Dim_Product
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Xóa dữ liệu cũ trong Dim_Product (nếu cần làm sạch trước khi nạp lại)
        DELETE FROM dbo.Dim_Product;

        -- Chèn dữ liệu từ IDB.dbo.Product
        INSERT INTO dbo.Dim_Product (Product_Key, Description, Size, Weight, Price)
        SELECT 
            Product_ID AS Product_Key,
            Description,
            Size,
            Weight,
            Price
        FROM IDB.dbo.Product;

        PRINT N'Dữ liệu đã được đồng bộ vào Dim_Product thành công.';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi đồng bộ Dim_Product: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Thực thi procedure
EXEC sp_Load_Dim_Product;
