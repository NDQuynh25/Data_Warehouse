USE DW;
GO

CREATE OR ALTER PROCEDURE sp_Load_Fact_Sales
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM dbo.Fact_Sales;

        INSERT INTO dbo.Fact_Sales (Product_Key, Customer_Key, Time_Key, Quantity_Sold, Revenue)
        SELECT
            op.Product_ID AS Product_Key,
            o.Customer_ID AS Customer_Key,
            YEAR(op.Delivery_Time) * 100 + MONTH(op.Delivery_Time) AS Time_Key,
            op.Ordered_Quantity AS Quantity_Sold,
            op.Ordered_Quantity * op.Ordered_Price AS Revenue
        FROM IDB.dbo.Ordered_Product op
        JOIN IDB.dbo.[Order] o ON op.Order_ID = o.Order_ID
      
     
        PRINT N'Dữ liệu đã được đồng bộ vào Fact_Sales thành công.';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi đồng bộ Fact_Sales: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Thực thi procedure
EXEC sp_Load_Fact_Sales;