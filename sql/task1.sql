-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

    -- select all columns from the product_data table and the category_name column from the category_data table
    SELECT product_data.*, category_data.category_name
    FROM product_data
    LEFT JOIN category_data -- join the product_data table to the category_data table
    ON product_data.category_id = category_data.category_id -- join on the category_id column
    WHERE category_data.category_name = 'Sports & Outdoors' -- check the category name is correct
    ;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
    
    SELECT DISTINCT user_data.user_id, user_data.username, COUNT(*) AS total_number_of_orders
    FROM user_data
    INNER JOIN order_data ON order_data.user_id = user_data.user_id
    GROUP BY user_data.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
    
    SELECT review_data.product_id, product_data.product_name, AVG(review_data.rating) AS average_rating
    FROM review_data
    INNER JOIN product_data
    ON review_data.product_id = product_data.product_id
    GROUP BY review_data.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
    
    SELECT user_data.user_id, user_data.username, SUM(order_data.total_amount) AS total_spent
    FROM order_data
    JOIN user_data ON order_data.user_id = user_data.user_id
    GROUP BY user_data.user_id 
    ORDER BY total_spent DESC
    LIMIT 5;
