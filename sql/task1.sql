-- Changes: swapped order_id and product_id in order_items_data.csv to fix foreign key error
--          modified cart_item_data.csv and review_data.csv to remove non-extant products
--


-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
    -- source data from Products and Categories
    -- The Sports category is listed as 'Sports & Outdoors'
    -- We will be doing a name-based search.
    -- Since no attributes are specified, we include all attributes
    SELECT * FROM Products NATURAL JOIN Categories WHERE category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
    -- source data from Orders and Users (this includes users with zero orders)
    -- includes user ID, username; total number of orders is under attribute order_count
    -- sorted by descending order count
    SELECT users.user_id, username, COUNT(order_id)
    -- We left join orders to users since we need to show users with zero orders
    AS order_count FROM Users LEFT JOIN Orders ON Orders.user_id = Users.user_id GROUP BY users.user_id, username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
    -- source data from Products and Reviews
    -- TODO Question: how should we handle products without any reviews? Should it be excluded? Rated as 0.0?
    -- They're excluded from this query
    SELECT product_id, product_name, AVG(rating) AS average_rating FROM Products NATURAL JOIN Reviews GROUP BY product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
    -- source data from Orders and Users
    -- will want to order as descending with a limit of 5 tuples displayed
    SELECT user_id, username, SUM(total_amount) AS total_spent FROM Orders NATURAL JOIN Users GROUP BY user_id ORDER BY total_spent DESC LIMIT 5;
