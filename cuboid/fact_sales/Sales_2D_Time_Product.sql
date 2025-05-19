USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Product
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_Month_Product;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_Month_Product
    FROM Sales_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description;

    -- 2. Time(Year, Quarter) + Product
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_Product;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_Product
    FROM Sales_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description;
    -- 3. Time(Year) + Product
    DROP TABLE IF EXISTS Sales_2D_Year_Product;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Product
    FROM Sales_2D_Year_Quarter_Product fs
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description;
    -- 4. Time(Quarter) + Product
    DROP TABLE IF EXISTS Sales_2D_Quarter_Product;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Quarter_Product
    FROM Sales_2D_Year_Quarter_Product fs
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description;
    -- 5. Time(Month) + Product
    DROP TABLE IF EXISTS Sales_2D_Month_Product;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Month_Product
    FROM Sales_2D_Year_Quarter_Month_Product fs
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description;


END;
GO
EXEC Generate_Sales_Aggregation_Tables;
