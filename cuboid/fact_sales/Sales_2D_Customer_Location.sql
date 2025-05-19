USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Customer(Customer_Key) + Location(City)
    DROP TABLE IF EXISTS Sales_2D_Customer_City;
    SELECT
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Customer_City
    FROM Sales_3D_Product_CustomerKey_City fs
    GROUP BY
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State,
        fs.City;

    -- 2. Customer(Customer_Key) + Location(State)
    DROP TABLE IF EXISTS Sales_2D_Customer_Location;
    SELECT
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Customer_Location
    FROM Sales_2D_Customer_City fs
    GROUP BY
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State;
    -- 3. Customer(Customer_Type) + Location(City)
    DROP TABLE IF EXISTS Sales_2D_CustomerType_City;
    SELECT
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_CustomerType_City
    FROM Sales_2D_Customer_City fs
    GROUP BY
        fs.Customer_Type,
        fs.State,
        fs.City;
    -- 4. Customer(Customer_Type) + Location(State)
    DROP TABLE IF EXISTS Sales_2D_CustomerType_Location;
    SELECT
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_CustomerType_Location
    FROM Sales_2D_CustomerType_City fs
    GROUP BY
        fs.Customer_Type,
        fs.State;
        

END;
GO
EXEC Generate_Sales_Aggregation_Tables;
