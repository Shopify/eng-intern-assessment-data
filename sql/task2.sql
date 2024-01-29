-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH ProductAvgRating AS (
  SELECT
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) AS average_rating
  FROM Products
  LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
  GROUP BY Products.product_id, Products.product_name
)

SELECT
  product_id,
  product_name,
  average_rating
FROM ProductAvgRating
ORDER BY average_rating DESC
LIMIT 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT
  Users.user_id,
  Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
JOIN (
  SELECT DISTINCT Users.user_id, Categories.category_id
  FROM Users
  CROSS JOIN Categories
) UserCategories ON Users.user_id = UserCategories.user_id
LEFT JOIN (
  SELECT DISTINCT Users.user_id, Orders.category_id
  FROM Users
  JOIN Orders ON Users.user_id = Orders.user_id
) UserOrders ON Users.user_id = UserOrders.user_id AND UserCategories.category_id = UserOrders.category_id
WHERE UserOrders.category_id IS NOT NULL;


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
  Products.product_id,
  Products.product_name
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
WHERE Reviews.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH UserConsecutiveOrders AS (
  SELECT
    user_id,
    order_date,
    LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
  FROM Orders
)

SELECT DISTINCT
  UC1.user_id,
  Users.username
FROM UserConsecutiveOrders UC1
JOIN Users ON UC1.user_id = Users.user_id
WHERE UC1.next_order_date = DATE_ADD(UC1.order_date, INTERVAL 1 DAY);
