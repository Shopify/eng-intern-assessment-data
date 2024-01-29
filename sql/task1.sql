-- Problem 1:-- Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- joining Categories table to products table then selecting only the products in the specfic category
-- no need to select all of them
SELECT Products.product_name
FROM Products
INNER JOIN Categories ON Products.category_id = Categories.category_id
-- answer will be 'Sports' but since its not part of the DB, test with something else
-- WHERE Categories.category_name = 'Sports';
WHERE Categories.category_name = 'Electronics';

-- Problem 2:-- Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- only select mentioned
SELECT 
    Users.user_id, 
    Users.username, 
    COUNT(Orders.order_id) AS total_orders
FROM Users
LEFT JOIN Orders ON Users.user_id = Orders.user_id -- need to join orders and users. left join in case user does not have an order. ones without will be shown as 0 anyway
GROUP BY Users.user_id, Users.username -- need both since they are not part of count()
ORDER BY total_orders DESC, Users.user_id ASC; -- thought it would be good to order them by total number of orders, in descending order, then user id

-- Problem 3:-- Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- only select mentioned
SELECT 
    Products.product_id, 
    Products.product_name, 
    AVG(Reviews.rating) AS average_rating 
FROM Products
INNER JOIN Reviews ON Products.product_id = Reviews.product_id -- inner join, since there is no point including products without reviews
GROUP BY Products.product_id, Products.product_name -- need both since they are not part of avg()
ORDER BY average_rating DESC, Products.product_id ASC; -- thought it would be good to order them by average rating, in descending order, then product id


-- Problem 4:-- Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- only select mentioned
SELECT 
    Users.user_id, 
    Users.username, 
    SUM(Orders.total_amount) AS total_spent
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id -- inner join to get users who has order
GROUP BY Users.user_id, Users.username -- group by ones not used in sum()
ORDER BY total_spent DESC
LIMIT 5;