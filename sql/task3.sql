-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Join to get the total sales amount for each category
SELECT c.category_id,
       c.category_name,
       SUM(o.total_amount) AS "Total Sales Amount"
  FROM Orders o
  JOIN Order_Items oi
    ON o.order_id    = oi.order_id
  JOIN Products p
    ON oi.product_id = p.product_id
  JOIN Categories c
    ON p.category_id = c.category_id
 GROUP BY c.category_id,
          c.category_name
 ORDER BY SUM(o.total_amount) DESC
 LIMIT 3; -- First 3 records only, regardless of ties in total sales amount (if we were to include ties, this can be re-written with subqueries or DENSE_RANK())
  
-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Join to get users who have placed orders for products in Toys & Games
SELECT u.user_id,
       u.username
  FROM Users u
  JOIN Orders o 
    ON u.user_id = o.user_id
  JOIN Order_Items oi 
    ON o.order_id = oi.order_id
  JOIN Products p 
    ON oi.product_id = p.product_id
  JOIN Categories c 
    ON p.category_id = c.category_id
 WHERE c.category_name = 'Toys & Games'
 GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT oi.product_id) =  -- Filter for users who have ordered all products in Toys & Games
       (SELECT COUNT(product_id)
         FROM Products 
        WHERE category_id = 
              (SELECT category_id
                FROM Categories 
               WHERE category_name = 'Toys & Games'));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH Product_ranks
  AS (SELECT product_id,
             product_name,
             category_id,
             price,
             DENSE_RANK() OVER (PARTITION BY category_id -- Rank products in each category by price
                                    ORDER BY price DESC) as rnk 
        FROM Products)
SELECT product_id,
       product_name,
       category_id,
       price
  FROM Product_ranks
 WHERE rnk = 1; -- Filter for the highest price within each category, including ties
  
-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH User_with_consec_orders AS (
    SELECT user_id,
           order_date,
           LAG(order_date) OVER (PARTITION BY user_id -- LAG() for getting the order date preceding the current one
                                     ORDER BY order_date) AS prev_date, 
           LEAD(order_date) OVER (PARTITION BY user_id -- LEAD() for getting the order date following the current one
                                     ORDER BY order_date) AS next_date
      FROM Orders),
Consec_orders AS (
    SELECT user_id,
           order_date,
           CASE 
             WHEN DATE_ADD(order_date, INTERVAL -1 DAY) = prev_date AND -- Check if the user placed order on order_date, prev_date, and next_date
                  DATE_ADD(order_date, INTERVAL 1 DAY) = next_date THEN 1
             ELSE 0
           END AS has_consecutive_orders
      FROM User_with_consec_orders
)
SELECT DISTINCT -- Find users having at least 1 record with "has_consecutive_orders = 1"
       u.user_id,
       u.username
  FROM Users u
  JOIN Consec_orders co 
    ON u.user_id = co.user_id
 WHERE co.has_consecutive_orders = 1;