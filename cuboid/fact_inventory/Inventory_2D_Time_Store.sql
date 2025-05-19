


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Store
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_Month_Store;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Store_Key,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_Month_Store
    FROM Inventory_3D_Year_Quarter_Month_Product_Store fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Store_Key;

    -- 2. Time(Year, Quarter) + Store
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_Store;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Store_Key,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_Store
    FROM Inventory_2D_Year_Quarter_Month_Store fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Store_Key;

    -- 3. Time(Year) + Store
    DROP TABLE IF EXISTS Inventory_2D_Year_Store;
    SELECT
        fs.Year,
        fs.Store_Key,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Store
    FROM Inventory_2D_Year_Quarter_Store fs
    GROUP BY
        fs.Year,
        fs.Store_Key;

    -- 4. Time(Quarter) + Store
    DROP TABLE IF EXISTS Inventory_2D_Quarter_Store;
    SELECT
        fs.Quarter,
        fs.Store_Key,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Quarter_Store
    FROM Inventory_2D_Year_Quarter_Store fs
    GROUP BY
        fs.Quarter,
        fs.Store_Key;
        
    -- 5. Time(Month) + Store
    DROP TABLE IF EXISTS Inventory_2D_Month_Store;
    SELECT
        fs.Month,
        fs.Store_Key,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Month_Store
    FROM Inventory_2D_Year_Quarter_Month_Store fs
    GROUP BY
        fs.Month,
        fs.Store_Key;


END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
