-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT Products.product_id, Products.product_name, AVG(Reviews.rating) as avg_rating
FROM Products
INNER JOIN Reviews on Products.product_id = Reviews.product_id
GROUP BY Products.product_id
HAVING avg_rating = (SELECT MAX(avg_rating) FROM 
  (SELECT Products.product_id, Products.product_name, AVG(Reviews.rating) as avg_rating
  FROM Products
  INNER JOIN Reviews on Products.product_id = Reviews.product_id
  GROUP BY Products.product_id));

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT Users.user_id, Users.username
FROM Users
  JOIN Orders on Users.user_id = Orders.user_id
  JOIN Order_items on Users.user_id = Order_items.user_id
  JOIN Products on Users.user_id = Products.user_id
  JOIN Categories on Users.user_id = Categories.user_id
GROUP BY Users.user_id
HAVING COUNT(Categories.category_id) = (SELECT COUNT(Categories.category_id) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT Products.product_id, Products.product_name
FROM Products
LEFT JOIN Reviews on Products.product_id = Reviews.product_id
WHERE Reviews.product_id is null;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT Users.user_id, Users.username
FROM Users
JOIN Orders Orders1 on Users.user_id = Orders1.user_id
JOIN Orders Orders2 on Users.user_id = Orders2.user_id 
AND Orders1.order_date = DATE(Orders2.order_date, '+1 day');
