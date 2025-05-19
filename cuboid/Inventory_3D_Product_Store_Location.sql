USE OLAP
GO

-- 1. Product + Store + Location
IF OBJECT_ID('Inventory_3D_Product_Store_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Product_Store_Location;
CREATE TABLE Inventory_3D_Product_Store_Location (
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT,
    Export_Quantity INT
);
INSERT INTO Inventory_3D_Product_Store_Location (
    Product_Key, 
    Description,
    Store_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Product_Key,
    fs.Description,
    fs.Store_Key,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_4D_Time_Product_Store_Location fs
GROUP BY
    fs.Product_Key,
    fs.Description,
    fs.Store_Key,
    fs.State,
    fs.City;

-- 2. Product + Store + State
IF OBJECT_ID('Inventory_3D_Product_Store_State', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Product_Store_State;
CREATE TABLE Inventory_3D_Product_Store_State (
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    Import_Quantity INT,
    Export_Quantity INT
);
INSERT INTO Inventory_3D_Product_Store_State (
    Product_Key, 
    Description,
    Store_Key, 
    State,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Product_Key,
    fs.Description,
    fs.Store_Key,
    fs.State,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Product_Store_Location fs
GROUP BY
    fs.Product_Key,
    fs.Description,
    fs.Store_Key,
    fs.State;
