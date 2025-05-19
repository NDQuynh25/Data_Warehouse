USE master;
GO

-- Nếu database DW tồn tại thì xóa đi
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DW')
BEGIN
    ALTER DATABASE DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DW;
END
GO

-- Tạo database mới
CREATE DATABASE DW;
GO

USE DW;
GO

-- Tạo bảng Dim_Location
CREATE TABLE Dim_Location (
    Location_Key NVARCHAR(100) PRIMARY KEY,
    State VARCHAR(100),
    City VARCHAR(100)

    ``` State -> City ```
);
GO

-- Tạo bảng Dim_Store
CREATE TABLE Dim_Store (
    Store_Key NVARCHAR(100) PRIMARY KEY,
    Location_Key NVARCHAR(100) NOT NULL
);
GO

ALTER TABLE Dim_Store
ADD CONSTRAINT FK_DimStore_Location FOREIGN KEY (Location_Key) REFERENCES Dim_Location(Location_Key);
GO

-- Tạo bảng Dim_Time
CREATE TABLE Dim_Time (
    Time_Key NVARCHAR(100) PRIMARY KEY,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL
    ``` Year -> Quarter -> Month ```
);
GO

-- Tạo bảng Dim_Product
CREATE TABLE Dim_Product (
    Product_Key NVARCHAR(100) PRIMARY KEY,
    Description VARCHAR(255),
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Price DECIMAL(10,2)


);
GO

-- Tạo bảng Dim_Customer
CREATE TABLE Dim_Customer (
    Customer_Key NVARCHAR(100) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Customer_Type VARCHAR(50),
    Location_Key NVARCHAR(100) NOT NULL

   ``` Customer_Type -> Customer_Name ```
);
GO

ALTER TABLE Dim_Customer
ADD CONSTRAINT FK_DimCustomer_Location FOREIGN KEY (Location_Key) REFERENCES Dim_Location(Location_Key);
GO

-- Tạo bảng Fact_Sales
CREATE TABLE Fact_Sales (
    Time_Key NVARCHAR(100) NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Customer_Key NVARCHAR(100) NOT NULL,
    Quantity_Sold INT,
    Revenue DECIMAL(18,2),
    PRIMARY KEY (Time_Key, Product_Key, Customer_Key)
);
GO

ALTER TABLE Fact_Sales
ADD CONSTRAINT FK_FactSales_Time FOREIGN KEY (Time_Key) REFERENCES Dim_Time(Time_Key);
GO

ALTER TABLE Fact_Sales
ADD CONSTRAINT FK_FactSales_Product FOREIGN KEY (Product_Key) REFERENCES Dim_Product(Product_Key);
GO

ALTER TABLE Fact_Sales
ADD CONSTRAINT FK_FactSales_Customer FOREIGN KEY (Customer_Key) REFERENCES Dim_Customer(Customer_Key);
GO

-- Tạo bảng Fact_Inventory
CREATE TABLE Fact_Inventory (
    Time_Key NVARCHAR(100) NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Store_Key NVARCHAR(100) NOT NULL,
    Import_Quantity INT,
    Export_Quantity INT,
    PRIMARY KEY (Time_Key, Product_Key, Store_Key)
);
GO

ALTER TABLE Fact_Inventory
ADD CONSTRAINT FK_FactInventory_Time FOREIGN KEY (Time_Key) REFERENCES Dim_Time(Time_Key);
GO

ALTER TABLE Fact_Inventory
ADD CONSTRAINT FK_FactInventory_Product FOREIGN KEY (Product_Key) REFERENCES Dim_Product(Product_Key);
GO

ALTER TABLE Fact_Inventory
ADD CONSTRAINT FK_FactInventory_Store FOREIGN KEY (Store_Key) REFERENCES Dim_Store(Store_Key);
GO
