-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * 
FROM Products
where category_id = 8;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
  u.user_id,
  u.username,
  COUNT(o.order_id) AS total_orders
FROM
  users u
LEFT JOIN
  orders o ON u.user_id = o.user_id
GROUP BY
  u.user_id, u.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT
  p.product_id,
  p.product_name,
  AVG(r.rating) as average_rating
FROM
  products p
LEFT JOIN
  reviews r ON p.product_id = r.product_id
GROUP BY
  p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT TOP 5
  u.user_id,
  u.username,
  SUM(o.total_amount) AS amount_spent
FROM
  users u
LEFT JOIN
  orders o ON u.user_id = o.user_id
GROUP BY
  u.user_id, u.username
ORDER BY
  amount_spent DESC;

-- could also be LIMIT 5 in the end instead of "select top 5" but VSCode gives me an error
-- if I use LIMIT 5