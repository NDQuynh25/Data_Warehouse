USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Product + Location(City)
    DROP TABLE IF EXISTS Sales_2D_Product_City;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Product_City
    FROM Sales_3D_Product_CustomerKey_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 2. Product + Location(State)
    DROP TABLE IF EXISTS Sales_2D_Product_State;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Product_State
    FROM Sales_2D_Product_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.State;

    

END;
GO
EXEC Generate_Sales_Aggregation_Tables;
