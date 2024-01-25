-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


-- using a cte with a subquery to first determine the total amount for each product category
-- by multiplying the quantity of products sold by the price per unit, sum it up at the level
-- of category and rank tem based on the aforementioned amount
-- used dense_rank for values with ties


WITH ranked_categories AS (
SELECT
   category_id,
   category_name,
   SUM(amount_order) AS total_amount,
   DENSE_RANK() OVER (ORDER BY SUM(amount_order) DESC) AS ranked_category
FROM
(
SELECT
   c.category_id,
   c.category_name,
   (oi.quantity * oi.unit_price) as amount_order
FROM Order_Items  oi
JOIN Products p ON p.product_id=oi.product_id
JOIN Categories c ON p.category_id=c.category_id
)
GROUP BY 1,2)
SELECT
     category_id,
     category_name,
     total_amount
FROM ranked_categories
WHERE ranked_category <= 3

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


-- first cte gives total number of categories per product;
-- second cte five the total number of categories per product sold
-- finally, joining the two aforementioned ctes on condition that
-- the number of categories per product match

WITH categories_products AS (
SELECT
p.product_id,
p.product_name,
count(DISTINCT c.category_id) AS total_categories
FROM Products p
JOIN Categories c using (category_id)
GROUP BY 1,2
),

orders_products AS (
SELECT
p.product_id,
p.product_name,
count(DISTINCT  c.category_id) as total_categories
FROM Products p
JOIN Categories c using (category_id)
JOIN order_items oi on p.product_id = oi.product_id
GROUP BY 1,2
)

SELECT
DISTINCT cp.product_id,
cp.product_name
FROM categories_products cp
JOIN orders_products op -- using inner join as it is faster
WHERE cp.total_categories = op.total_categories

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- cte outputs category maximum price per product
-- last select statement outputs the price per product that matches the maximum category price

WITH max_prices AS (
SELECT
         p.product_id,
         category_id,
        MAX(p.price) OVER (PARTITION BY p.category_id) AS max_price
FROM  Products p

)

SELECT
   p.product_id,
   p.product_name,
   p.category_id,
   p.price
FROM Products p
LEFT JOIN  max_prices mp USING(product_id)
WHERE p.price = mp.max_price


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- using a subquery to compute previous order, next order and the difference between them in days,
-- for each user.
-- based on the aforementioned subquery, filter users who have consecutive orders (1 day difference between orders)
-- and a previous and a next order - to account for minimum 3 consecutive orders

SELECT
     o.user_id,
     u.username
FROM (
         SELECT user_id,
                order_date,
                LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date,
                LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_date,
                DATEDIFF(DAY, Lag(order_date)
                      OVER (PARTITION BY user_id ORDER BY order_date), order_date) AS time_diff

         FROM Orders
     ) o
LEFT JOIN Users u USING (user_id)
WHERE time_diff = 1
      AND previous_date IS NOT NULL
      AND next_date IS NOT NULL

