-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT p.product_id, p.product_name, COALESCE(AVG(r.rating),0) AS average_rating -- Same general structure as for Problem 3, except ordering by rating and limiting to 5 products
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id 
ORDER BY average_rating DESC 
LIMIT 5;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

WITH UserProductInfo AS (
    SELECT u.user_id, u.username, p.category_id
    FROM users u
    LEFT JOIN orders o on o.user_id = u.user_id
    LEFT JOIN order_items oi on oi.order_id = o.order_id
    LEFT JOIN products p on p.product_id = oi.product_id
) -- Combining general User, Product, and Order information that may be useful beyond just this query (like in Problem 10)

SELECT upi.user_id, upi.username
FROM UserProductInfo upi
GROUP BY upi.user_id, upi.username
HAVING (COUNT(DISTINCT upi.category_id) = (SELECT COUNT(DISTINCT category_id) FROM categories)); -- Ensure that the number of categories in upi is equal to the total number of categories

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM products p 
LEFT JOIN reviews r on p.product_id = r.product_id
WHERE r.product_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH ConsecutiveOrders AS (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) as previous_order_date
    FROM orders
    ) -- Simple order info CTE that uses LAG to get the previous date for each user with multiple orders
    
SELECT DISTINCT u.user_id,u.username
FROM ConsecutiveOrders co 
LEFT JOIN users u ON co.user_id = u.user_id
WHERE co.previous_order_date IS NOT NULL AND
      co.order_date = co.previous_order_date + INTERVAL '1 day'; -- Account for NULLs and ensure order dates are consecutive
