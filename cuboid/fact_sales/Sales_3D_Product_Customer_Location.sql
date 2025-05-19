USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Product + Customer(Customer_Key) + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Product_CustomerKey_City;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Product_CustomerKey_City
    FROM Sales_4D_Year_Product_CustomerKey_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State,
        fs.City;
    

    -- 2. Product + Customer(Customer_Key) + Location(State)
    DROP TABLE IF EXISTS Sales_3D_Product_CustomerKey_State;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Product_CustomerKey_State
    FROM Sales_3D_Product_CustomerKey_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        fs.State;   


    -- 3. Product + Customer(Customer_Type) + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Product_CustomerType_City;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Product_CustomerType_City
    FROM Sales_4D_Year_Product_CustomerType_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        fs.State,
        fs.City;
        
    -- 4. Product + Customer(Customer_Type) + Location(State)
    DROP TABLE IF EXISTS Sales_3D_Product_CustomerType_State;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Product_CustomerType_State
    FROM Sales_3D_Product_CustomerType_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        fs.State;
    

    
END;
GO
EXEC Generate_Sales_Aggregation_Tables;
