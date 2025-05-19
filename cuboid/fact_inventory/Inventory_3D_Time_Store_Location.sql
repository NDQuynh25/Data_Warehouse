


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Store + Location(City)
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Month_Store_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Store_Key,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Month_Store_City
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Store_Key,
        fs.State,
        fs.City;

    -- 2. Year, Quarter + Store + City
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Store_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Store_Key,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Store_City
    FROM Inventory_3D_Year_Quarter_Month_Store_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Store_Key,
        fs.State,
        fs.City;

    -- 3. Year + Store + City
    DROP TABLE IF EXISTS Inventory_3D_Year_Store_City;
    SELECT
        fs.Year,
        fs.Store_Key,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Store_City
    FROM Inventory_3D_Year_Quarter_Store_City fs
    GROUP BY
        fs.Year,
        fs.Store_Key,
        fs.State,
        fs.City;

    -- 4. Quarter + Store + City
    DROP TABLE IF EXISTS Inventory_3D_Quarter_Store_City;
    SELECT
        fs.Quarter,
        fs.Store_Key,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Quarter_Store_City
    FROM Inventory_3D_Year_Quarter_Store_City fs
    GROUP BY
        fs.Quarter,
        fs.Store_Key,
        fs.State,
        fs.City;

    -- 5. Month + Store + City
    DROP TABLE IF EXISTS Inventory_3D_Month_Store_City;
    SELECT
        fs.Month,
        fs.Store_Key,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Month_Store_City
    FROM Inventory_3D_Year_Quarter_Month_Store_City fs
    GROUP BY
        fs.Month,
        fs.Store_Key,
        fs.State,
        fs.City;

    -- 6. Year, Quarter, Month + Store + State
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Month_Store_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Store_Key,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Month_Store_State
    FROM Inventory_3D_Year_Quarter_Month_Store_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Store_Key,
        fs.State;

    -- 7. Year, Quarter + Store + State
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Store_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Store_Key,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Store_State
    FROM Inventory_3D_Year_Quarter_Month_Store_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Store_Key,
        fs.State;

    -- 8. Year + Store + State
    DROP TABLE IF EXISTS Inventory_3D_Year_Store_State;
    SELECT
        fs.Year,
        fs.Store_Key,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Store_State
    FROM Inventory_3D_Year_Quarter_Store_State fs
    GROUP BY
        fs.Year,
        fs.Store_Key,
        fs.State;

    -- 9. Quarter + Store + State
    DROP TABLE IF EXISTS Inventory_3D_Quarter_Store_State;
    SELECT
        fs.Quarter,
        fs.Store_Key,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Quarter_Store_State
    FROM Inventory_3D_Year_Quarter_Store_State fs
    GROUP BY
        fs.Quarter,
        fs.Store_Key,
        fs.State;

    -- 10. Month + Store + State
    DROP TABLE IF EXISTS Inventory_3D_Month_Store_State;
    SELECT
        fs.Month,
        fs.Store_Key,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Month_Store_State
    FROM Inventory_3D_Year_Quarter_Month_Store_State fs
    GROUP BY
        fs.Month,
        fs.Store_Key,
        fs.State;

END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
