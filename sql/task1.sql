-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- This query joins the Products and Categories tables to retrieve all products that belong to the 'Sports' category.
-- The WHERE clause filters the categories to include only those with 'Sports' in their name.
SELECT *
FROM 
    Products
INNER JOIN 
    Categories ON Products.category_id = Categories.category_id
WHERE 
    Categories.category_name LIKE '%Sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- This query joins the Users and Orders tables to count the total number of orders for each user.
-- The GROUP BY clause is used to group the results by user_id and username.
-- The COUNT function is used to count the number of orders per user.
SELECT 
    Users.user_id,
    Users.username,
    COUNT(Orders.order_id) AS "Total Number of Orders"
FROM 
    Users
INNER JOIN 
    Orders ON Users.user_id = Orders.user_id
GROUP BY 
    Users.user_id,
    Users.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- This query joins the Products and Reviews tables to calculate the average rating for each product.
-- The GROUP BY clause groups the results by product_id and product_name.
-- The AVG function is used to calculate the average rating per product.
SELECT 
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) AS "Average Rating"
FROM 
    Products
INNER JOIN 
    Reviews ON Products.product_id = Reviews.product_id
GROUP BY 
    Products.product_id,
    Products.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- This query joins the Users and Orders tables to calculate the total amount spent on orders for each user.
-- The GROUP BY clause groups the results by user_id and username.
-- The SUM function calculates the total amount spent, and the ORDER BY clause sorts these totals in descending order.
-- The SELECT TOP 5 clause limits the results to the top 5 users with the highest total spent.
SELECT TOP 5
    Users.user_id,
    Users.username,
    SUM(Orders.total_amount) AS total_spent
FROM 
    Users
INNER JOIN 
    Orders ON Users.user_id = Orders.user_id
GROUP BY 
    Users.user_id,
    Users.username
ORDER BY 
    total_spent DESC;
