-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH TotalProduct AS (
    SELECT p.category_id,o.product_id, o.quantity*o.unit_price AS total_product_amount
    FROM order_items o
    LEFT JOIN products p ON o.product_id = p.product_id
    ) -- Determine the total amount for each product in a given order

SELECT c.category_id, c.category_name, COALESCE(SUM(tp.total_product_amount),0) as total_sales_amount -- If the product hasn't been sold, return a value of 0.
FROM categories c
LEFT JOIN TotalProduct tp ON c.category_id = tp.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH UserProductInfo AS (
    SELECT u.user_id, u.username, p.category_id, p.product_id
    FROM users u
    LEFT JOIN orders o on o.user_id = u.user_id
    LEFT JOIN order_items oi on oi.order_id = o.order_id
    LEFT JOIN products p on p.product_id = oi.product_id
    ), -- Same initial logic as for Problem 6. Additionally, including product_id in UserProductInfo
    CategoryProductIDs AS (
        SELECT DISTINCT p.product_id
        FROM products p
        LEFT JOIN categories c ON p.category_id=c.category_id 
        WHERE c.category_name='Toys & Games' 
    )  -- Saving all of the unique product_ids to check for inclusion in the WHERE statement below, this is flexible enough to check for any given category.

SELECT upi.user_id, upi.username
FROM UserProductInfo upi
WHERE upi.product_id IN (SELECT product_id FROM CategoryProductIDs)
GROUP BY upi.user_id, upi.username
HAVING COUNT(DISTINCT upi.product_id) = (SELECT COUNT(*) FROM CategoryProductIDs); --  Check that the count of product_ids for the user are equal to all for the given category

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT p.product_id, p.product_name, p.category_id, p.price
FROM (
    SELECT product_id, product_name, category_id,price, 
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC NULLS LAST) AS rank
    FROM products
    ) -- Subquery to obtain a rank for each product within its category
AS p
WHERE rank = 1; -- Only selects the items with the highest price within each category

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- An extension of Problem 8 to add another "previous_order_date" to check for consecutive orders and check that the orders fall at least three days in a row
WITH ConsecutiveOrders AS (
    SELECT user_id, order_date, 
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) as previous_order_date, 
    LAG(order_date,2) OVER (PARTITION BY user_id ORDER BY order_date) as previous_order_date_2
    FROM orders
    ) 
    
SELECT DISTINCT u.user_id,u.username
FROM ConsecutiveOrders co 
LEFT JOIN users u ON co.user_id = u.user_id
WHERE co.previous_order_date IS NOT NULL AND
    co.previous_order_date_2 IS NOT NULL AND
    co.order_date = co.previous_order_date + INTERVAL '1 day' AND 
    co.previous_order_date = co.previous_order_date_2 + INTERVAL '1 day';
