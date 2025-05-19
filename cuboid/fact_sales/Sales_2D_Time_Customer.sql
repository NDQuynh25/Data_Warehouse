USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Customer(Customer_Key)
    -- 2. Time(Year, Quarter) + Customer(Customer_Key)
    -- 3. Time(Year) + Customer(Customer_Key)
    -- 4. Time(Quarter) + Customer(Customer_Key)
    -- 5. Time(Month) + Customer(Customer_Key)
    -- 6. Time(Year, Quarter, Month) + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_Month_CustomerType;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_Month_CustomerType
    FROM Sales_3D_Year_Quarter_Month_Product_CustomerType fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Customer_Type;
    -- 7. Time(Year, Quarter) + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_CustomerType;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_CustomerType
    FROM Sales_2D_Year_Quarter_Month_CustomerType fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Customer_Type;
    -- 8. Time(Year) + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_2D_Year_CustomerType;
    SELECT
        fs.Year,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_CustomerType
    FROM Sales_2D_Year_Quarter_CustomerType fs
    GROUP BY
        fs.Year,
        fs.Customer_Type;
    -- 9. Time(Quarter) + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_2D_Quarter_CustomerType;
    SELECT
        fs.Quarter,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Quarter_CustomerType
    FROM Sales_2D_Year_Quarter_CustomerType fs
    GROUP BY
        fs.Quarter,
        fs.Customer_Type;
    -- 10. Time(Month) + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_2D_Month_CustomerType;
    SELECT
        fs.Month,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Month_CustomerType
    FROM Sales_2D_Year_Quarter_Month_CustomerType fs
    GROUP BY
        fs.Month,
        fs.Customer_Type;

    

END;
GO
EXEC Generate_Sales_Aggregation_Tables;
