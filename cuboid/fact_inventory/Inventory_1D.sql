


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time (Year, Quarter, Month)
    DROP TABLE IF EXISTS Inventory_1D_Year_Quarter_Month;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_Year_Quarter_Month
    FROM Inventory_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month;

    -- 2. Time (Year, Quarter)
    DROP TABLE IF EXISTS Inventory_1D_Year_Quarter;
    SELECT
        fs.Year,
        fs.Quarter,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_Year_Quarter
    FROM Inventory_1D_Year_Quarter_Month fs
    GROUP BY
        fs.Year,
        fs.Quarter;

    -- 3. Time (Year)
    DROP TABLE IF EXISTS Inventory_1D_Year;
    SELECT
        fs.Year,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_Year
    FROM Inventory_1D_Year_Quarter fs
    GROUP BY
        fs.Year;

    -- 4. Time (Quarter)
    DROP TABLE IF EXISTS Inventory_1D_Quarter;
    SELECT
        fs.Quarter,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_Quarter
    FROM Inventory_1D_Year_Quarter fs
    GROUP BY
        fs.Quarter;

    -- 5. Time (Month)
    DROP TABLE IF EXISTS Inventory_1D_Month;
    SELECT
        fs.Month,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_Month
    FROM Inventory_1D_Year_Quarter_Month fs
    GROUP BY
        fs.Month;

    -- 6. Product
    DROP TABLE IF EXISTS Inventory_1D_Product;
    SELECT
        fs.Product_Key,
        fs.Description,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_Product
    FROM Inventory_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Product_Key,
        fs.Description;

    -- 7. Store
    DROP TABLE IF EXISTS Inventory_1D_Store;
    SELECT
        fs.Store_Key,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_Store
    FROM Inventory_2D_Year_Quarter_Month_Store fs
    GROUP BY
        fs.Store_Key;

    -- 8. Location (City)
    DROP TABLE IF EXISTS Inventory_1D_City;
    SELECT
        fs.City,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_City
    FROM Inventory_2D_Year_Quarter_Month_City fs
    GROUP BY
        fs.City,
        fs.State;

    -- 9. Location (State) 
    DROP TABLE IF EXISTS Inventory_1D_State;
    SELECT
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_1D_State
    FROM Inventory_2D_Year_Quarter_Month_State fs
    GROUP BY
        fs.State;
        


END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
