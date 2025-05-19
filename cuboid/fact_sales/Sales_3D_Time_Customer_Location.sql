USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month)  + Customer(Customer_Key) + Location(City)
    -- 2. Time(Year, Quarter)  + Customer(Customer_Key) + Location(City)
    -- 3. Time(Year)  + Customer(Customer_Key) + Location(City)
    -- 4. Time(Quarter)  + Customer(Customer_Key) + Location(City)
    -- 5. Time(Month)  + Customer(Customer_Key) + Location(City)
    -- 6. Time(Year, Quarter, Month)  + Customer(Customer_Key) + Location(State)
    -- 7. Time(Year, Quarter)  + Customer(Customer_Key) + Location(State)
    -- 8. Time(Year)  + Customer(Customer_Key) + Location(State)
    -- 9. Time(Quarter)  + Customer(Customer_Key) + Location(State)
    -- 10. Time(Month)  + Customer(Customer_Key) + Location(State)

    -- 11. Time(Year, Quarter, Month)  + Customer(Customer_Type) + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Month_CustomerType_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Month_CustomerType_City
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerType_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Customer_Type,
        fs.State,
        fs.City;

    -- 12. Time(Year, Quarter)  + Customer(Customer_Type) + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_CustomerType_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_CustomerType_City
    FROM Sales_3D_Year_Quarter_Month_CustomerType_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Customer_Type,
        fs.State,
        fs.City;

    -- 13. Time(Year)  + Customer(Customer_Type) + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Year_CustomerType_City;
    SELECT
        fs.Year,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_CustomerType_City
    FROM Sales_3D_Year_Quarter_CustomerType_City fs
    GROUP BY
        fs.Year,
        fs.Customer_Type,
        fs.State,
        fs.City;

    -- 14. Time(Quarter)  + Customer(Customer_Type) + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Quarter_CustomerType_City;
    SELECT
        fs.Quarter,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Quarter_CustomerType_City
    FROM Sales_3D_Year_Quarter_CustomerType_City fs
    GROUP BY
        fs.Quarter,
        fs.Customer_Type,
        fs.State,
        fs.City;

    -- 15. Time(Month)  + Customer(Customer_Type) + Location(City)
    DROP TABLE IF EXISTS Sales_3D_Month_CustomerType_City;
    SELECT
        fs.Month,
        fs.Customer_Type,
        fs.State,
        fs.City,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Month_CustomerType_City
    FROM Sales_3D_Year_Quarter_Month_CustomerType_City fs
    GROUP BY
        fs.Month,
        fs.Customer_Type,
        fs.State,
        fs.City;

    -- 16. Time(Year, Quarter, Month)  + Customer(Customer_Type) + Location(State)
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Month_CustomerType_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Month_CustomerType_State
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerType_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Customer_Type,
        fs.State;

    -- 17. Time(Year, Quarter)  + Customer(Customer_Type) + Location(State)
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_CustomerType_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_CustomerType_State
    FROM Sales_3D_Year_Quarter_Month_CustomerType_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Customer_Type,
        fs.State;

    -- 18. Time(Year)  + Customer(Customer_Type) + Location(State)
    DROP TABLE IF EXISTS Sales_3D_Year_CustomerType_State;
    SELECT
        fs.Year,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_CustomerType_State
    FROM Sales_3D_Year_Quarter_CustomerType_State fs
    GROUP BY
        fs.Year,
        fs.Customer_Type,
        fs.State;

    -- 19. Time(Quarter)  + Customer(Customer_Type) + Location(State)
    DROP TABLE IF EXISTS Sales_3D_Quarter_CustomerType_State;
    SELECT
        fs.Quarter,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Quarter_CustomerType_State
    FROM Sales_3D_Year_Quarter_CustomerType_State fs
    GROUP BY
        fs.Quarter,
        fs.Customer_Type,
        fs.State;

    -- 20. Time(Month)  + Customer(Customer_Type) + Location(State)
    DROP TABLE IF EXISTS Sales_3D_Month_CustomerType_State;
    SELECT
        fs.Month,
        fs.Customer_Type,
        fs.State,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Month_CustomerType_State
    FROM Sales_3D_Year_Quarter_Month_CustomerType_State fs
    GROUP BY
        fs.Month,
        fs.Customer_Type,
        fs.State;

    
END;
GO
EXEC Generate_Sales_Aggregation_Tables;
