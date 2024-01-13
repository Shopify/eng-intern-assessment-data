-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Create an avg_rating CTE to get all average rating for all products
-- Use this CTE to get the product_id and product name of these high average rating products. 
With AVG_RATING AS (
    SELECT product_id, avg(rating) as average_rating
    FROM reviews
    GROUP BY product_id
)
Select p.product_id, p.product_name, a.average_rating 
FROM products p
INNER JOIN AVG_RATING a
ON p.product_id = a.product_id
ORDER BY a.average_rating;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Join tables users, orders, orderitems, products to get all the information required
-- Counting distinct category_id and checking it with the categories table to match whether
-- User has made at least one order in each category
SELECT u.user_id, u.username
FROM users u
LEFT JOIN orders o on u.user_id = o.order_id
LEFT JOIN orderItems oi on o.order_id = oi.order_id
LEFT JOIN products p on oi.category_id = p.category_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- First get products that received a review
-- Then exclude the products that have reviewed a review
Select p.product_id, p.product_name
FROM products p
WHERE NOT EXISTS 
    (SELECT * 
    FROM reviews r
    WHERE p.product_id = r.product_id);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Get the user_id and username that have at least made orders two days in a row to include all cases
-- Using the DATEDIFF function, specifying the day difference of first date and second date is 1
SELECT DISTINCT u.user_id, u.username
FROM users u 
JOIN orders o on u.user_id = o.user_id
JOIN orders o2 on u.user_id = o2.user_id
WHERE o.order_id <> o2.order_id AND 
        DATEDIFF(day, o.order_date, o2.order_date) = 1;
