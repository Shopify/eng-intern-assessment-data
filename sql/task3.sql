-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH CategorySales AS (
  SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amount
  FROM shopify.order_items AS oi
  JOIN shopify.products AS p ON p.product_id = oi.product_id
  JOIN shopify.categories AS c ON c.category_id = p.category_id
  GROUP BY c.category_id
)

SELECT category_id, category_name, total_sales_amount
FROM CategorySales
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select user_id,username from shopify.users as u where u.user_id in 
(select user_id from shopify.orders as o where o.order_id in ( 
select order_id from shopify.order_items as oi where oi.product_id in
 (select product_id from shopify.products as p where p.category_id in (select category_id from shopify.categories where category_name = "Toys & Games")) 
 group by order_id
 having COUNT(DISTINCT product_id) = (select COUNT(*) FROM (select product_id from shopify.products as p where p.category_id in (select category_id from shopify.categories where category_name = "Toys & Games")) AS Subquery))) ;
 
-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

  
  Select product_id,product_name,price,category_id from
  (Select p.product_id,p.product_name,p.price,p.category_id, ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS PR from shopify.products as p) AS ProdRank where PR = 1;
  
-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH UserConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM
        shopify.orders
)

SELECT DISTINCT
    u.user_id,
    u.username
FROM
    shopify.users as u
JOIN
    UserConsecutiveOrders uc ON u.user_id = uc.user_id
WHERE
    DATEDIFF(uc.next_order_date, uc.order_date) = 1
    AND DATEDIFF(uc.order_date, uc.prev_order_date) = 1
    AND uc.prev_order_date IS NOT NULL
    AND uc.next_order_date IS NOT NULL;
    