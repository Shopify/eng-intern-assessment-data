-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Selecting all of the columns in the products table
SELECT *
FROM products
WHERE category_id = 8; -- selecting from catgory_id 8 which is sports & outdoor 


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.


-- selecting the user ID, username, and count of orders for each user
SELECT users.user_id,
      users.username,
      COUNT(o.order_id) AS total_orders
FROM Users u 
-- joining the Users table with the Order table using the user_id
INNER JOIN Orders o ON u.user_id = o.user_id field 
 -- Grouping the results by the user_id to calcualte the total orders per user
GROUP BY user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.


-- Selecting the product ID, product name, and the average rating for each product
SELECT p.product_id,
      p.product_name,
      AVG(r.rating) AS average_rating
FROM Products p
  -- Joining the Products table with the Reviews table using the product_id field 
INNER JOIN Reviews r  ON p.product_id = r.product_id
  -- Grouping the results by product_id to calculate the average rating per product 
GROUP BY p.product_id; 

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Selecting the user ID, username, and the sum of the total_amount from the Orders table for each user
SELECT u.user_id,
      u.username,
      SUM(o.total_amount) AS total_spent
  FROM Users u 
  -- Joining the Users table with the Orders table using the user_id field 
  INNER JOIN Orders o ON u.user_id = o.user_id
  -- Grouping the results by user_id to get the total spent per user 
  GROUP BY u.user_id
  -- Ordering the results by the total spent in descending order (highest first)
  ORDER BY total_spent DESC
  -- Limiting the results to the top 5 users 
  LIMIT 5;



