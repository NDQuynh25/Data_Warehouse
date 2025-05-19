


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Product + Location(City)
    DROP TABLE IF EXISTS Inventory_2D_Product_City;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(fs.Import_Quantity) AS Import_Quantity,
        SUM(fs.Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Product_City
    FROM Inventory_3D_Product_Store_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 2. Product + Location(State)
    DROP TABLE IF EXISTS Inventory_2D_Product_State;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(fs.Import_Quantity) AS Import_Quantity,
        SUM(fs.Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Product_State
    FROM Inventory_2D_Product_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.State;

END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
