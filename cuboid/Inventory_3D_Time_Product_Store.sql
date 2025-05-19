USE OLAP
GO

-- 1. Time + Product + Store
IF OBJECT_ID('Inventory_3D_Time_Product_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Time_Product_Store;
CREATE TABLE Inventory_3D_Time_Product_Store (
    Year INT,
    Quarter INT,
    Month INT,
    Product_Key NVARCHAR(100) NULL,
    Description NVARCHAR(255) NULL,
    Store_Key NVARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT,
    Export_Quantity INT,
);
INSERT INTO Inventory_3D_Time_Product_Store (
    Year, 
    Quarter, 
    Month,
    Product_Key, 
    Description,
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
    fs.Product_Key,
    fs.Description,
    fs.Store_Key,
    fs.State,
    fs.City,
    SUM(fs.Import_Quantity) AS Import_Quantity,
    SUM(fs.Export_Quantity) AS Export_Quantity
FROM Inventory_4D_Time_Product_Store_Location fs
GROUP BY
    fs.Year,
    fs.Quarter,
    fs.Month,
    fs.Product_Key,
    fs.Description,
    fs.Store_Key,
    fs.State,
    fs.City;

-- 2. Time(Year) + Product + Store 

IF OBJECT_ID('Inventory_3D_Year_Product_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Year_Product_Store;

CREATE TABLE Inventory_3D_Year_Product_Store (
    Year INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Store_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);

INSERT INTO Inventory_3D_Year_Product_Store (
    Year,
    Product_Key, 
    Description,
    Store_Key, 
    State, 
    City,
    Import_Quantity, 
    Export_Quantity
)

SELECT 
    fi.Year,
    fi.Product_Key, 
    fi.Description,
    fi.Store_Key, 
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Store fi
GROUP BY 
    fi.Year,
    fi.Product_Key, 
    fi.Description,
    fi.Store_Key, 
    fi.State, 
    fi.City;

-- 3. Time(Year_Quarter) + Product + Store
IF OBJECT_ID('Inventory_3D_Year_Quarter_Product_Store', 'U') IS NOT NULL
    DROP TABLE Inventory_3D_Year_Quarter_Product_Store;
CREATE TABLE Inventory_3D_Year_Quarter_Product_Store (
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Store_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Import_Quantity INT DEFAULT 0,
    Export_Quantity INT DEFAULT 0
);
INSERT INTO Inventory_3D_Year_Quarter_Product_Store (
    Year, 
    Quarter,
    Product_Key, 
    Description,
    Store_Key, 
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
    fi.Store_Key, 
    fi.State, 
    fi.City,
    SUM(fi.Import_Quantity) AS Import_Quantity,
    SUM(fi.Export_Quantity) AS Export_Quantity
FROM Inventory_3D_Time_Product_Store fi
GROUP BY 
    fi.Year,
    fi.Quarter,
    fi.Product_Key, 
    fi.Description,
    fi.Store_Key, 
    fi.State, 
    fi.City;
