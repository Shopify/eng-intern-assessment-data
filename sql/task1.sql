-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Solution 1
-- The query performs a LEFT JOIN between the Products and Categories tables, linking them through the category_id field.
-- The WHERE clause filters the output to show only those products that belong to the 'Sports & Outdoors' category.

SELECT C.category_name,
       P.*
FROM Products P
LEFT JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_name = 'Sports & Outdoors'
ORDER BY P.product_id ASC;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Solution 2
-- The query joins the Users and Orders tables using a LEFT JOIN.
-- It groups the results by user_id to aggregate order data for each individual user.
-- A COUNT function is applied on the order_id to calculate the total number of orders placed by each user.

SELECT U.user_id,
       U.username,
       COUNT(O.order_id) AS total_orders
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id
ORDER BY U.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Solution 3
-- It joins the Products and Reviews tables using a LEFT JOIN, linking each product to its reviews.
-- The AVG function calculates the average rating of each product, and this value is rounded to two decimal places.
-- Products are grouped by their product_id, which allows the AVG function to calculate the average rating per product.

SELECT P.product_id,
       P.product_name,
       ROUND(AVG(R.rating), 2) AS avg_rating
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id
ORDER BY P.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Solution 4
-- Within this CTE, the Users and Orders tables are joined on user_id.
-- The SUM() function calculates the total spending for each user by summing up the total_amount of their orders.
-- The RANK() window function is then used to assign a rank to each user based on their total spending in descending order.
-- The results are grouped by user_id.
-- The WHERE clause in the main query is used to filter the results to include only those users who rank in the top 5 in terms of total spending.

WITH UserSpendingRank AS (
    SELECT 
        U.user_id,
        U.username,
        SUM(O.total_amount) AS total_spent,
        RANK() OVER (ORDER BY SUM(O.total_amount) DESC) AS spending_rank
    FROM Users U
    JOIN Orders O ON U.user_id = O.user_id
    GROUP BY U.user_id
)
SELECT 
    user_id,
    username,
    total_spent
FROM UserSpendingRank
WHERE spending_rank <= 5;