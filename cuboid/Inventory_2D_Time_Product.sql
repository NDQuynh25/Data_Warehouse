USE OLAP
GO

-- 1. Time + Product
IF OBJECT_ID('Inventory_2D_Time_Product', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Time_Product;
CREATE TABLE Inventory_2D_Time_Product (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Import_Quantity INT,
    Export_Quantity INT
);
INSERT INTO Inventory_2D_Time_Product (
    Year, 
    Quarter, 
    Month,
    Product_Key, 
    Description,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.Product_Key,
    fs.Description,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Store fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.Product_Key,
    fs.Description;

-- 2. Time(Year) + Product
IF OBJECT_ID('Inventory_2D_Year_Product', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_Product;
CREATE TABLE Inventory_2D_Year_Product (
    Year INT NOT NULL,
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Import_Quantity INT,
    Export_Quantity INT
);
INSERT INTO Inventory_2D_Year_Product (
    Year, 
    Product_Key, 
    Description,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Product_Key,
    fs.Description,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Product fs
GROUP BY
    fs.Year,
    fs.Product_Key,
    fs.Description;

-- 3. Time(Quarter) + Product
IF OBJECT_ID('Inventory_2D_Quarter_Product', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Quarter_Product;
CREATE TABLE Inventory_2D_Quarter_Product (
    Quarter INT NOT NULL,
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Import_Quantity INT,
    Export_Quantity INT
);
INSERT INTO Inventory_2D_Quarter_Product (
    Quarter, 
    Product_Key, 
    Description,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Quarter,
    fs.Product_Key,
    fs.Description,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Product fs
GROUP BY
    fs.Quarter,
    fs.Product_Key,
    fs.Description;
-- 4. Time(Month) + Product
IF OBJECT_ID('Inventory_2D_Month_Product', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Month_Product;
CREATE TABLE Inventory_2D_Month_Product (
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Import_Quantity INT,
    Export_Quantity INT
);
INSERT INTO Inventory_2D_Month_Product (
    Month, 
    Product_Key, 
    Description,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Month,
    fs.Product_Key,
    fs.Description,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Product fs
GROUP BY
    fs.Month,
    fs.Product_Key,
    fs.Description;
-- 5. Time(Year_Quarter) + Product
IF OBJECT_ID('Inventory_2D_Year_Quarter_Product', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_Quarter_Product;
CREATE TABLE Inventory_2D_Year_Quarter_Product (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Import_Quantity INT,
    Export_Quantity INT
);
INSERT INTO Inventory_2D_Year_Quarter_Product (
    Year, 
    Quarter, 
    Product_Key, 
    Description,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Product_Key,
    fs.Description,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Product fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Product_Key,
    fs.Description;
    
