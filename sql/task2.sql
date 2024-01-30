-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT
    product_id,
    product_name,
    average_rating
FROM (
    SELECT 
        product_id,
        product_name,
        AVG(rating) AS average_rating
    FROM Products P
    INNER JOIN Reviews ON Reviews.product_id = Products.product_id
    GROUP BY P.product_id;
) AS T
ORDER BY average_rating DESC
LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT
    user_id,
    username
FROM (
    SELECT 
        user_id,
        username,
        COUNT(DISTINCT category_name) AS distinct_categories
    FROM
            Users
            JOIN Orders ON Orders.user_id = Users.user_id
            JOIN Order_Items ON Order_Items.order_id = Orders.order_id
            JOIN Products ON Products.product_id = Order_Items.product_id
            JOIN Products ON Products.category_id = Categories.category_id
            GROUP BY user_id
) AS T
WHERE distinct_categories = (SELECT 
                                COUNT(DISTINCT category_id) 
                                FROM Categories)

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT 
    product_id,
    product_name
FROM 
    Products
WHERE product_id NOT IN (SELECT 
                            DISTINCT product_id 
                            FROM Reviews)

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT
    user_id,
    username
FROM
    Users
    JOIN Orders O1 ON user_id = O1.user_id
    JOIN Orders O2 ON user_id = O2.user_id AND O1.order_date = DATE_ADD(O2.order_date, INTERVAL 1 DAY);