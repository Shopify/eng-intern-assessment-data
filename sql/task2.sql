-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AverageRatings AS (
  SELECT Products.product_id, Products.product_name, AVG(Reviews.rating) AS avg_rating
  FROM Products
  LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
  GROUP BY Products.product_id, Products.product_name
)

SELECT product_id, product_name, avg_rating
FROM AverageRatings
ORDER BY avg_rating DESC
LIMIT 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT Users.user_id, Users.username
FROM Users
WHERE EXISTS (
  SELECT DISTINCT category_id
  FROM Categories
  EXCEPT
  SELECT DISTINCT category_id
  FROM Products
  LEFT JOIN Orders ON Products.product_id = Order_Items.product_id
  WHERE Users.user_id = Orders.user_id
);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT Products.product_id, Products.product_name
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
WHERE Reviews.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH OrderedUsers AS (
  SELECT user_id, order_date,
         LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
  FROM Orders
)

SELECT DISTINCT ou1.user_id, Users.username
FROM OrderedUsers ou1
JOIN Users ON ou1.user_id = Users.user_id
WHERE ou1.next_order_date = DATE_ADD(ou1.order_date, INTERVAL 1 DAY);
