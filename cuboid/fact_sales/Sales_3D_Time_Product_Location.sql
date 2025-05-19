USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Product + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Month_Product_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Month_Product_City
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerKey_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 2. Year, Quarter + Product + City
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Product_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Product_City
    FROM Sales_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 3. Year + Product + City
    DROP TABLE IF EXISTS Sales_3D_Year_Product_City;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Product_City
    FROM Sales_3D_Year_Quarter_Product_City fs
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 4. Quarter + Product + City
    DROP TABLE IF EXISTS Sales_3D_Quarter_Product_City;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Quarter_Product_City
    FROM Sales_3D_Year_Quarter_Product_City fs
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 5. Month + Product + City
    DROP TABLE IF EXISTS Sales_3D_Month_Product_City;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Month_Product_City
    FROM Sales_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        fs.City;

    -- 6. Year, Quarter, Month + Product + State
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Month_Product_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Month_Product_State
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerKey_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 7. Year, Quarter + Product + State
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Product_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Product_State
    FROM Sales_3D_Year_Quarter_Month_Product_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 8. Year + Product + State
    DROP TABLE IF EXISTS Sales_3D_Year_Product_State;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Product_State
    FROM Sales_3D_Year_Quarter_Product_State fs
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 9. Quarter + Product + State
    DROP TABLE IF EXISTS Sales_3D_Quarter_Product_State;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Quarter_Product_State
    FROM Sales_3D_Year_Quarter_Product_State fs
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.State;

    -- 10. Month + Product + State
    DROP TABLE IF EXISTS Sales_3D_Month_Product_State;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Month_Product_State
    FROM Sales_3D_Year_Quarter_Month_Product_State fs
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.State;

END;
GO
EXEC Generate_Sales_Aggregation_Tables;
