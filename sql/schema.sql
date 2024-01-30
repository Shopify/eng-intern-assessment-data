-- Table: Categories
CREATE TABLE
Categories (
    Category_Id INT PRIMARY KEY,
    Category_Name VARCHAR(255)
);

-- Table: Products
CREATE TABLE
Products (
    Product_Id INT PRIMARY KEY,
    Product_Name VARCHAR(255),
    Description TEXT,
    Price DECIMAL(10, 2),
    Category_Id INT,
    FOREIGN KEY (Category_Id) REFERENCES Categories (Category_Id)
);

-- Table: Users
CREATE TABLE
Users (
    User_Id INT PRIMARY KEY,
    Username VARCHAR(255),
    Email VARCHAR(255),
    Password VARCHAR(255),
    Address VARCHAR(255),
    Phone_Number VARCHAR(20)
);

-- Table: Orders
CREATE TABLE
Orders (
    Order_Id INT PRIMARY KEY,
    User_Id INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    FOREIGN KEY (User_Id) REFERENCES Users (User_Id)
);

-- Table: Order_Items
CREATE TABLE
Order_Items (
    Order_Item_Id INT PRIMARY KEY,
    Order_Id INT,
    Product_Id INT,
    Quantity INT,
    Unit_Price DECIMAL(10, 2),
    FOREIGN KEY (Order_Id) REFERENCES Orders (Order_Id),
    FOREIGN KEY (Product_Id) REFERENCES Products (Product_Id)
);

-- Table: Reviews
CREATE TABLE
Reviews (
    Review_Id INT PRIMARY KEY,
    User_Id INT,
    Product_Id INT,
    Rating INT,
    Review_Text TEXT,
    Review_Date DATE,
    FOREIGN KEY (User_Id) REFERENCES Users (User_Id),
    FOREIGN KEY (Product_Id) REFERENCES Products (Product_Id)
);

-- Table: Cart
CREATE TABLE
Cart (
    Cart_Id INT PRIMARY KEY,
    User_Id INT,
    FOREIGN KEY (User_Id) REFERENCES Users (User_Id)
);

-- Table: Cart_Items
CREATE TABLE
Cart_Items (
    Cart_Item_Id INT PRIMARY KEY,
    Cart_Id INT,
    Product_Id INT,
    Quantity INT,
    FOREIGN KEY (Cart_Id) REFERENCES Cart (Cart_Id),
    FOREIGN KEY (Product_Id) REFERENCES Products (Product_Id)
);

-- Table: Payments
CREATE TABLE
Payments (
    Payment_Id INT PRIMARY KEY,
    Order_Id INT,
    Payment_Date DATE,
    Payment_Method VARCHAR(255),
    Amount DECIMAL(10, 2),
    FOREIGN KEY (Order_Id) REFERENCES Orders (Order_Id)
);

-- Table: Shipping
CREATE TABLE
Shipping (
    Shipping_Id INT PRIMARY KEY,
    Order_Id INT,
    Shipping_Date DATE,
    Shipping_Address VARCHAR(255),
    Tracking_Number VARCHAR(255),
    FOREIGN KEY (Order_Id) REFERENCES Orders (Order_Id)
);
