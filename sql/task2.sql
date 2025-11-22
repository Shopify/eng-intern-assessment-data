-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
        
        SELECT review_data.product_id, product_data.product_name, AVG(review_data.rating) AS average_rating
        FROM review_data JOIN product_data ON review_data.product_id = product_data.product_id
        GROUP BY review_data.product_id
        ORDER BY average_rating DESC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

        SELECT user_data.user_id, user_data.username
        FROM user_data
        WHERE user_data.user_id IN (
            SELECT DISTINCT user_data.user_id
            FROM user_data
            JOIN order_data ON order_data.user_id = user_data.user_id
            JOIN order_items_data ON order_items_data.order_id = order_data.order_id
            JOIN product_data ON order_items_data.product_id = product_data.product_id
            JOIN category_data ON product_data.category_id = category_data.category_id
            -- check the number of categories in the category_data table if is the same as the number of categories the user has ordered from
            GROUP BY user_data.user_id HAVING COUNT(DISTINCT category_data.category_id) = (SELECT COUNT(DISTINCT category_id) FROM category_data)
        );

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
        
        SELECT review_data.product_id, product_data.product_name, count(review_data.rating) AS number_of_reviews -- count the number of reviews for each product
        FROM review_data RIGHT JOIN product_data ON review_data.product_id = product_data.product_id
        GROUP BY review_data.product_id, product_data.product_name
        -- only show products with no reviews
        HAVING number_of_reviews = 0; 
  

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
    
    SELECT DISTINCT user_data.user_id, user_data.username
    FROM order_data
    JOIN user_data ON order_data.user_id = user_data.user_id
    -- check conditions for consecutive orders on consecutive days
    WHERE EXISTS (
        SELECT 1
        FROM order_data AS o1
        JOIN order_data AS o2 ON o1.user_id = o2.user_id
        -- check if there is any consecutive order dates
        WHERE o1.order_date = DATE_SUB(o2.order_date, INTERVAL 1 DAY)
        -- check to make sure that order_id is not the same
        AND o1.order_id <> o2.order_id
        AND o1.user_id = order_data.user_id
    );
