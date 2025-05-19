USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month)
    DROP TABLE IF EXISTS Sales_1D_Year_Quarter_Month;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_Year_Quarter_Month
    FROM Sales_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month;

    -- 2. Time(Year, Quarter)
    DROP TABLE IF EXISTS Sales_1D_Year_Quarter;
    SELECT
        fs.Year,
        fs.Quarter,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_Year_Quarter
    FROM Sales_1D_Year_Quarter_Month fs
    GROUP BY
        fs.Year,
        fs.Quarter;

    -- 3. Time(Year)
    DROP TABLE IF EXISTS Sales_1D_Year;
    SELECT
        fs.Year,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_Year
    FROM Sales_1D_Year_Quarter fs
    GROUP BY
        fs.Year;

    -- 4. Time(Quarter)
    DROP TABLE IF EXISTS Sales_1D_Quarter;
    SELECT
        fs.Quarter,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_Quarter
    FROM Sales_1D_Year_Quarter fs
    GROUP BY
        fs.Quarter;

    -- 5. Time(Month)
    DROP TABLE IF EXISTS Sales_1D_Month;
    SELECT
        fs.Month,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_Month
    FROM Sales_1D_Year_Quarter_Month fs
    GROUP BY
        fs.Month;

    -- 6. Product
    DROP TABLE IF EXISTS Sales_1D_Product;
    SELECT
        fs.Product_Key,
        fs.Description,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_Product
    FROM Sales_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Product_Key,
        fs.Description;

    -- 7. Customer(Customer_Key)
    DROP TABLE IF EXISTS Sales_1D_CustomerKey;
    SELECT
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_CustomerKey
    FROM Sales_2D_Product_CustomerKey fs
    GROUP BY
        fs.Customer_Key,
        fs.Customer_Name,
        fs.Customer_Type;

    -- 8. Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_1D_CustomerType;
    SELECT
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_CustomerType
    FROM Sales_1D_CustomerKey fs
    GROUP BY
        fs.Customer_Type;

   -- 9. Location(City)
    DROP TABLE IF EXISTS Sales_1D_City;
    SELECT
        fs.City,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_City
    FROM Sales_2D_Product_City fs
    GROUP BY
        fs.City,
        fs.State;

    -- 10. Location(State)
    DROP TABLE IF EXISTS Sales_1D_State;
    SELECT
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_1D_State
    FROM Sales_1D_City fs
    GROUP BY
        fs.State;
   



        

END;
GO
EXEC Generate_Sales_Aggregation_Tables;
