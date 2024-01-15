-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- retrives all products that contain the string "sports" in their category name
SELECT
-- problem did not specifiy which columns to return, so I returned all of them
  *
FROM
  products p
  JOIN categories c ON p.category_id = c.category_id
-- filters for the products with the string 'sports' in their category name
-- to include any sports category, not just 'Sports & Outdoors'
WHERE
  LOWER(c.category_name) LIKE '%sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- retrieves user id, username, along with total number of orders for each user
SELECT
  u.user_id,
  u.username,
  -- COUNT aggregate function to get the total number of orders for the user
  COUNT(o.order_id) AS total_num_orders
FROM
  users u
  -- LEFT JOIN used to ensure users with 0 orders are returned
  LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY
  u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- retrives product ids, product names, and their average rating
SELECT
  p.product_id,
  p.product_name,
  -- AVG aggregate function to calculate the average rating for each product
  AVG(r.rating) AS avg_rating
FROM
  products p
    -- RIGHT JOIN to retrive only the products with an average rating
  RIGHT JOIN reviews r ON p.product_id = r.product_id
GROUP BY
  p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- retrieves the user id, username, and total amount spent of the top 5 users with the highest total amount spent on orders
SELECT
  u.user_id,
  u.username,
  -- SUM aggregate function to calculate total amount spent on orders
  SUM(o.total_amount) AS total_amount_spent
FROM
  users u
  JOIN orders o ON u.user_id = o.user_id
GROUP BY
  u.user_id
-- order by the total amount spent (DESC)
ORDER BY
  total_amount_spent DESC
-- LIMIT by 5 to get top 5 spenders
LIMIT
  5;