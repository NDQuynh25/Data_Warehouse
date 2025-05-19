


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Product + Location(City)
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Month_Product_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Month_Product_City
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 2. Year, Quarter + Product + City
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Product_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Product_City
    FROM Inventory_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 3. Year + Product + City
    DROP TABLE IF EXISTS Inventory_3D_Year_Product_City;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Product_City
    FROM Inventory_3D_Year_Quarter_Product_City fs
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 4. Quarter + Product + City
    DROP TABLE IF EXISTS Inventory_3D_Quarter_Product_City;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Quarter_Product_City
    FROM Inventory_3D_Year_Quarter_Product_City fs
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 5. Month + Product + City
    DROP TABLE IF EXISTS Inventory_3D_Month_Product_City;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Month_Product_City
    FROM Inventory_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 6. Year, Quarter, Month + Product + State
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Month_Product_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Month_Product_State
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 7. Year, Quarter + Product + State
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Product_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Product_State
    FROM Inventory_3D_Year_Quarter_Month_Product_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 8. Year + Product + State
    DROP TABLE IF EXISTS Inventory_3D_Year_Product_State;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Product_State
    FROM Inventory_3D_Year_Quarter_Product_State fs
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 9. Quarter + Product + State
    DROP TABLE IF EXISTS Inventory_3D_Quarter_Product_State;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Quarter_Product_State
    FROM Inventory_3D_Year_Quarter_Product_State fs
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 10. Month + Product + State
    DROP TABLE IF EXISTS Inventory_3D_Month_Product_State;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Month_Product_State
    FROM Inventory_3D_Year_Quarter_Month_Product_State fs
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State;

END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
