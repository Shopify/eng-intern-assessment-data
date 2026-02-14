/* Shopify Data Engineer Intern Assessment - Joseph (Jihyung) Lee */

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

/*  Comment: Assumed we are permitted to display all columns within the Products table. */
SELECT * 
FROM Products AS p
WHERE p.category_id =
(
    SELECT c.category_id
    FROM Categories AS c
    WHERE c.category_name = 'Sports & Outdoors'
);

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT
    u.user_id,  -- User ID
    u.username, -- Username
    -- COUNT function used to count the total # of orders per user
    COUNT(o.order_id) AS total_num_of_ordersq   -- Total number of orders 
FROM
    -- Join Users and Orders tables for query to output the correct columns
    Users as u,
    Orders as o
WHERE
    u.user_id  = o.user_id
GROUP BY
    -- Group by User ID to permit use of aggregate function on SELECT 
    u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

/*  Comment: Assumed that the average rating can be presented as floats. */
SELECT
    p.product_id,   -- Product ID
    p.product_name, -- Product Name
    -- For neat presentation, the avg. rating is rounded to 2 decimal points.
    ROUND(AVG(r.rating), 2) AS average_rating   -- Average rating
FROM
    -- Join Reviews and Products tables for query to output the correct columns
    Reviews AS r,
    Products as p
WHERE
    r.product_id = p.product_id
GROUP BY
    -- Group by Product ID to permit use of aggregate function on SELECT
    r.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT
    u.user_id,  -- User ID
    u.username, -- Username
    -- SUM function used to calculate TOTAL amount spent on orders, per user
    SUM(total_amount) AS total_amount_spent -- Total amount spent
FROM
    -- Join Users and Orders tables for query to output the correct columns
    Users as u,
    Orders as o
WHERE
    u.user_id = o.user_id
GROUP BY
    -- Group by User ID to permit use of aggregate function on SELECT, and obtain TOTAL num of orders per user
    o.user_id
-- Sort in descending order, and limit by 5 to obtain top 5 users
ORDER BY
    total_amount_spent DESC LIMIT 5;