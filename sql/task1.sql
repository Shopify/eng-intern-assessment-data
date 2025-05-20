
-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Note
-- Assumption: product id 8 corresponding to the Sports and Outdoors category is what we want.
-- Alternative: join with Categories and get lower(category_name) LIKE %sports%
-- If we want a more generic approach, we could use the alternative

SELECT *
FROM Products 
WHERE category_id = 8

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Note
-- Assumption: order_id is the primary key for orders and thus unique
-- Approach: using a left join so we get data for all users (even if they have 0 orders)

SELECT
  Users.user_id,
  username,
  COUNT(order_id) AS total_orders
FROM Users
LEFT JOIN Orders USING(user_id)
GROUP BY 1, 2


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Note
-- Approach: using a left join so we get data for all products (even if they have 0 reviews)

SELECT
  Products.product_id,
  product_name,
  AVG(rating) AS avergage_rating
FROM Products
LEFT JOIN Reviews USING(product_id)


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Note
-- Appoach: taking total amounts of all orders as total amount spent 

SELECT
  Users.user_id,
  username,
  SUM(total_amount) AS total_amount_spent
FROM Users
INNER JOIN Orders USING(user_id)
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 5