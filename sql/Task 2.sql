-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

With average_rating AS (
  Select a.product_id, a.product_name, avg(b.rating) as avg_rating
  FROM Products a
  INNEr join Reviews b
  ON a.product_id = b.product_id
  GROUp By 1,2
)
-- Orders the average ratings from highest to lowest.
Select * 
From average_rating 
ORder by avg_rating desc;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

Select user_id, username
From Users 
Where user_id IN (
  Select a.user_id
  From Orders a
  Inner Join Order_items b
  ON a.order_id = b.order_id
  Inner Join Products c
  ON b.product_id = c.product_id
  
  HAving Count(DISTINCT c.category_id) = (
    Select Count(*) From Categories)
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

Select a.product_id, a.product_name
FROM Products a
LEFt join Reviews b
ON a.product_id = b.product_id
-- Assuming Null if rating doesn't exist.
Where b.ratings = NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH user_order_dates AS (
  SELECT a.user_id, a.order_id, a.order_date,
  LAG(order_date) OVER (PARTITION BY user_id Order By order_date) as prev_order_date
  From Orders
  )
Select a.user_id, a.username
From Users a
Inner Join user_order_dates b
ON a.user_id = b.user_id WHERE DATEDIFF(b.order_date, b.prev_order_date) = 1
ORDER BY a.user_id, b.order_date;

