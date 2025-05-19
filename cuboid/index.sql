USE DW;
GO


-- 1. DROP INDEXES IF EXISTS


-- Fact_Sales
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Sales_TimeProductCustomer')
    DROP INDEX IX_Fact_Sales_TimeProductCustomer ON Fact_Sales;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Sales_TimeKey')
    DROP INDEX IX_Fact_Sales_TimeKey ON Fact_Sales;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Sales_ProductKey')
    DROP INDEX IX_Fact_Sales_ProductKey ON Fact_Sales;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Sales_CustomerKey')
    DROP INDEX IX_Fact_Sales_CustomerKey ON Fact_Sales;

-- Fact_Inventory
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Inventory_TimeProductStore')
    DROP INDEX IX_Fact_Inventory_TimeProductStore ON Fact_Inventory;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Inventory_TimeKey')
    DROP INDEX IX_Fact_Inventory_TimeKey ON Fact_Inventory;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Inventory_ProductKey')
    DROP INDEX IX_Fact_Inventory_ProductKey ON Fact_Inventory;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Fact_Inventory_StoreKey')
    DROP INDEX IX_Fact_Inventory_StoreKey ON Fact_Inventory;

-- Dim_Time
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_Dim_Time')
    DROP INDEX PK_Dim_Time ON Dim_Time;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Dim_Time_YearQuarterMonth')
    DROP INDEX IX_Dim_Time_YearQuarterMonth ON Dim_Time;

-- Dim_Product
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_Dim_Product')
    DROP INDEX PK_Dim_Product ON Dim_Product;

-- Dim_Customer
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_Dim_Customer')
    DROP INDEX PK_Dim_Customer ON Dim_Customer;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Dim_Customer_Location')
    DROP INDEX IX_Dim_Customer_Location ON Dim_Customer;

-- Dim_Store
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_Dim_Store')
    DROP INDEX PK_Dim_Store ON Dim_Store;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Dim_Store_Location')
    DROP INDEX IX_Dim_Store_Location ON Dim_Store;

-- Dim_Location
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'PK_Dim_Location')
    DROP INDEX PK_Dim_Location ON Dim_Location;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Dim_Location_State')
    DROP INDEX IX_Dim_Location_State ON Dim_Location;

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Dim_Location_City')
    DROP INDEX IX_Dim_Location_City ON Dim_Location;


-- 2. CREATE INDEXES AGAIN


-- Fact_Sales
CREATE NONCLUSTERED INDEX IX_Fact_Sales_TimeProductCustomer 
ON Fact_Sales(Time_Key, Product_Key, Customer_Key);

CREATE INDEX IX_Fact_Sales_TimeKey ON Fact_Sales(Time_Key);
CREATE INDEX IX_Fact_Sales_ProductKey ON Fact_Sales(Product_Key);
CREATE INDEX IX_Fact_Sales_CustomerKey ON Fact_Sales(Customer_Key);

-- Fact_Inventory
CREATE NONCLUSTERED INDEX IX_Fact_Inventory_TimeProductStore 
ON Fact_Inventory(Time_Key, Product_Key, Store_Key);

CREATE INDEX IX_Fact_Inventory_TimeKey ON Fact_Inventory(Time_Key);
CREATE INDEX IX_Fact_Inventory_ProductKey ON Fact_Inventory(Product_Key);
CREATE INDEX IX_Fact_Inventory_StoreKey ON Fact_Inventory(Store_Key);

-- Dim_Time
CREATE UNIQUE NONCLUSTERED INDEX PK_Dim_Time ON Dim_Time(Time_Key);
CREATE NONCLUSTERED INDEX IX_Dim_Time_YearQuarterMonth ON Dim_Time(Year, Quarter, Month);

-- Dim_Product
CREATE UNIQUE NONCLUSTERED INDEX PK_Dim_Product ON Dim_Product(Product_Key);

-- Dim_Customer
CREATE UNIQUE NONCLUSTERED INDEX PK_Dim_Customer ON Dim_Customer(Customer_Key);
CREATE NONCLUSTERED INDEX IX_Dim_Customer_Location ON Dim_Customer(Location_Key);

-- Dim_Store
CREATE UNIQUE NONCLUSTERED INDEX PK_Dim_Store ON Dim_Store(Store_Key);
CREATE NONCLUSTERED INDEX IX_Dim_Store_Location ON Dim_Store(Location_Key);

-- Dim_Location
CREATE UNIQUE NONCLUSTERED INDEX PK_Dim_Location ON Dim_Location(Location_Key);
CREATE NONCLUSTERED INDEX IX_Dim_Location_State ON Dim_Location(State);
CREATE NONCLUSTERED INDEX IX_Dim_Location_City ON Dim_Location(City);
