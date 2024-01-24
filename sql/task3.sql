-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
   category_id,
   category_name,
   SUM(amount_order) AS total_amount,
   DENSE_RANK() OVER (ORDER BY SUM(amount_order) DESC) AS ranked_category
FROM
(
SELECT
   oi.order_id,
   ---o.total_amount,
   oi.product_id,
   c.category_id,
   c.category_name,
   (oi.quantity* oi.unit_price) as amount_order
FROM Order_Items  oi
JOIN Products p ON o.product_id=oi.product_id
JOIN Categories c p.category_id=c.category_id
GROUP BY 1, 2,3,4)
WHERE ranked_category <= 3

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    u.user_id,
    u.username
FROM
    Users u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM Products p
    WHERE p.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
    AND NOT EXISTS (
        SELECT 1
        FROM Orders o
        JOIN Order_Items oi ON o.order_id = oi.order_id
        WHERE u.user_id = o.user_id AND oi.product_id = p.product_id
    )
)

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT
   p.product_id,
   p.product_name,
   p.category_name,
   p.price
FROM Products p
WHERE
    p.price = (
        SELECT
            category_id,
            MAX(price) AS max_price
        FROM
            Products p2
        WHERE
            p.category_id = p2.category_id
        GROUP BY
            category_id
     )

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT
     o.user_id,
     u.username
FROM (
         SELECT user_id,
                order_date,
                LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date
        DATEDIFF(DAY, Lag(order_date)
                      OVER (
                      user_id ORDER BY order_date), order_date) AS time_diff
         FROM Orders
     ) o
JOIN Users u USING (user_id)
WHERE time_diff >= 3
