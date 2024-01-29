-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- This query will retrieve all the products in the Sports category.
-- The result includes the product ID, product name, description, price and category.
-- A JOIN statement is used to combine the product data and category data based on their category ID.
-- The WHERE clause is used to filter the result to only include products in the Sports category.
SELECT pd
FROM Products AS pd JOIN Category AS cd
ON pd.category_id = cd.category_id
WHERE cd.category_name LIKE '%Sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- This query will retrieve the total number of orders for each user.
-- The COUNT function is used to count the number of orders for each user.
-- A LEFT JOIN statement is used to combine the user data and order data based on their user ID.
-- The GROUP BY clause is used to group the result by user ID and username.
SELECT ud.user_id, ud.username, COUNT(od.order_id) AS order_count
FROM Users AS ud LEFT JOIN Orders AS od 
ON ud.user_id = od.user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- This query will retrieve the average rating for each product.  
-- The AVG function is used to calculate the average rating for each product.
-- A LEFT JOIN statement is used to combine the product data and review data based on their product ID. 
-- The GROUP BY clause is used to group the result by product ID and product name.
SELECT pd.product_id, pd.product_name, AVG(rd.rating) AS avg_rating 
FROM Products AS pd LEFT JOIN Reviews AS rd 
ON pd.product_id = rd.product_id
GROUP BY pd.product_id, pd.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- This query will retrieve the top 5 users with the highest total amount spent on orders.
-- The SUM function is used to calculate the total amount spent for each user.
-- A LEFT JOIN statement is used to combine the user data and order data based on their user ID.
-- The GROUP BY clause is used to group the result by user ID and username.
-- The ORDER BY clause is used to sort the result by total amount spent in descending order.
-- The LIMIT clause is used to limit the result to only include the top 5 users.
SELECT ud.user_id, ud.username, SUM(od.total_amount) AS total_amount
FROM Users AS ud LEFT JOIN Orders AS od
ON ud.user_id = od.user_id
GROUP BY ud.user_id, ud.username
ORDER BY total_amount DESC
LIMIT 5;
