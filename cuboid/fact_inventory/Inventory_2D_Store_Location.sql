


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Store + Location(City)
    DROP TABLE IF EXISTS Inventory_2D_Store_City
    SELECT
        fs.Store_Key,
        fs.State,
        fs.City,
        SUM(fs.Import_Quantity) AS Import_Quantity,
        SUM(fs.Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Store_City
    FROM Inventory_3D_Product_Store_City fs
    GROUP BY
        fs.Store_Key,
        fs.State,
        fs.City;
    -- 2. Store + Location(State)
    DROP TABLE IF EXISTS Inventory_2D_Store_State
    SELECT
        fs.Store_Key,
        fs.State,
        SUM(fs.Import_Quantity) AS Import_Quantity,
        SUM(fs.Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Store_State
    FROM Inventory_2D_Store_City fs
    GROUP BY
        fs.Store_Key,
        fs.State;
    

END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
