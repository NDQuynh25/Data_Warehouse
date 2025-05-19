USE OLAP
GO

CREATE OR ALTER PROCEDURE Generate_Sales_Aggregation_Tables
AS
BEGIN
    -- 1. Time(Year, Quarter, Month) + Product + Customer(Customer_Key)
    -- 2. Time(Year, Quarter) + Product + Customer(Customer_Key)
    -- 3. Time(Year) + Product + Customer(Customer_Key)
    -- 4. Time(Quarter) + Product + Customer(Customer_Key)
    -- 5. Time(Month) + Product + Customer(Customer_Key)

    -- 6. Time(Year, Quarter, Month) + Product + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Month_Product_CustomerType;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Month_Product_CustomerType
    FROM Sales_4D_Year_Quarter_Month_Product_CustomerType_State fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type;

    -- 7. Time(Year, Quarter) + Product + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_3D_Year_Quarter_Product_CustomerType;
    SELECT
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Quarter_Product_CustomerType
    FROM Sales_3D_Year_Quarter_Month_Product_CustomerType fs
    GROUP BY
        fs.Year,
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type;

    -- 8. Time(Year) + Product + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_3D_Year_Product_CustomerType;
    SELECT
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Year_Product_CustomerType
    FROM Sales_3D_Year_Quarter_Month_Product_CustomerType fs -- sửa nguồn
    GROUP BY
        fs.Year,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type;

    -- 9. Time(Quarter) + Product + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_3D_Quarter_Product_CustomerType;
    SELECT
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Quarter_Product_CustomerType
    FROM Sales_3D_Year_Quarter_Month_Product_CustomerType fs -- sửa nguồn
    GROUP BY
        fs.Quarter,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type;

    -- 10. Time(Month) + Product + Customer(Customer_Type)
    DROP TABLE IF EXISTS Sales_3D_Month_Product_CustomerType;
    SELECT
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type,
        SUM(fs.Quantity_Sold) AS Quantity_Sold,
        SUM(fs.Revenue) AS Revenue
    INTO Sales_3D_Month_Product_CustomerType
    FROM Sales_3D_Year_Quarter_Month_Product_CustomerType fs -- sửa nguồn
    GROUP BY
        fs.Month,
        fs.Product_Key,
        fs.Description,
        fs.Customer_Type;
    
END;
GO
EXEC Generate_Sales_Aggregation_Tables;
