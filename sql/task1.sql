-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- filter on category 8: Sports & Recreation
SELECT *
FROM Products
WHERE category_id = 8 


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- count order by grouping on user
SELECT O.user_id, username, count(order_id) as total_orders
FROM Orders O
LEFT JOIN Users U on O.user_id = U.user_id
GROUP BY user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- get avg rating by grouping on product
SELECT R.product_id, product_name, AVG(rating) as average_rating
FROM Reviews R
LEFT JOIN Products P on R.product_id = P.product_id
GROUP BY R.product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Get top 5 total_spent by grouping on user, ordering desc, and limiting to 5
SELECT O.user_id, username, SUM(total_amount) as total_spent
FROM Orders O
LEFT JOIN Users U ON O.user_id = U.user_id
GROUP BY O.user_id
ORDER BY total_spent DESC 
LIMIT 5
