USE OLAP;
GO

-- Tạo bảng Sales_Source_Data và insert dữ liệu
IF OBJECT_ID('Sales_Source_Data', 'U') IS NOT NULL
    DROP TABLE Sales_Source_Data;

CREATE TABLE Sales_Source_Data (
    Time_Key INT NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Product_Key NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Customer_Key NVARCHAR(100) NOT NULL,
    Customer_Name NVARCHAR(255) NULL,
    Customer_Type NVARCHAR(100) NULL,
    Location_Key NVARCHAR(100) NOT NULL,
    State VARCHAR(100) NULL,
    City VARCHAR(100) NULL,
    Quantity_Sold INT,
    Revenue DECIMAL(18,2)
);
GO
INSERT INTO Sales_Source_Data
SELECT
    fs.Time_Key, dt.Year, dt.Quarter, dt.Month,
    dp.Product_Key, dp.Description,
    dc.Customer_Key, dc.Customer_Name, dc.Customer_Type,
    dc.Location_Key, dl.State, dl.City,
    SUM(fs.Quantity_Sold), SUM(fs.Revenue)
FROM DW.dbo.Fact_Sales fs
JOIN DW.dbo.Dim_Product dp ON fs.Product_Key = dp.Product_Key
JOIN DW.dbo.Dim_Customer dc ON fs.Customer_Key = dc.Customer_Key
JOIN DW.dbo.Dim_Location dl ON dc.Location_Key = dl.Location_Key
JOIN DW.dbo.Dim_Time dt ON fs.Time_Key = dt.Time_Key
GROUP BY
    fs.Time_Key, dt.Year, dt.Quarter, dt.Month,
    dp.Product_Key, dp.Description,
    dc.Customer_Key, dc.Customer_Name, dc.Customer_Type,
    dc.Location_Key, dl.State, dl.City;

-- ⚠️ TÁCH BATCH TRƯỚC CREATE PROCEDURE
GO

-- Tạo procedure
CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Bảng tổng hợp theo Time(Year, Quarter, Month) + Product + Customer(CustomerKey) + Location(City)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Month_Product_CustomerKey_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Month_Product_CustomerKey_City;
    
    SELECT 
        Year,
        Quarter,
        Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Month_Product_CustomerKey_City
    FROM Sales_Source_Data
    GROUP BY 
        Year, Quarter, Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City;

    -- 2. Bảng tổng hợp theo Time(Year, Quarter) + Product + Customer(CustomerKey) + Location(City)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Product_CustomerKey_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Product_CustomerKey_City;
    SELECT
        Year,
        Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Product_CustomerKey_City
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerKey_City
    GROUP BY 
        Year, Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City;

    -- 3. Bảng tổng hợp theo Time(Year) + Product + Customer(CustomerKey) + Location(City)
    IF OBJECT_ID('Sales_4D_Year_Product_CustomerKey_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Product_CustomerKey_City;
    SELECT
        Year,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Product_CustomerKey_City
    FROM Sales_4D_Year_Quarter_Product_CustomerKey_City
    GROUP BY 
        Year,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City;

    -- 4. Bảng tổng hợp theo Time(Quarter) + Product + Customer(CustomerKey) + Location(City)
    IF OBJECT_ID('Sales_4D_Quarter_Product_CustomerKey_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Quarter_Product_CustomerKey_City;
    SELECT
        Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Quarter_Product_CustomerKey_City
    FROM Sales_4D_Year_Quarter_Product_CustomerKey_City
    GROUP BY 
        Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City;

    -- 5. Bảng tổng hợp theo Time(Month) + Product + Customer(CustomerKey) + Location(City)
    IF OBJECT_ID('Sales_4D_Month_Product_CustomerKey_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Month_Product_CustomerKey_City;
    SELECT
        Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Month_Product_CustomerKey_City
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerKey_City
    GROUP BY 
        Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State, City;

    -- 6. Bảng tổng hợp theo Time(Year, Quarter, Month) + Product + Customer(CustomerKey) + Location(State)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Month_Product_CustomerKey_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Month_Product_CustomerKey_State;
    SELECT
        Year,
        Quarter,
        Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Month_Product_CustomerKey_State
    FROM Sales_Source_Data
    GROUP BY 
        Year, Quarter, Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State;
    -- 7. Bảng tổng hợp theo Time(Year, Quarter) + Product + Customer(CustomerKey) + Location(State)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Product_CustomerKey_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Product_CustomerKey_State;
    SELECT
        Year,
        Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Product_CustomerKey_State
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerKey_State
    GROUP BY 
        Year, Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State;
    -- 8. Bảng tổng hợp theo Time(Year) + Product + Customer(CustomerKey) + Location(State)
    IF OBJECT_ID('Sales_4D_Year_Product_CustomerKey_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Product_CustomerKey_State;
    SELECT
        Year,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Product_CustomerKey_State
    FROM Sales_4D_Year_Quarter_Product_CustomerKey_State
    GROUP BY 
        Year,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State;
    -- 9. Bảng tổng hợp theo Time(Quarter) + Product + Customer(CustomerKey) + Location(State)
    IF OBJECT_ID('Sales_4D_Quarter_Product_CustomerKey_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Quarter_Product_CustomerKey_State;
    SELECT

        Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Quarter_Product_CustomerKey_State
    FROM Sales_4D_Year_Quarter_Product_CustomerKey_State
    GROUP BY 
        Quarter,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State;
    -- 10. Bảng tổng hợp theo Time(Month) + Product + Customer(CustomerKey) + Location(State)
    IF OBJECT_ID('Sales_4D_Month_Product_CustomerKey_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Month_Product_CustomerKey_State;
    SELECT

        Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Month_Product_CustomerKey_State
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerKey_State
    GROUP BY 
        Month,
        Product_Key, Description,
        Customer_Key, Customer_Name, Customer_Type,
        State;

    -- 11. Bảng tổng hợp theo Time(Year, Quarter, Month) + Product + Customer(CustomerType) + Location(State)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Month_Product_CustomerType_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Month_Product_CustomerType_State;  
    SELECT
        Year,
        Quarter,
        Month,
        Product_Key, Description,
        Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Month_Product_CustomerType_State
    FROM Sales_Source_Data
    GROUP BY 
        Year, Quarter, Month,
        Product_Key, Description,
        Customer_Type,
        State;
    -- 12. Bảng tổng hợp theo Time(Year, Quarter) + Product + Customer(CustomerType) + Location(State)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Product_CustomerType_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Product_CustomerType_State;
    SELECT

        Year,
        Quarter,
        Product_Key, Description,
        Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Product_CustomerType_State
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerType_State
    GROUP BY 
        Year, Quarter,
        Product_Key, Description,
        Customer_Type,
        State;
    -- 13. Bảng tổng hợp theo Time(Year) + Product + Customer(CustomerType) + Location(State)
    IF OBJECT_ID('Sales_4D_Year_Product_CustomerType_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Product_CustomerType_State;
    SELECT
        Year,
        Product_Key, Description,
        Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Product_CustomerType_State
    FROM Sales_4D_Year_Quarter_Product_CustomerType_State
    GROUP BY 
        Year,
        Product_Key, Description,
        Customer_Type,
        State;  
    -- 14. Bảng tổng hợp theo Time(Quarter) + Product + Customer(CustomerType) + Location(State)
    IF OBJECT_ID('Sales_4D_Quarter_Product_CustomerType_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Quarter_Product_CustomerType_State;
    SELECT
        Quarter,
        Product_Key, Description,
        Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Quarter_Product_CustomerType_State
    FROM Sales_4D_Year_Quarter_Product_CustomerType_State
    GROUP BY 
        Quarter,
        Product_Key, Description,
        Customer_Type,
        State;
    -- 15. Bảng tổng hợp theo Time(Month) + Product + Customer(CustomerType) + Location(State)
    IF OBJECT_ID('Sales_4D_Month_Product_CustomerType_State', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Month_Product_CustomerType_State;
    SELECT
        Month,
        Product_Key, Description,
        Customer_Type,
        State,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Month_Product_CustomerType_State
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerType_State
    GROUP BY 
        Month,
        Product_Key, Description,
        Customer_Type,
        State;

    -- 16. Bảng tổng hợp theo Time(Year, Quarter, Month) + Product + Customer(CustomerType) + Location(City)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Month_Product_CustomerType_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Month_Product_CustomerType_City;
    SELECT
        Year,
        Quarter,
        Month,
        Product_Key, Description,
        Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Month_Product_CustomerType_City
    FROM Sales_Source_Data
    GROUP BY 
        Year, Quarter, Month,
        Product_Key, Description,
        Customer_Type,
        State, City;
    -- 17. Bảng tổng hợp theo Time(Year, Quarter) + Product + Customer(CustomerType) + Location(City)
    IF OBJECT_ID('Sales_4D_Year_Quarter_Product_CustomerType_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Quarter_Product_CustomerType_City;
    SELECT
        Year,
        Quarter,
        Product_Key, Description,
        Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Quarter_Product_CustomerType_City
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerType_City
    GROUP BY 
        Year, Quarter,
        Product_Key, Description,
        Customer_Type,
        State, City;
    -- 18. Bảng tổng hợp theo Time(Year) + Product + Customer(CustomerType) + Location(City)
    IF OBJECT_ID('Sales_4D_Year_Product_CustomerType_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Year_Product_CustomerType_City;
    SELECT
        Year,
        Product_Key, Description,
        Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Year_Product_CustomerType_City
    FROM Sales_4D_Year_Quarter_Product_CustomerType_City
    GROUP BY 
        Year,
        Product_Key, Description,
        Customer_Type,
        State, City;
    -- 19. Bảng tổng hợp theo Time(Quarter) + Product + Customer(CustomerType) + Location(City)
    IF OBJECT_ID('Sales_4D_Quarter_Product_CustomerType_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Quarter_Product_CustomerType_City;
    SELECT
        Quarter,
        Product_Key, Description,
        Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Quarter_Product_CustomerType_City
    FROM Sales_4D_Year_Quarter_Product_CustomerType_City
    GROUP BY 
        Quarter,
        Product_Key, Description,
        Customer_Type,
        State, City;
    -- 20. Bảng tổng hợp theo Time(Month) + Product + Customer(CustomerType) + Location(City)
    IF OBJECT_ID('Sales_4D_Month_Product_CustomerType_City', 'U') IS NOT NULL
        DROP TABLE Sales_4D_Month_Product_CustomerType_City;
    SELECT
        Month,
        Product_Key, Description,
        Customer_Type,
        State, City,
        SUM(Quantity_Sold) AS Quantity_Sold,
        SUM(Revenue) AS Revenue
    INTO Sales_4D_Month_Product_CustomerType_City
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerType_City
    GROUP BY 
        Month,
        Product_Key, Description,
        Customer_Type,
        State, City;
        
    
END;
GO

-- Gọi procedure
EXEC Generate_Sales_Aggregation_Tables;
