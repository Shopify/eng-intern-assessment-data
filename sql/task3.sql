-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT top 3
    c.category_id,
    c.category_name,
    sum(oi.unit_price * oi.quantity) as total_sales_amount
FROM   
    categories c
JOIN
    products p on c.category_id = p.category_id
JOIN
    order_items oi on p.product_id = oi.product_id
group by 
    c.category_id, c.category_name
order BY
    total_sales_amount desc; 

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH ToysAndGamesProducts AS (
    SELECT product_id 
    FROM Products 
    WHERE category_id = (
        SELECT category_id 
        FROM Categories 
        WHERE category_name = 'Toys & Games'
    )
), UsersOrderedAllProducts AS (
    SELECT o.user_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    WHERE oi.product_id IN (SELECT product_id FROM ToysAndGamesProducts)
    GROUP BY o.user_id
    HAVING COUNT(DISTINCT oi.product_id) = (SELECT COUNT(*) FROM ToysAndGamesProducts)
)
SELECT u.user_id, u.username
FROM Users u
JOIN UsersOrderedAllProducts uoap ON u.user_id = uoap.user_id;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedProducts AS (
  SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.price,
    ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as rn
  FROM
    Products p
)
SELECT
  product_id,
  product_name,
  category_id,
  price
FROM
  RankedProducts
WHERE
  rn = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
