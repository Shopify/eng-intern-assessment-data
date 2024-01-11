-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- CTE to calculate average rating for each product
WITH Average_Rating AS (
    SELECT 
        product_id, 
        AVG(rating) AS avg_rating
    FROM 
        Reviews
    GROUP BY 
        product_id
)
-- Select product details and sorted from highest to lowest
SELECT p.product_id, p.product_name, a.avg_rating AS AverageRating FROM products AS p
JOIN Average_Rating AS a ON p.product_id = a.product_id
ORDER BY AverageRating DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Join Users, Orders, Order_items, Products, Categories to get all the categories of each user per user
-- Add aggregate clauses to ensure that each DISTINCT category per user is the same number of categories (at least one order of each category)
SELECT u.user_id, u.username FROM users AS u
JOIN orders AS o ON u.user_id = o.user_id
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
JOIN categories as c ON p.category_id = c.category_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Select products that do not have any associated entry in the Reviews table
-- Using WHERE NOT EXISTS to find products without reviews
SELECT p.product_id, p.product_name FROM Products AS p
WHERE NOT EXISTS (SELECT * FROM reviews AS r WHERE r.product_id = p.product_id);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- CTE and window functions to calcualte consecutive days
-- First condition checks that there is a next consecutive day for the same user
-- Else condiition will then calcualte the difference in days between the orders
WITH Cons_Orders AS (
    SELECT u.user_id, u.username, o.order_date,
    CASE
        WHEN LEAD(o.order_date) OVER(PARTITION BY u.user_id) IS NULL THEN 1
        ELSE ABS(o.order_date - LEAD(o.order_date) OVER(PARTITION BY u.user_id))
    END AS 'Day_gap'
    FROM Orders AS o
    JOIN Users AS u ON o.user_id = u.user_id
)
-- Show all users that have consecutive orders (# of day gaps must equal # of orders and must have more than one order)
SELECT user_id, username FROM Cons_Orders 
GROUP BY user_id, username
HAVING count(*) = SUM(Day_gap)
AND count(*) > 1;

