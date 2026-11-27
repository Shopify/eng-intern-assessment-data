-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- CTE 'SportsCategory' retrieves category_ids for category names that contain 'sports' word 
-- (case-insensitive incase sports is the second word)
-- If 'Sportswear' was a category, this query would retrieve it's data as well

WITH SportsCategory AS (
    SELECT category_id
    FROM Categories
    WHERE LOWER(category_name) LIKE '%sports%'
)

SELECT *
FROM Products
WHERE category_id IN (SELECT category_id FROM SportsCategory);


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Used a 'LEFT JOIN' to include all users (even those that may have place no orders)
-- In PostgresSQL, COUNT() function doesn't return NULL if there are no rows to count.
-- Instead, it returns zero.

SELECT u.user_id, u.username, count(distinct o.order_id) as Total_Number_Orders
FROM Users u
LEFT JOIN Orders o ON o.user_id = u.user_id
GROUP BY u.user_id, u.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.


-- Used a 'LEFT JOIN' to include all products (even those without any reviews)
-- Grouping by p.product_id, p.product_nam, we consider all ratings for a specific product to calculate "average_rating"
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p 
LEFT JOIN Reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- For this query, I considered using the 'Payments' table but after observing that payment amount and order amount for user_id = 2 are different
-- I'm assuming that Payment amount can include shipping costs, customs, etc.
-- For this query, I am only considering the amount spent on the actual 'Order' (from Orders table)

-- Here, I have used 'LEFT JOIN' to include all users (even those that may have place no orders)
-- In PostgresSQL, The SUM() of an empty set will return NULL, not zero.
-- Hence, I have used the COALESCE() function to return zero instead of NULL in case there is no matching row.
-- The 'LIMIT 5' clause restricts the result to the top 5 users.
SELECT u.user_id, u.username, COALESCE(SUM(o.total_amount), 0) AS total_amount_spent
FROM Users u
LEFT JOIN Orders o ON o.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY total_amount_spent DESC
LIMIT 5;