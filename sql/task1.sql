-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

--From the category_data.csv, Sports & Outdoors has the category_id 8
--All products are listed in product_data.csv mapped with their category_id attribute
--This SQL command returns the names of products who have the category_id 8
SELECT product_name 
FROM Products 
WHERE category_id=8;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- User_data.csv contains the user_id & username
-- Order_data.csv contains the user_id & the order_id
-- We will use the COUNT function to count the # of orders 
-- We will use GROUP BY function to aggregate per user
-- As the task requires # of orders for every user, I will use a FULL OUTER JOIN
SELECT Orders.user_id, Users.username, COUNT(Orders.order_id) FROM Orders
FULL OUTER JOIN Users ON Users.user_id=Orders.user_id
GROUP BY Orders.user_id, Users.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Rating is found in review_data (as rating) with product ID
-- To get average, we can use the AVG function, with GROUP BY product ID
-- To get product name, LEFT JOIN with product_data using product ID
SELECT Reviews.product_id, Products.product_name, AVG(Reviews.rating) FROM Reviews
LEFT JOIN Products ON Reviews.product_id=Products.product_id
GROUP BY Reviews.product_id, Products.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Payment amounts can be found in Payments table
-- Payments table also includes the order id, which we can use to join it with the Orders table
-- Orders has the user_id, but we still need the username in Users table
-- Another join will allow us to get the username from the Users table
SELECT Orders.user_id, Users.username, SUM(Payments.amount) FROM Payments
LEFT JOIN Orders ON Payments.order_id=Orders.order_id
LEFT JOIN Users ON Orders.user_id=Users.user_id
GROUP BY Orders.user_id, Users.username;
