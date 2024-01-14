-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AverageRatings AS (
  SELECT 
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) AS average_rating
  FROM Reviews
  INNER JOIN Products
  ON Reviews.product_id = Products.product_id
  GROUP BY Products.product_id, Products.product_name
)
SELECT
  product_id,
  product_name,
  average_rating
FROM AverageRatings
WHERE average_rating = (
  SELECT MAX(average_rating)
  FROM AverageRatings
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT DISTINCT
  Users.user_id,
  Users.username
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id
INNER JOIN Order_Items ON Orders.order_id = Order_Items.order_id
INNER JOIN Products ON Order_Items.product_id = Products.product_id
GROUP BY Users.user_id, Users.username
HAVING COUNT(DISTINCT Products.category_id) =
  (SELECT COUNT(*) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
  Products.product_id,
  Products.product_name
FROM Products
WHERE Products.product_id NOT IN 
(SELECT DISTINCT product_id FROM Reviews);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT
  Users.user_id,
  Users.username
FROM Orders o1
INNER JOIN Orders o2 
  ON o1.user_id = o2.user_id 
  AND o1.order_id != o2.order_id
  AND o1.order_date = DATE_ADD(o2.order_date, INTERVAL 1 DAY)
INNER JOIN Users ON o1.user_id = Users.user_id
GROUP BY Users.user_id, Users.username