USE OLAP
GO
IF OBJECT_ID('Inventory_2D_Time_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Time_Store;
CREATE TABLE Inventory_2D_Time_Store (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Time_Store (
    Year, 
    Quarter, 
    Month,
    Store_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.Store_Key,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Store fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.Store_Key,
    fs.State,
    fs.City;
-- 2. Time(Year) + Store
IF OBJECT_ID('Inventory_2D_Year_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_Store;
CREATE TABLE Inventory_2D_Year_Store (
    Year INT NOT NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Year_Store (
    Year, 
    Store_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Store_Key,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Store fs
GROUP BY
    fs.Year,
    fs.Store_Key,
    fs.State,
    fs.City;
-- 3. Time(Quarter) + Store
IF OBJECT_ID('Inventory_2D_Quarter_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Quarter_Store;
CREATE TABLE Inventory_2D_Quarter_Store (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Quarter_Store (
    Year, 
    Quarter, 
    Store_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Store_Key,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Store fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Store_Key,
    fs.State,
    fs.City;
-- 4. Time(Month) + Store
IF OBJECT_ID('Inventory_2D_Month_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Month_Store;
CREATE TABLE Inventory_2D_Month_Store (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Month_Store (
    Year, 
    Quarter, 
    Month,
    Store_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.Store_Key,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Store fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.Store_Key,
    fs.State,
    fs.City;

-- 5. Time(Year, Quarter) + Store
IF OBJECT_ID('Inventory_2D_Year_Quarter_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_Quarter_Store;
CREATE TABLE Inventory_2D_Year_Quarter_Store (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Year_Quarter_Store (
    Year, 
    Quarter, 
    Store_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Store_Key,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Store fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Store_Key,
    fs.State,
    fs.City;
