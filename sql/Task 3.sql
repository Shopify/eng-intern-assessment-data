-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

Select category_id, category_name, SUM(total_amount) as total_amount
From Categories a
Inner Join Products b
ON a.category_id = b.category_id
Inner Join Order_items c
ON c.product_id = b.product_id
Inner Join Orders d
ON c.order_id = d.order_id
Group by 1,2
Order by total_amount desc LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

Select user_id, username
From Users a
Inner Join Orders b
ON a.user_id = b.user_id
Inner Join Order_items c
on b.order_id = c.order_id
Inner Join Products d
On c.product_id = d.product_id

-- Selecting Toys & Games
Inner Join Categories e 
On d.category_id = e.category_id 
Where category_name = "Toys & Games"


Having Count(DISTINCT d.product_id) = (
  Select Count(*) 
  from Products 
  Where category_name = "Toys & Games"
);
  
-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

Select a.product_id, a.product_name, a.category_id, a.price
From Products a
Inner Join (
  Select MAX(price)
  FROM Products
  Where category_id = a.category_id
  );

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH user_order_dates AS (
  SELECT a.user_id, a.order_id, a.order_date,
  LAG(order_date) OVER (PARTITION BY user_id Order By order_date) as prev_order_date
  From Orders
  )
Select a.user_id, a.username
From Users a
Inner Join user_order_dates b
ON a.user_id = b.user_id 
WHERE 
	DATEDIFF(b.order_date, b.prev_order_date) = 1
    AND EXISTS(
      Select 1
      From user_order_dates b1
      Where b1.user_id = a.user_id
      ANd DATEDIFF(b.order_date, b1.prev_order_date) = 1
      AND DATEDIFF(b.order_date, b1.order_date) <= 2
    )
ORDER BY a.user_id, b.order_date;
