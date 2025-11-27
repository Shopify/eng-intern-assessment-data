-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem. 

-- Create CTE temp_rating for each product sort all products in a reverse order to find the product with 
-- the highest average rating
WITH temp_rating AS ( 
SELECT  
 p.product_id, 
 p.product_name,  
 AVG(r.rating) AS avg_rating  
 FROM Reviews AS r JOIN Products AS p ON r.product_id = p.product_id 
 GROUP BY p.product_id, p.product_name 
)  
SELECT *  
FROM temp_rating  
ORDER BY avg_rating DESC 
LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem. 
SELECT  
 u.user_id,  
 u.username 
FROM Users AS u JOIN Orders AS o ON u.user_id = o.user_id 
                JOIN Order_items AS oi ON o.order_id = oi.order_id 
                JOIN Products AS p ON oi.product_id = p.product_id 
                JOIN Categories AS c ON p.category_id = c.category_id 
GROUP BY u.user_id, u.username 
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem. 
SELECT 
 product_id, 
 product_name 
FROM Products 
WHERE 
 product_id NOT IN (SELECT product_id FROM Reviews);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.    

-- Create CTE unique_date to extract each user and unique order days 
-- Use window function to get the next order day of each user and each order day 
-- Find users who have consecutive order days
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
    LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date 
  FROM unique_date 
) 
SELECT 
  DISTINCT user_id, username 
FROM lead_date 
WHERE 
  DATEDIFF(next_order_date, order_date) = 1;
 
