


USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Inventory_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Product + Store
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Month_Product_Store
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key,
       
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Month_Product_Store
    FROM Inventory_4D_Year_Quarter_Month_Product_Store_City fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key;
     
    --- 2. Time(Year, Quarter) + Product + Store
    DROP TABLE IF EXISTS Inventory_3D_Year_Quarter_Product_Store;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key,
      
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Quarter_Product_Store
    FROM Inventory_3D_Year_Quarter_Month_Product_Store fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key;
      
    -- 3. Time(Year) + Product + Store
    DROP TABLE IF EXISTS Inventory_3D_Year_Product;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key,
      
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Year_Product_Store
    FROM Inventory_3D_Year_Quarter_Product_Store fs
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key;
     
    -- 4. Time(Quarter) + Product + Store
    DROP TABLE IF EXISTS Inventory_3D_Quarter_Product_Store;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key,
      
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Quarter_Product_Store
    FROM Inventory_3D_Year_Quarter_Product_Store fs
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key;
     
    -- 5. Time(Month) + Product + Store
    DROP TABLE IF EXISTS Inventory_3D_Month_Product_Store;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key,
        
        SUM(Import_Quantity) AS Import_Quantity,
        SUM(Export_Quantity) AS Export_Quantity
    INTO Inventory_3D_Month_Product_Store
    FROM Inventory_3D_Year_Quarter_Month_Product_Store fs
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Store_Key;
       


   

END;
GO
EXEC Generate_Inventory_Aggregation_Tables;
