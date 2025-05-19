USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Location(City)
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_Month_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_Month_City
    FROM Sales_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State,
        fs.City;
    -- 2. Time(Year, Quarter) + Location(City)
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_City
    FROM Sales_2D_Year_Quarter_Month_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.State,
        fs.City;
    -- 3. Time(Year) + Location(City)
    DROP TABLE IF EXISTS Sales_2D_Year_City;
    SELECT
        fs.Year,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_City
    FROM Sales_2D_Year_Quarter_City fs
    GROUP BY
        fs.Year,
        fs.State,
        fs.City;
    -- 4. Time(Quarter) + Location(City)
    DROP TABLE IF EXISTS Sales_2D_Quarter_City;
    SELECT
        fs.Quarter,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Quarter_City
    FROM Sales_2D_Year_Quarter_City fs
    GROUP BY
        fs.Quarter,
        fs.State,
        fs.City;
    -- 5. Time(Month) + Location(City)
    DROP TABLE IF EXISTS Sales_2D_Month_City;
    SELECT
        fs.Month,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Month_City
    FROM Sales_2D_Year_Quarter_Month_City fs
    GROUP BY
        fs.Month,
        fs.State,
        fs.City;
    -- 6. Time(Year, Quarter, Month) + Location(State)
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_Month_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_Month_State
    FROM Sales_3D_Year_Quarter_Month_Product_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State;
    -- 7. Time(Year, Quarter) + Location(State)
    DROP TABLE IF EXISTS Sales_2D_Year_Quarter_State;

    SELECT
        fs.Year,
        fs.Quarter,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_Quarter_State
    FROM Sales_2D_Year_Quarter_Month_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.State;
    -- 8. Time(Year) + Location(State)
    DROP TABLE IF EXISTS Sales_2D_Year_State;

    SELECT
        fs.Year,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Year_State
    FROM Sales_2D_Year_Quarter_State fs
    GROUP BY
        fs.Year,
        fs.State;
    -- 9. Time(Quarter) + Location(State)
    DROP TABLE IF EXISTS Sales_2D_Quarter_State;
    SELECT
        fs.Quarter,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Quarter_State
    FROM Sales_2D_Year_Quarter_State fs
    GROUP BY
        fs.Quarter,
        fs.State;
    -- 10. Time(Month) + Location(State)
    DROP TABLE IF EXISTS Sales_2D_Month_State;
    SELECT
        fs.Month,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_2D_Month_State
    FROM Sales_2D_Year_Quarter_Month_State fs
    GROUP BY
        fs.Month,
        fs.State;

    

    

END;
GO
EXEC Generate_Sales_Aggregation_Tables;
