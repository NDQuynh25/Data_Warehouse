


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Product + Store
    DROP TABLE IF EXISTS Inventory_2D_Product_Store;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.Store_Key,
        SUM(fs.Import_Quantity) AS Import_Quantity,
        SUM(fs.Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Product_Store
    FROM Inventory_3D_Product_Store_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.Store_Key;

    
        

END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
