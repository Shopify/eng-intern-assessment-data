-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
 c.category_id, 
 c.category_name, 
 SUM(oi.quantity * oi.unit_price) AS total_sales_amount 
FROM Categories AS c JOIN Products AS p ON c.category_id = p.category
                     JOIN Order_Items AS oi ON p.product_id = oi.product_id 
GROUP BY c.category_id, c.category_name 
ORDER BY total_sales_amount DESC 
LIMIT 3;
-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem. 

-- Use the subquery to find users whose unique product counts in the 'Toys & Games' category equal to  
-- the number of products in the 'Toys & Games' category
SELECT 
 u.user_id, 
 u.username
FROM Users AS u 
JOIN Orders AS o ON u.user_id = o.user_id 
JOIN Order_Items AS oi ON o.order_id = oi.order_id 
JOIN Products AS p ON oi.product_id = p.product_id 
JOIN Categories AS c ON p.category_id = c.category_id 
WHERE c.category_name = 'Toys & Games' 
GROUP BY u.user_id, u.username 
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(DISTINCT p1.product_id) 
    FROM Products AS p1 
    JOIN Categories AS c1 ON p1.category_id = c1.category_id 
    WHERE c1.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem. 
SELECT   
 product_id, 
 product_name, 
 category_id, 
 price 
FROM (
  SELECT 
   product_id, 
   product_name, 
   category_id, 
   price, 
   ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num
  FROM Products 
) AS a 
WHERE  
 row_num = 1;
-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem. 
WITH unique_date AS ( 
  SELECT   
    DISTINCT u.user_id, 
    u.username, 
    DATE(o.order_date) AS order_date 
  FROM Users AS u 
  JOIN Orders AS o ON u.user_id = o.user_id  
), 
lead_date AS ( 
  SELECT   
    user_id, 
    username, 
    order_date, 
    LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS order_date_1, 
    LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS order_date_2,
  FROM unique_date 
) 
SELECT 
  DISTINCT user_id, username 
FROM lead_date 
WHERE 
  DATEDIFF(order_date_1, order_date) = 1 
  AND DATEDIFF(order_date_2, order_date_1) = 1;
