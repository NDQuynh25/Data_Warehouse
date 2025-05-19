USE DW;
GO

CREATE OR ALTER PROCEDURE sp_Load_Dim_Time
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa dữ liệu cũ
    DELETE FROM dbo.Dim_Time;

    -- Temporary table để giữ giá trị Year và Month
    IF OBJECT_ID('tempdb..#TimeParts') IS NOT NULL
        DROP TABLE #TimeParts;

    CREATE TABLE #TimeParts (
        Year INT,
        Month INT
    );

    -- Trích xuất từ Ordered_Product.Delivery_Time
    INSERT INTO #TimeParts (Year, Month)
    SELECT DISTINCT
        YEAR(O.Order_Date) AS Year,
        MONTH(O.Order_Date) AS Month
    FROM IDB.dbo.Ordered_Product OP
    JOIN IDB.dbo.[Order] O ON OP.Order_ID = O.Order_ID
    WHERE OP.Delivery_Time IS NOT NULL;

    -- Trích xuất từ Stored_Product.Update_Time
    INSERT INTO #TimeParts (Year, Month)
    SELECT DISTINCT
        YEAR(Update_Time),
        MONTH(Update_Time)
    FROM IDB.dbo.Stored_Product
    WHERE Update_Time IS NOT NULL;

    -- Loại bỏ trùng lặp và tính toán Time_Key, Quarter
    WITH DistinctTime AS (
        SELECT DISTINCT Year, Month FROM #TimeParts
    )
    INSERT INTO dbo.Dim_Time (Time_Key, Year, Quarter, Month)
    SELECT
        (Year * 100 + Month) AS Time_Key,
        Year,
        DATEPART(QUARTER, DATEFROMPARTS(Year, Month, 1)) AS Quarter,
        Month
    FROM DistinctTime;
END;
GO
