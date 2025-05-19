


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Product
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_Month_Product;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_Month_Product
    FROM Inventory_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Description,
        fs.Product_Key;
    -- 2. Time(Year, Quarter) + Product
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_Product;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_Product
    FROM Inventory_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description;

    -- 3. Time(Year) + Product
    DROP TABLE IF EXISTS Inventory_2D_Year_Product;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Product
    FROM Inventory_2D_Year_Quarter_Product fs
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description;

    -- 4. Time(Quarter) + Product
    DROP TABLE IF EXISTS Inventory_2D_Quarter_Product;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Quarter_Product
    FROM Inventory_2D_Year_Quarter_Product fs
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description;

    -- 5. Time(Month) + Product
    DROP TABLE IF EXISTS Inventory_2D_Month_Product;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Month_Product
    FROM Inventory_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description;


END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
