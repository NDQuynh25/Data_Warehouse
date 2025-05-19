USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Product + Customer(Customer_Key)
    DROP TABLE IF EXISTS Sales_2D_Product_CustomerKey;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Product_CustomerKey
    FROM Sales_3D_Product_CustomerKey_City fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type;

    -- 2. Product + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_2D_Product_CustomerType;
    SELECT
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Product_CustomerType
    FROM Sales_2D_Product_CustomerKey fs
    GROUP BY
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type;
    

END;
GO
EXEC Generate_Sales_Aggregation_Tables;
