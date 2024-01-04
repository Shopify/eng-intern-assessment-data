-- Table: Categories
CREATE TABLE Categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(255)
);

-- Table: Products
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(255),
  description TEXT,
  price DECIMAL(10, 2),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Table: Users
CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  username VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255),
  address VARCHAR(255),
  phone_number VARCHAR(20)
);

-- Table: Orders
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Table: Order_Items
CREATE TABLE Order_Items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10, 2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Table: Reviews
CREATE TABLE Reviews (
  review_id INT PRIMARY KEY,
  user_id INT,
  product_id INT,
  rating INT,
  review_text TEXT,
  review_date DATE,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Table: Cart
CREATE TABLE Cart (
  cart_id INT PRIMARY KEY,
  user_id INT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Table: Cart_Items
CREATE TABLE Cart_Items (
  cart_item_id INT PRIMARY KEY,
  cart_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Table: Payments
CREATE TABLE Payments (
  payment_id INT PRIMARY KEY,
  order_id INT,
  payment_date DATE,
  payment_method VARCHAR(255),
  amount DECIMAL(10, 2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Table: Shipping
CREATE TABLE Shipping (
  shipping_id INT PRIMARY KEY,
  order_id INT,
  shipping_date DATE,
  shipping_address VARCHAR(255),
  tracking_number VARCHAR(255),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
