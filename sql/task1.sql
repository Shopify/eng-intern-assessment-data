-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT product_name AS "Products"
FROM Products
INNER JOIN Categories
ON Products.category_id = Categories.category_id
WHERE UPPER(Categories.category_name) LIKE '%SPORTS%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT Users.user_id AS "User_ID", 
username AS "Username", 
COUNT(Order_Items.order_id) AS "Total_Number_of_Orders" 
FROM Users 
INNER JOIN Orders 
ON Users.user_id = Orders.user_id 
INNER JOIN Order_Items 
ON Orders.order_id = Order_Items.order_id 
GROUP BY Users.user_id, Users.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT Products.product_id AS "Product_ID", 
product_name AS "Product_Name", 
AVG(rating) AS "Average_Rating" 
FROM Products 
INNER JOIN Reviews 
ON Products.product_id = Reviews.product_id 
GROUP BY Reviews.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT
Users.user_id AS "User_ID",
Users.username AS "Username",
SUM(Orders.total_amount) AS "Total_Amount_Spent"
FROM Users 
INNER JOIN Orders 
ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.username
ORDER BY Total_Amount_Spent DESC, User_ID
LIMIT 5;