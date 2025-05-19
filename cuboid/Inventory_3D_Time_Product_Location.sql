USE OLAP
GO

-- 1. Time + Product + Location
IF OBJECT_ID('Inventory_3D_Time_Product_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Time_Product_Location;
CREATE TABLE Inventory_3D_Time_Product_Location (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Location_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Time_Product_Location (
    Year, 
    Quarter, 
    Month,
    Product_Key, 
    Description,
    Location_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_4D_Time_Product_Store_Location fi  
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City;


-- 2. Time(Year) + Product + Location
IF OBJECT_ID('Inventory_3D_Year_Product_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Year_Product_Location;
CREATE TABLE Inventory_3D_Year_Product_Location (
    Year INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Location_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Year_Product_Location (
    Year,
    Product_Key, 
    Description,
    Location_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City;
-- 3. Time(Quarter) + Product + Location
IF OBJECT_ID('Inventory_3D_Quarter_Product_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Quarter_Product_Location;
CREATE TABLE Inventory_3D_Quarter_Product_Location (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Location_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Quarter_Product_Location (
    Year,
    Quarter,
    Product_Key, 
    Description,
    Location_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City;
-- 4. Time(Month) + Product + Location
IF OBJECT_ID('Inventory_3D_Month_Product_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Month_Product_Location;
CREATE TABLE Inventory_3D_Month_Product_Location (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Location_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Month_Product_Location (
    Year, 
    Quarter, 
    Month,
    Product_Key, 
    Description,
    Location_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City;
-- 5. Time(Year, Quarter) + Product + Location
IF OBJECT_ID('Inventory_3D_Year_Product_Location', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Year_Product_Location;
CREATE TABLE Inventory_3D_Year_Product_Location (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Location_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Year_Product_Location (
    Year, 
    Quarter,
    Product_Key, 
    Description,
    Location_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.Location_Key, 
    fi.State, 
    fi.City;

-- 6. Time + Product + State
IF OBJECT_ID('Inventory_3D_Time_Product_State', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Time_Product_State;
CREATE TABLE Inventory_3D_Time_Product_State (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Time_Product_State (
    Year, 
    Quarter, 
    Month,
    Product_Key, 
    Description,
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City;
-- 7. Time(Year) + Product + State  
IF OBJECT_ID('Inventory_3D_Year_Product_State', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Year_Product_State;
CREATE TABLE Inventory_3D_Year_Product_State (  
    Year INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Year_Product_State (
    Year,
    Product_Key, 
    Description,
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City;
-- 8. Time(Quarter) + Product + State
IF OBJECT_ID('Inventory_3D_Quarter_Product_State', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Quarter_Product_State;
CREATE TABLE Inventory_3D_Quarter_Product_State (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Quarter_Product_State (
    Year,
    Quarter,
    Product_Key, 
    Description,
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City;
-- 9. Time(Month) + Product + State
IF OBJECT_ID('Inventory_3D_Month_Product_State', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Month_Product_State;
CREATE TABLE Inventory_3D_Month_Product_State (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Month_Product_State (
    Year, 
    Quarter, 
    Month,
    Product_Key, 
    Description,
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Month,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City;
-- 10. Time(Year, Quarter) + Product + State
IF OBJECT_ID('Inventory_3D_Year_Quarter_Product_State', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Year_Quarter_Product_State;
CREATE TABLE Inventory_3D_Year_Quarter_Product_State (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Year_Quarter_Product_State (
    Year, 
    Quarter,
    Product_Key, 
    Description,
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)
SELECT 
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Location fi
GROUP BY
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.State, 
    fi.City;
