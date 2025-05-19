-- Tạo database
CREATE DATABASE IDB;
GO

USE IDB;
GO

-- 1. Bảng Representative_Office
CREATE TABLE Representative_Office (
    City_ID NVARCHAR(100) PRIMARY KEY,
    City_Name NVARCHAR(100) NOT NULL,
    Office_Address NVARCHAR(255) NOT NULL,
    State NVARCHAR(50) NOT NULL,
    Established_Date DATE NOT NULL
);
GO

-- 2. Bảng Store
CREATE TABLE Store (
    Store_ID NVARCHAR(100) PRIMARY KEY,
    City_ID NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Representative_Office(City_ID),
    Phone_Number NVARCHAR(20),
    Opening_Date DATE NOT NULL
);
GO

-- 3. Bảng Product
CREATE TABLE Product (
    Product_ID NVARCHAR(100) PRIMARY KEY,
    Description NVARCHAR(255) NOT NULL,
    Size NVARCHAR(50),
    Weight DECIMAL(10,2),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    First_Stock_Date DATE NOT NULL
);
GO

-- 4. Bảng Stored_Product (Quan hệ nhiều-nhiều giữa Store và Product)
CREATE TABLE Stored_Product (
    Store_ID NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Store(Store_ID),
    Product_ID NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Product(Product_ID),
    Stock_Quantity INT NOT NULL DEFAULT 0 CHECK (Stock_Quantity >= 0),
    Update_Time DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (Store_ID, Product_ID)
);
GO

-- 5. Bảng Customer
CREATE TABLE Customer (
    Customer_ID NVARCHAR(100) PRIMARY KEY,
    Customer_Name NVARCHAR(100) NOT NULL,
    City_ID NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Representative_Office(City_ID),
    First_Order_Date DATE
);
GO

-- 6. Bảng Order
CREATE TABLE [Order] (
    Order_ID NVARCHAR(100) PRIMARY KEY,
    Order_Date DATETIME NOT NULL DEFAULT GETDATE(),
    Customer_ID NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Customer(Customer_ID)
);
GO

-- 7. Bảng Ordered_Product (Quan hệ nhiều-nhiều giữa Order và Product)
CREATE TABLE Ordered_Product (
    Order_ID NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES [Order](Order_ID),
    Product_ID NVARCHAR(100) NOT NULL FOREIGN KEY REFERENCES Product(Product_ID),
    Ordered_Quantity INT NOT NULL CHECK (Ordered_Quantity > 0),
    Ordered_Price DECIMAL(10,2) NOT NULL CHECK (Ordered_Price > 0),
    Delivery_Time DATETIME, 
    PRIMARY KEY (Order_ID, Product_ID)
);
GO

-- 8. Bảng Postal_Customer (Kế thừa từ Customer)
CREATE TABLE Postal_Customer (
    Customer_ID NVARCHAR(100) PRIMARY KEY FOREIGN KEY REFERENCES Customer(Customer_ID),
    Postal_Address NVARCHAR(255) NOT NULL,
    Last_Postal_Order_Date DATETIME
);
GO

-- 9. Bảng Tourist_Customer (Kế thừa từ Customer)
CREATE TABLE Tourist_Customer (
    Customer_ID NVARCHAR(100) PRIMARY KEY FOREIGN KEY REFERENCES Customer(Customer_ID),
    Tour_Guide NVARCHAR(100),
    Last_Tour_Date DATETIME
);
GO

-- Tạo các chỉ mục để tối ưu hiệu suất
CREATE INDEX IX_Store_City ON Store(City_ID);
CREATE INDEX IX_Stored_Product_Product ON Stored_Product(Product_ID);
CREATE INDEX IX_Customer_City ON Customer(City_ID);
CREATE INDEX IX_Order_Customer ON [Order](Customer_ID);
CREATE INDEX IX_Ordered_Product_Product ON Ordered_Product(Product_ID);
GO