
USE OLAP
GO

-- 1. Time + Location
IF OBJECT_ID('Inventory_2D_Time_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Time_Location;
CREATE TABLE Inventory_2D_Time_Location (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Time_Location (
    Year, 
    Quarter, 
    Month,
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Store fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.State,
    fs.City;

-- 2. Time(Year) + Location
IF OBJECT_ID('Inventory_2D_Year_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_Location;
CREATE TABLE Inventory_2D_Year_Location (
    Year INT NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Year_Location (
    Year, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Location fs
GROUP BY
    fs.Year,
    fs.State,
    fs.City;
-- 3. Time(Quarter) + Location
IF OBJECT_ID('Inventory_2D_Quarter_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Quarter_Location;
CREATE TABLE Inventory_2D_Quarter_Location (
    
    Quarter INT NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Quarter_Location (
    Quarter, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Quarter,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Location fs
GROUP BY
    fs.Quarter,
    fs.State,
    fs.City;
-- 4. Time(Month) + Location
IF OBJECT_ID('Inventory_2D_Month_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Month_Location;
CREATE TABLE Inventory_2D_Month_Location (
    Month INT NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Month_Location (
    Month,
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Month,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Location fs
GROUP BY
    fs.Month,
    fs.State,
    fs.City;



-- 5. Time(Year, Quarter) + Location
IF OBJECT_ID('Inventory_2D_Year_Quarter_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_Quarter_Location;
CREATE TABLE Inventory_2D_Year_Quarter_Location (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Year_Quarter_Location (
    Year, 
    Quarter, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Location fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.State,
    fs.City;

-- 6. Time + State
IF OBJECT_ID('Inventory_2D_Time_State', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Time_State;
CREATE TABLE Inventory_2D_Time_State (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    State VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Time_State (
    Year, 
    Quarter, 
    Month,
    State,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.State,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_Location fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.State;
-- 7. Time(Year) + State
IF OBJECT_ID('Inventory_2D_Year_State', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_State;
CREATE TABLE Inventory_2D_Year_State (
    Year INT NOT NULL,
    State VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Year_State (
    Year, 
    State,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.State,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_State fs
GROUP BY
    fs.Year,
    fs.State;
-- 8. Time(Quarter) + State
IF OBJECT_ID('Inventory_2D_Quarter_State', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Quarter_State;
CREATE TABLE Inventory_2D_Quarter_State (
    Quarter INT NOT NULL,
    State VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Quarter_State (
    Quarter, 
    State,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Quarter,
    fs.State,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_State fs
GROUP BY
    fs.Quarter,
    fs.State;
-- 9. Time(Month) + State
IF OBJECT_ID('Inventory_2D_Month_State', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Month_State;
CREATE TABLE Inventory_2D_Month_State (
    Month INT NOT NULL,
    State VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Month_State (
    Month,
    State,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Month,
    fs.State,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_State fs
GROUP BY
    fs.Month,
    fs.State;
-- 10. Time(Year, Quarter) + State
IF OBJECT_ID('Inventory_2D_Year_Quarter_State', 'U') IS NOT NULL
    DROP TABLE Inventory_2D_Year_Quarter_State;
CREATE TABLE Inventory_2D_Year_Quarter_State (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    State VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_2D_Year_Quarter_State (
    Year, 
    Quarter, 
    State,
    Import_Quantity, 
    Export_Quantity
)
SELECT
    fs.Year,
    fs.Quarter,
    fs.State,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_2D_Time_State fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.State;


