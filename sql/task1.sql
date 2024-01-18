-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT * 
FROM 
    Products 
WHERE 
    -- use regex because sports category aves as "Sports and Outdoors"
    -- ~ used got postgreSQL but might be different in other versions of SQL
    category_id = (SELECT category_id FROM Categories WHERE category_name ~ 'Sports');


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    Users.user_id,
    Users.username,
    COUNT(Orders.user_id) AS total_orders
FROM
    Users 
LEFT JOIN
    -- left join to pull the users and align with corresponding order counts
    Orders ON Users.user_id = Orders.user_id
GROUP BY
    Users.user_id, Users.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT 
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) as average_rating
FROM
    Products 
LEFT JOIN 
--left join to align the products with corresponing avgerage reviews 
    Reviews on Reviews.product_id = Products.product_id
GROUP BY   
    Products.product_id, Products.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT 
    Users.user_id,
    Users.username,
    SUM(Orders.total_amount) as total_amount_spent
FROM
    Users 
LEFT JOIN  
    Orders ON Users.user_id = Orders.user_id
GROUP BY
    Users.user_id, Users.username
ORDER BY
-- reorder to sort from high to low 
    total_amount_spent DESC
-- limit 5 to get top 5
LIMIT 5;


