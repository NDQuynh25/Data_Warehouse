


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Location(City)
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_Month_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_Month_City
    FROM Inventory_3D_Year_Quarter_Month_Product_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State,
        fs.City;
    -- 2. Time(Year, Quarter) + Location(City)
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_City;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_City
    FROM Inventory_2D_Year_Quarter_Month_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.State,
        fs.City;
    -- 3. Time(Year) + Location(City)
    DROP TABLE IF EXISTS Inventory_2D_Year_City;
    SELECT
        fs.Year,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_City
    FROM Inventory_2D_Year_Quarter_City fs
    GROUP BY
        fs.Year,
        fs.State,
        fs.City;
    -- 4. Time(Quarter) + Location(City)
    DROP TABLE IF EXISTS Inventory_2D_Quarter_City;
    SELECT
        fs.Quarter,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Quarter_City
    FROM Inventory_2D_Year_Quarter_City fs
    GROUP BY
        fs.Quarter,
        fs.State,
        fs.City;
    -- 5. Time(Month) + Location(City)
    DROP TABLE IF EXISTS Inventory_2D_Month_City;
    SELECT
        fs.Month,
        fs.State,
        fs.City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Month_City
    FROM Inventory_2D_Year_Quarter_Month_City fs
    GROUP BY
        fs.Month,
        fs.State,
        fs.City;
   
    -- 6. Time(Year, Quarter, Month) + Location(State)
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_Month_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_Month_State
    FROM Inventory_2D_Year_Quarter_Month_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.State;
    -- 7. Time(Year, Quarter) + Location(State)
    DROP TABLE IF EXISTS Inventory_2D_Year_Quarter_State;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_Quarter_State
    FROM Inventory_2D_Year_Quarter_Month_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.State;
    -- 8. Time(Year) + Location(State)
    DROP TABLE IF EXISTS Inventory_2D_Year_State;
    SELECT
        fs.Year,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Year_State
    FROM Inventory_2D_Year_Quarter_State fs
    GROUP BY
        fs.Year,
        fs.State;
    -- 9. Time(Quarter) + Location(State)
    DROP TABLE IF EXISTS Inventory_2D_Quarter_State;
    SELECT
        fs.Quarter,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Quarter_State
    FROM Inventory_2D_Year_Quarter_State fs
    GROUP BY
        fs.Quarter,
        fs.State;
    -- 10. Time(Month) + Location(State)
    DROP TABLE IF EXISTS Inventory_2D_Month_State;
    SELECT
        fs.Month,
        fs.State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_2D_Month_State
    FROM Inventory_2D_Year_Quarter_Month_State fs
    GROUP BY
        fs.Month,
        fs.State;
        

END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
