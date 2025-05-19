USE OLAP;
GO

-- Tạo bảng Inventory_Source_Data và insert dữ liệu
IF OBJECT_ID('Inventory_Source_Data', 'U') IS NOT NULL
    DROP TABLE Inventory_Source_Data;

CREATE TABLE Inventory_Source_Data (
    Time_Key INT NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Store_Key NVARCHAR(100) NULL,
    Location_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
GO
INSERT INTO Inventory_Source_Data 
SELECT
    fs.Time_Key, dt.Year, dt.Quarter, dt.Month,
    dp.Product_Key, dp.Description,
    ds.Store_Key,
    ds.Location_Key, dl.State, dl.City,
    SUM(fs.Import_Quantity), SUM(fs.Export_Quantity)
FROM DW.dbo.Fact_Inventory fs
JOIN DW.dbo.Dim_Product dp ON fs.Product_Key = dp.Product_Key
JOIN DW.dbo.Dim_Store ds ON fs.Store_Key = ds.Store_Key
JOIN DW.dbo.Dim_Location dl ON ds.Location_Key = dl.Location_Key
JOIN DW.dbo.Dim_Time dt ON fs.Time_Key = dt.Time_Key
GROUP BY
    fs.Time_Key, dt.Year, dt.Quarter, dt.Month,
    dp.Product_Key, dp.Description,
    ds.Store_Key,
    ds.Location_Key, dl.State, dl.City;
GO
-- Tạo procedure
CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Product + Store + Location(City)
    IF OBJECT_ID('Inventory_4D_Year_Quarter_Month_Product_Store_City', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Year_Quarter_Month_Product_Store_City;
    SELECT
        Year, Quarter, Month,
        Product_Key, Description,
        Store_Key, 
        State, City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    
    INTO Inventory_4D_Year_Quarter_Month_Product_Store_City
    FROM Inventory_Source_Data
    GROUP BY
        Year, Quarter, Month,
        Product_Key, Description,
        Store_Key, 
        State, City;

    -- 2. Time(Year, Quarter) + Product + Store + Location(City)
    IF OBJECT_ID('Inventory_4D_Year_Quarter_Product_Store_City', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Year_Quarter_Product_Store_City;
    SELECT
        Year, Quarter,
        Product_Key, Description,
        Store_Key, 
        State, City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Year_Quarter_Product_Store_City
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_City
    GROUP BY
        Year, Quarter,
        Product_Key, Description,
        Store_Key, 
        State, City;

    -- 3. Time(Year) + Product + Store + Location(City)
    IF OBJECT_ID('Inventory_4D_Year_Product_Store_City', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Year_Product_Store_City;
    SELECT
        Year,
        Product_Key, Description,
        Store_Key, 
        State, City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Year_Product_Store_City
    FROM Inventory_4D_Year_Quarter_Product_Store_City
    GROUP BY
        Year,
        Product_Key, Description,
        Store_Key, 
        State, City;

    -- 4. Time(Quarter) + Product + Store + Location(City)
    IF OBJECT_ID('Inventory_4D_Quarter_Product_Store_City', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Quarter_Product_Store_City;
    SELECT
        Quarter,
        Product_Key, Description,
        Store_Key, 
        State, City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Quarter_Product_Store_City
    FROM Inventory_4D_Year_Quarter_Product_Store_City
    GROUP BY
        Quarter,
        Product_Key, Description,
        Store_Key, 
        State, City;

    -- 5. Time(Month) + Product + Store + Location(City)
    IF OBJECT_ID('Inventory_4D_Month_Product_Store_City', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Month_Product_Store_City;
    SELECT
        Month,
        Product_Key, Description,
        Store_Key,
        State, City,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Month_Product_Store_City
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_City
    GROUP BY
        Month,
        Product_Key, Description,
        Store_Key,
        State, City;
    
    -- 6. Time(Year_Quarter_Month) + Product + Store + Location(State)
    IF OBJECT_ID('Inventory_4D_Year_Quarter_Month_Product_Store_State', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Year_Quarter_Month_Product_Store_State;
    SELECT
        Year, Quarter, Month,
        Product_Key, Description,
        Store_Key,
        State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Year_Quarter_Month_Product_Store_State
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_City
    GROUP BY
        Year, Quarter, Month,
        Product_Key, Description,
        Store_Key,
        State;

    -- 7. Time(Year_Quarter) + Product + Store + Location(State)
    IF OBJECT_ID('Inventory_4D_Year_Quarter_Product_Store_State', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Year_Quarter_Product_Store_State;
    SELECT
        Year, Quarter,
        Product_Key, Description,
        Store_Key,
        State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Year_Quarter_Product_Store_State
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_State
    GROUP BY
        Year, Quarter,
        Product_Key, Description,
        Store_Key,
        State;

    -- 8. Time(Year) + Product + Store + Location(State)
    IF OBJECT_ID('Inventory_4D_Year_Product_Store_State', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Year_Product_Store_State;
    SELECT
        Year,
        Product_Key, Description,
        Store_Key,
        State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Year_Product_Store_State
    FROM Inventory_4D_Year_Quarter_Product_Store_State
    GROUP BY
        Year,
        Product_Key, Description,
        Store_Key,
        State;

    -- 9. Time(Quarter) + Product + Store + Location(State)
    IF OBJECT_ID('Inventory_4D_Quarter_Product_Store_State', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Quarter_Product_Store_State;
    SELECT
        Quarter,
        Product_Key, Description,
        Store_Key,
        State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Quarter_Product_Store_State
    FROM Inventory_4D_Year_Quarter_Product_Store_State
    GROUP BY
        Quarter,
        Product_Key, Description,
        Store_Key,
        State;

    -- 10. Time(Month) + Product + Store + Location(State)
    IF OBJECT_ID('Inventory_4D_Month_Product_Store_State', 'U') IS NOT NULL
        DROP TABLE Inventory_4D_Month_Product_Store_State;
    SELECT
        Month,
        Product_Key, Description,
        Store_Key,
        State,
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_4D_Month_Product_Store_State
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_State
    GROUP BY
        Month,
        Product_Key, Description,
        Store_Key,
        State;



   

        
    
END;
GO

-- Gọi procedure
EXEC Generate_Inventory_Aggregation_Tables;
