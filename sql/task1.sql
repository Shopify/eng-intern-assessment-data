-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- join Products with Categories in order to find the category name: "Sports 
-- & Outdoors"
SELECT *
FROM Categories JOIN Products ON Categories.category_id = Products.category_id
WHERE category_name = 'Sports & Outdoors'; 

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- count order_id for each user_id in Orders and join with Users to retrieve
-- usernames
SELECT Orders.user_id, username, count(order_id)
FROM Orders JOIN Users ON Orders.user_id = Users.user_id
GROUP BY Orders.user_id, username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- average the ratings for each product_id in Reviews and join with Products to
-- retrieve product names
SELECT Products.product_id, product_name, avg(rating)
FROM Reviews JOIN Products ON Reviews.product_id = Products.product_id
GROUP BY Products.product_id, product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- sum the total_amount spent on orders for each user_id, then sort the total
-- spent from highest to lowest and select the top 5 from the list, and join
-- with Users to retrieve usernames
SELECT Orders.user_id, username, sum(total_amount) as total_spent
FROM Orders JOIN Users ON Orders.user_id = Users.user_id
GROUP BY Orders.user_id, username
ORDER BY total_spent DESC
LIMIT 5; 