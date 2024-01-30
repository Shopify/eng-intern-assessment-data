-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT
    product_id,
    product_name,
    description,
    price,
FROM Products
INNER JOIN Categories ON Categories.user_id = Products.user_id
WHERE category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT 
    user_id,
    username,
    COUNT(order_id) AS total_number_of_orders
FROM Users U
INNER JOIN Orders ON Orders.user_id = Users.user_id
GROUP BY U.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT 
    product_id,
    product_name,
    AVG(rating) AS average_rating
FROM Products P
INNER JOIN Reviews ON Reviews.product_id = Products.product_id
GROUP BY P.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT
    user_id,
    username,
    total_amount_spent
FROM (
    SELECT 
        user_id,
        username,
        SUM(total_amount) AS total_amount_spent
    FROM Users U
    INNER JOIN Orders ON Orders.user_id = Users.user_id
    GROUP BY U.user_id
) AS T
ORDER BY total_amount_spent DESC
LIMIT 5;