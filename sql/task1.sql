-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT Products.product_name
FROM Products
INNER JOIN Categories
ON Products.category_id = Categories.category_id
WHERE Categories.category_name = "Sports";

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT 
  Orders.user_id,
  Users.username,
  COUNT(Orders.order_id) as "num_orders"
FROM Orders
LEFT JOIN Users 
ON Orders.user_id = Users.user_id
GROUP BY Orders.user_id, Users.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT 
  Reviews.product_id,
  Products.product_name,
  AVG(Reviews.rating) as "average_rating"
FROM Reviews
LEFT JOIN Products
ON Reviews.product_id = Products.product_id
GROUP BY Reviews.product_id, Products.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT
  Users.user_id,
  Users.username,
  SUM(Orders.total_amount) as "total_spend"
FROM Users
INNER JOIN Orders
ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.username
ORDER BY SUM(Orders.total_amount) DESC
LIMIT 5;

