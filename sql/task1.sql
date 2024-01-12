-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
--The full category name for 'Sports' is 'Sports & Outdoors', so using '%' wildcard with 'Sports'.
DECLARE @target_category_name VARCHAR(255);
SET @target_category_name = 'Sports%'; -- For retrieving all products in Sports category. Replace string for any specific category
SELECT p.*
FROM Products p
    JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name LIKE @target_category_name;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    u.user_id,
    u.username,
    COUNT(o.order_id) AS total_number_orders
FROM Users u
    LEFT JOIN Orders o ON u.user_id = o.user_id -- LEFT JOIN to include users with no orders
GROUP BY
    u.user_id; -- relying on user_id to be unique for each user

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT
    p.product_id,
    p.product_name,
    AVG(Reviews.rating) AS average_rating
FROM Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id -- LEFT JOIN to include products with no reviews. Products without reviews will have NULL average_rating
GROUP BY
    p.product_id; -- like user_id, relying on product_id to be unique for each product

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT
    u.user_id, 
    u.username, 
    SUM(o.total_amount) AS total_amount_spent
FROM Users u
    JOIN Orders o ON u.user_id = u.user_id
GROUP BY
    u.user_id
ORDER BY
    total_amount_spent DESC
LIMIT 5; --allows for less than 5 users to be retrieved if there are less than 5 users to be reported (e.g. only 3 users total with purchases). Empty set returned if no users have made purchases.