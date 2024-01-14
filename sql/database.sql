create database task;
use task;

CREATE TABLE Categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(255)
);

INSERT INTO Categories (category_id, category_name) VALUES (1, 'Electronics');
INSERT INTO Categories (category_id, category_name) VALUES (2, 'Books');
INSERT INTO Categories (category_id, category_name) VALUES (3, 'Clothing');
INSERT INTO Categories (category_id, category_name) VALUES (4, 'Home & Kitchen');
INSERT INTO Categories (category_id, category_name) VALUES (5, 'Toys & Games');
INSERT INTO Categories (category_id, category_name) VALUES (6, 'Beauty & Personal Care');
INSERT INTO Categories (category_id, category_name) VALUES (7, 'Health & Household');
INSERT INTO Categories (category_id, category_name) VALUES (8, 'Sports & Outdoors');
INSERT INTO Categories (category_id, category_name) VALUES (9, 'Automotive');
INSERT INTO Categories (category_id, category_name) VALUES (10, 'Tools & Home Improvement');
INSERT INTO Categories (category_id, category_name) VALUES (11, 'Grocery & Gourmet Food');
INSERT INTO Categories (category_id, category_name) VALUES (12, 'Pet Supplies');
INSERT INTO Categories (category_id, category_name) VALUES (13, 'Office Products');
INSERT INTO Categories (category_id, category_name) VALUES (14, 'Music');
INSERT INTO Categories (category_id, category_name) VALUES (15, 'Movies & TV');
INSERT INTO Categories (category_id, category_name) VALUES (16, 'Arts');
INSERT INTO Categories (category_id, category_name) VALUES (17, 'Industrial & Scientific');
INSERT INTO Categories (category_id, category_name) VALUES (18, 'Electronics Accessories');
INSERT INTO Categories (category_id, category_name) VALUES (19, 'Cell Phones & Accessories');
INSERT INTO Categories (category_id, category_name) VALUES (20, 'Video Games');
INSERT INTO Categories (category_id, category_name) VALUES (21, 'Computers');
INSERT INTO Categories (category_id, category_name) VALUES (22, 'Appliances');
INSERT INTO Categories (category_id, category_name) VALUES (23, 'Software');
INSERT INTO Categories (category_id, category_name) VALUES (24, 'Kindle Store');
INSERT INTO Categories (category_id, category_name) VALUES (25, 'Home Audio & Theater');
INSERT INTO Categories (category_id, category_name) VALUES (26, 'Camera & Photo');
INSERT INTO Categories (category_id, category_name) VALUES (27, 'Shoes');
INSERT INTO Categories (category_id, category_name) VALUES (28, 'Jewelry');
INSERT INTO Categories (category_id, category_name) VALUES (29, 'Handmade');
INSERT INTO Categories (category_id, category_name) VALUES (30, 'CDs & Vinyl');
INSERT INTO Categories (category_id, category_name) VALUES (31, 'Baby');
INSERT INTO Categories (category_id, category_name) VALUES (32, 'Collectibles & Fine Art');
INSERT INTO Categories (category_id, category_name) VALUES (33, 'Instrument Accessories');
INSERT INTO Categories (category_id, category_name) VALUES (34, 'Power & Hand Tools');
INSERT INTO Categories (category_id, category_name) VALUES (35, 'Outdoor Recreation');
INSERT INTO Categories (category_id, category_name) VALUES (36, 'Home Décor');
INSERT INTO Categories (category_id, category_name) VALUES (37, 'Kitchen & Dining');
INSERT INTO Categories (category_id, category_name) VALUES (38, 'Health Care');
INSERT INTO Categories (category_id, category_name) VALUES (39, 'Office & School Supplies');
INSERT INTO Categories (category_id, category_name) VALUES (40, 'Industrial Electrical');
INSERT INTO Categories (category_id, category_name) VALUES (41, 'Industrial Hardware');
INSERT INTO Categories (category_id, category_name) VALUES (42, 'Industrial Power & Hand Tools');
INSERT INTO Categories (category_id, category_name) VALUES (43, 'Industrial Scientific');
INSERT INTO Categories (category_id, category_name) VALUES (44, 'Lab & Scientific Products');
INSERT INTO Categories (category_id, category_name) VALUES (45, 'Janitorial & Sanitation Supplies');
INSERT INTO Categories (category_id, category_name) VALUES (46, 'Test');
INSERT INTO Categories (category_id, category_name) VALUES (47, 'Occupational Health & Safety Products');
INSERT INTO Categories (category_id, category_name) VALUES (48, 'Science Education');
INSERT INTO Categories (category_id, category_name) VALUES (49, 'Raw Materials');
INSERT INTO Categories (category_id, category_name) VALUES (50, 'Food Service Equipment & Supplies');






-- Table: Products
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(255),
  description TEXT,
  price DECIMAL(10, 2),
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);



INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (1, 'Smartphone X', 'The Smartphone X is a powerful and feature-rich device that offers a seamless user experience. It comes with a high-resolution display', 500.0, 1);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (2, 'Wireless Headphones', 'Experience the freedom of wireless audio with these high-quality headphones. They offer crystal-clear sound and a comfortable fit', 150.0, 1);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (3, 'Laptop Pro', 'The Laptop Pro is a sleek and powerful device that is perfect for both work and play. It features a high-performance processor', 1200.0, 2);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (4, 'Smart TV', 'Transform your living room into an entertainment hub with this Smart TV.', 800.0, 2);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (5, 'Running Shoes', 'Get ready to hit the road with these lightweight and comfortable running shoes.', 100.0, 3);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (6, 'Designer Dress', 'Make a statement with this elegant designer dress', 300.0, 3);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (7, 'Coffee Maker', 'Start your day with a perfect cup of coffee brewed with this advanced coffee maker.', 80.0, 4);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (8, 'Toaster Oven', 'Upgrade your kitchen with this versatile toaster oven. It allows you to toast', 70.0, 4);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (9, 'Action Camera', 'Capture your adventures in stunning detail with this action camera.', 200.0, 5);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (10, 'Board Game Collection', 'Enjoy hours of fun with this diverse collection of board games.', 50.0, 5);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (11, 'Yoga Mat', 'Enhance your yoga practice with this premium yoga mat.', 30.0, 6);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (12, 'Skincare Set', 'Pamper your skin with this luxurious skincare set.', 150.0, 6);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (13, 'Vitamin C Supplement', 'Boost your immune system and promote overall health with this vitamin C supplement.', 20.0, 7);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (14, 'Weighted Blanket', 'Experience deep relaxation and improved sleep with this weighted blanket.', 100.0, 7);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (15, 'Mountain Bike', 'Conquer the trails with this high-performance mountain bike.', 1000.0, 8);
INSERT INTO Products (product_id, product_name, description, price, category_id) VALUES (16, 'Tennis Racket', 'Take your tennis game to the next level with this professional-grade racket.', 54.0, 8);




-- Table: Users
CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  username VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255),
  address VARCHAR(255),
  phone_number VARCHAR(20)
);

INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (1, 'johndoe', 'johndoe@example.com', 'pass123', '123 Main St', '123-456-7890');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (2, 'janesmith', 'janesmith@example.com', 'pass456', '456 Elm St', '987-654-3210');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (3, 'maryjones', 'maryjones@example.com', 'pass789', '789 Oak St', '555-123-4567');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (4, 'robertbrown', 'robertbrown@example.com', 'passabc', '321 Pine St', '111-222-3333');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (5, 'sarahwilson', 'sarahwilson@example.com', 'passxyz', '567 Maple St', '444-555-6666');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (6, 'michaellee', 'michaellee@example.com', 'pass456', '890 Cedar St', '777-888-9999');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (7, 'lisawilliams', 'lisawilliams@example.com', 'pass789', '432 Birch St', '222-333-4444');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (8, 'chrisharris', 'chrisharris@example.com', 'pass123', '876 Walnut St', '666-777-8888');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (9, 'emilythompson', 'emilythompson@example.com', 'passabc', '543 Oak St', '999-000-1111');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (10, 'davidmartinez', 'davidmartinez@example.com', 'passxyz', '987 Elm St', '333-444-5555');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (11, 'amandajohnson', 'amandajohnson@example.com', 'pass123', '654 Pine St', '888-999-0000');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (12, 'jasonrodriguez', 'jasonrodriguez@example.com', 'pass456', '321 Maple St', '111-222-3333');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (13, 'ashleytaylor', 'ashleytaylor@example.com', 'pass789', '789 Cedar St', '444-555-6666');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (14, 'matthewthomas', 'matthewthomas@example.com', 'passabc', '234 Birch St', '777-888-9999');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (15, 'sophiawalker', 'sophiawalker@example.com', 'pass123', '876 Walnut St', '222-333-4444');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (16, 'jacobanderson', 'jacobanderson@example.com', 'passxyz', '543 Oak St', '666-777-8888');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (17, 'olivialopez', 'olivialopez@example.com', 'pass456', '987 Elm St', '999-000-1111');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (18, 'ethanmiller', 'ethanmiller@example.com', 'pass789', '654 Pine St', '333-444-5555');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (19, 'emilygonzalez', 'emilygonzalez@example.com', 'pass123', '321 Maple St', '888-999-0000');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (20, 'williamhernandez', 'williamhernandez@example.com', 'pass456', '234 Birch St', '111-222-3333');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (21, 'sophiawright', 'sophiawright@example.com', 'pass789', '789 Cedar St', '444-555-6666');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (22, 'alexanderhill', 'alexanderhill@example.com', 'passabc', '876 Walnut St', '777-888-9999');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (23, 'madisonmoore', 'madisonmoore@example.com', 'pass123', '543 Oak St', '222-333-4444');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (24, 'jamesrogers', 'jamesrogers@example.com', 'passxyz', '987 Elm St', '666-777-8888');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (25, 'emilyward', 'emilyward@example.com', 'pass456', '654 Pine St', '999-000-1111');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (26, 'benjamincarter', 'benjamincarter@example.com', 'pass123', '321 Maple St', '333-444-5555');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (27, 'gracestewart', 'gracestewart@example.com', 'pass789', '234 Birch St', '888-999-0000');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (28, 'danielturner', 'danielturner@example.com', 'passabc', '789 Cedar St', '111-222-3333');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (29, 'elliecollins', 'elliecollins@example.com', 'pass123', '876 Walnut St', '444-555-6666');
INSERT INTO Users (user_id, username, email, password, address, phone_number) VALUES (30, 'williamwood', 'williamwood@example.com', 'pass456', '543 Oak St', '777-888-9999');

-- Table: Orders
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (1, 1, '2021-01-05', 100.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (2, 2, '2021-02-10', 75.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (3, 3, '2021-03-15', 120.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (4, 4, '2021-04-20', 155.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (5, 5, '2021-05-25', 90.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (6, 6, '2021-06-30', 80.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (7, 7, '2021-07-05', 125.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (8, 8, '2021-08-10', 150.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (9, 9, '2021-09-15', 95.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (10, 10, '2021-10-20', 70.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (11, 11, '2021-11-25', 115.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (12, 12, '2021-12-30', 160.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (13, 13, '2022-01-05', 85.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (14, 14, '2022-02-10', 130.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (15, 15, '2022-03-15', 75.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (16, 16, '2022-04-20', 110.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (17, 17, '2022-05-25', 145.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (18, 18, '2022-06-30', 100.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (19, 19, '2022-07-05', 65.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (20, 20, '2022-08-10', 140.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (21, 21, '2022-09-15', 105.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (22, 22, '2022-10-20', 80.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (23, 23, '2022-11-25', 115.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (24, 24, '2022-12-30', 150.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (25, 25, '2023-01-05', 95.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (26, 26, '2023-02-10', 130.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (27, 27, '2023-03-15', 75.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (28, 28, '2023-04-20', 110.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (29, 29, '2023-05-25', 145.0);
INSERT INTO Orders (order_id, user_id, order_date, total_amount) VALUES (30, 30, '2023-06-30', 100.0);


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


INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (1.0, 1.0, 1.0, 2.0, 50.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (2.0, 1.0, 2.0, 1.0, 25.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (3.0, 2.0, 3.0, 3.0, 30.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (4.0, 2.0, 4.0, 1.0, 15.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (5.0, 3.0, 5.0, 2.0, 20.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (6.0, 3.0, 6.0, 1.0, 10.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (7.0, 4.0, 7.0, 3.0, 35.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (8.0, 4.0, 8.0, 1.0, 40.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (9.0, 5.0, 9.0, 2.0, 30.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (10.0, 5.0, 10.0, 1.0, 25.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (11.0, 6.0, 11.0, 3.0, 20.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (12.0, 6.0, 12.0, 1.0, 15.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (13.0, 7.0, 13.0, 2.0, 25.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (14.0, 7.0, 14.0, 1.0, 30.0);
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price) VALUES (15.0, 8.0, 15.0, 3.0, 40.0);


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

INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (1, 1, 1, 5, 'Great product!', '2021-01-05');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (2, 2, 2, 4, 'Good product.', '2021-02-10');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (3, 3, 3, 3, 'Average product.', '2021-03-15');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (4, 4, 4, 5, 'Excellent product!', '2021-04-20');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (5, 5, 5, 2, 'Disappointing product.', '2021-05-25');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (6, 6, 6, 4, 'Good value for money.', '2021-06-30');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (7, 7, 7, 5, 'Highly recommended!', '2021-07-05');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (8, 8, 8, 3, 'Could be better.', '2021-08-10');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (9, 9, 9, 4, 'Satisfied with the purchase.', '2021-09-15');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (10, 10, 10, 1, 'Worst product ever.', '2021-10-20');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (11, 11, 11, 5, 'Amazing quality!', '2021-11-25');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (12, 12, 12, 4, 'Impressed with the features.', '2021-12-30');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (13, 13, 13, 2, 'Not worth the price.', '2022-01-05');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (14, 14, 14, 3, 'Decent product.', '2022-02-10');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (15, 15, 15, 5, 'Absolutely love it!', '2022-03-15');
INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date) VALUES (16, 16, 16, 4, 'Great customer service.', '2022-04-20');


CREATE TABLE Cart (
  cart_id INT PRIMARY KEY,
  user_id INT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Cart (cart_id, user_id) VALUES (1, 1);
INSERT INTO Cart (cart_id, user_id) VALUES (2, 2);
INSERT INTO Cart (cart_id, user_id) VALUES (3, 3);
INSERT INTO Cart (cart_id, user_id) VALUES (4, 4);
INSERT INTO Cart (cart_id, user_id) VALUES (5, 5);
INSERT INTO Cart (cart_id, user_id) VALUES (6, 6);
INSERT INTO Cart (cart_id, user_id) VALUES (7, 7);
INSERT INTO Cart (cart_id, user_id) VALUES (8, 8);
INSERT INTO Cart (cart_id, user_id) VALUES (9, 9);
INSERT INTO Cart (cart_id, user_id) VALUES (10, 10);
INSERT INTO Cart (cart_id, user_id) VALUES (11, 11);
INSERT INTO Cart (cart_id, user_id) VALUES (12, 12);
INSERT INTO Cart (cart_id, user_id) VALUES (13, 13);
INSERT INTO Cart (cart_id, user_id) VALUES (14, 14);
INSERT INTO Cart (cart_id, user_id) VALUES (15, 15);
INSERT INTO Cart (cart_id, user_id) VALUES (16, 16);
INSERT INTO Cart (cart_id, user_id) VALUES (17, 17);
INSERT INTO Cart (cart_id, user_id) VALUES (18, 18);
INSERT INTO Cart (cart_id, user_id) VALUES (19, 19);
INSERT INTO Cart (cart_id, user_id) VALUES (20, 20);
INSERT INTO Cart (cart_id, user_id) VALUES (21, 21);
INSERT INTO Cart (cart_id, user_id) VALUES (22, 22);
INSERT INTO Cart (cart_id, user_id) VALUES (23, 23);
INSERT INTO Cart (cart_id, user_id) VALUES (24, 24);
INSERT INTO Cart (cart_id, user_id) VALUES (25, 25);
INSERT INTO Cart (cart_id, user_id) VALUES (26, 26);
INSERT INTO Cart (cart_id, user_id) VALUES (27, 27);
INSERT INTO Cart (cart_id, user_id) VALUES (28, 28);
INSERT INTO Cart (cart_id, user_id) VALUES (29, 29);
INSERT INTO Cart (cart_id, user_id) VALUES (30, 30);


CREATE TABLE Cart_Items (
  cart_item_id INT PRIMARY KEY,
  cart_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (1, 1, 1, 1);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (2, 1, 2, 2);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (3, 2, 3, 1);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (4, 2, 4, 3);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (5, 3, 5, 2);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (6, 3, 6, 1);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (7, 4, 7, 3);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (8, 4, 8, 1);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (9, 5, 9, 2);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (10, 5, 10, 1);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (11, 6, 11, 3);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (12, 6, 12, 1);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (13, 7, 13, 2);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (14, 7, 14, 1);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (15, 8, 15, 3);
INSERT INTO Cart_Items (cart_item_id, cart_id, product_id, quantity) VALUES (16, 8, 16, 1);



-- Table: Payments
CREATE TABLE Payments (
  payment_id INT PRIMARY KEY,
  order_id INT,
  payment_date DATE,
  payment_method VARCHAR(255),
  amount DECIMAL(10, 2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (1, 1, '2021-01-02', 'Credit Card', 100.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (2, 2, '2021-02-02', 'PayPal', 200.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (3, 3, '2021-03-02', 'Credit Card', 150.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (4, 4, '2021-04-02', 'PayPal', 175.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (5, 5, '2021-05-02', 'Credit Card', 120.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (6, 6, '2021-06-02', 'PayPal', 90.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (7, 7, '2021-07-02', 'Credit Card', 135.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (8, 8, '2021-08-02', 'PayPal', 160.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (9, 9, '2021-09-02', 'Credit Card', 105.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (10, 10, '2021-10-02', 'PayPal', 140.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (11, 11, '2021-11-02', 'Credit Card', 125.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (12, 12, '2021-12-02', 'PayPal', 180.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (13, 13, '2022-01-02', 'Credit Card', 95.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (14, 14, '2022-02-02', 'PayPal', 130.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (15, 15, '2022-03-02', 'Credit Card', 145.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (16, 16, '2022-04-02', 'PayPal', 170.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (17, 17, '2022-05-02', 'Credit Card', 115.0);
INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, amount) VALUES (18, 18, '2022-06-02', 'PayPal', 150.0);


-- Table: Shipping
CREATE TABLE Shipping (
  shipping_id INT PRIMARY KEY,
  order_id INT,
  shipping_date DATE,
  shipping_address VARCHAR(255),
  tracking_number VARCHAR(255),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (1, 1, '2021-01-03', '123 Main St', 'ABC123');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (2, 2, '2021-02-03', '456 Elm St', 'XYZ789');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (3, 3, '2021-03-03', '789 Oak St', 'DEF456');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (4, 4, '2021-04-03', '321 Pine St', 'GHI789');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (5, 5, '2021-05-03', '654 Maple St', 'JKL012');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (6, 6, '2021-06-03', '987 Cedar St', 'MNO345');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (7, 7, '2021-07-03', '210 Birch St', 'PQR678');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (8, 8, '2021-08-03', '543 Walnut St', 'STU901');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (9, 9, '2021-09-03', '876 Oak St', 'VWX234');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (10, 10, '2021-10-03', '109 Pine St', 'YZ0123');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (11, 11, '2021-11-03', '432 Maple St', 'ABC345');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (12, 12, '2021-12-03', '765 Cedar St', 'DEF678');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (13, 13, '2022-01-03', '098 Birch St', 'GHI901');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (14, 14, '2022-02-03', '321 Walnut St', 'JKL234');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (15, 15, '2022-03-03', '654 Oak St', 'MNO567');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (16, 16, '2022-04-03', '987 Pine St', 'PQR890');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (17, 17, '2022-05-03', '210 Maple St', 'STU123');
INSERT INTO Shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) VALUES (18, 18, '2022-06-03', '543 Cedar St', 'VWX456');


