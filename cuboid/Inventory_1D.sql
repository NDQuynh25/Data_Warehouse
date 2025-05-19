USE OLAP
GO

-- -- 1. Time
IF OBJECT_ID('Inventory_1D_Time', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Time;
CREATE TABLE Inventory_1D_Time (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Time (
    Year, 
    Quarter, 
    Month,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Month,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Product fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Month;
-- -- 2. Time(Year)
IF OBJECT_ID('Inventory_1D_Year', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Year;
CREATE TABLE Inventory_1D_Year (
    Year INT NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Year (
    Year, 
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_1D_Time fs
GROUP BY
    fs.Year;

-- -- 3. Time(Quarter)
IF OBJECT_ID('Inventory_1D_Quarter', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Quarter;
CREATE TABLE Inventory_1D_Quarter (
    Quarter INT NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Quarter (
    Quarter,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Quarter,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_1D_Time fs
GROUP BY
    fs.Quarter;

-- -- 4. Time(Month)
IF OBJECT_ID('Inventory_1D_Month', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Month;
CREATE TABLE Inventory_1D_Month (
    Month INT NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Month (
    Month, 
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Month,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_1D_Time fs
GROUP BY
    fs.Month;
-- -- 5. Time(Year_Quarter)
IF OBJECT_ID('Inventory_1D_Year_Quarter', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Year_Quarter;
CREATE TABLE Inventory_1D_Year_Quarter (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Year_Quarter (
    Year, 
    Quarter, 
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_1D_Time fs
GROUP BY
    fs.Year,
    fs.Quarter;

-- -- 6. Product
IF OBJECT_ID('Inventory_1D_Product', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Product;
CREATE TABLE Inventory_1D_Product (
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Product (
    Product_Key, 
    Description,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Product_Key,
    fs.Description,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Product fs
GROUP BY
    fs.Product_Key,
    fs.Description;

-- -- 7. Store
IF OBJECT_ID('Inventory_1D_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Store;
CREATE TABLE Inventory_1D_Store (
    Store_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Store (
    Store_Key, 
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Store_Key,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Store fs
GROUP BY
    fs.Store_Key;

-- -- 8. Location
IF OBJECT_ID('Inventory_1D_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_Location;
CREATE TABLE Inventory_1D_Location (
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_Location (
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Location fs
GROUP BY
    fs.State,
    fs.City;
    
-- -- 9. Location(State)
IF OBJECT_ID('Inventory_1D_State', 'U') IS NOT NULL
    DROP TABLE Inventory_1D_State;
CREATE TABLE Inventory_1D_State (
    State VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_1D_State (
    State, 
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.State,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_1D_Location fs
GROUP BY
    fs.State;
