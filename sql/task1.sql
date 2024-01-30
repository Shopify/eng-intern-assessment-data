-- Problem 1:
-- Question: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
--
-- Main Query:
-- Selects all columns (p.*) from the 'Products' table.
-- Uses a LEFT JOIN to include all products from the 'Products' table, and matching categories from the 'Categories' table based on the category_id.
-- LEFT JOIN:
-- Connects rows from 'Products' to 'Categories' based on the common column category_id.
-- Products that do not have a matching category will still be included in the result with NULL values for category-related columns.
-- WHERE clause:
-- Filters the result to include only rows where the lowercase category_name from the 'Categories' table contains the substring 'sports'.
-- The LIKE operator with % is used for a partial match, and LOWER() is used to perform a case-insensitive comparison.
--
-- Main query to select products from the 'Products' table based on a left join with 'Categories'
SELECT p.* FROM Products p   -- Selects all columns from the 'Products' table
    LEFT JOIN Categories c
        ON p.category_id=c.category_id  ---- Left join with 'Categories' table
    WHERE LOWER(c.category_name) like '%sports%'  -- Filters products where the category name contains 'sports' in a case-insensitive manner

-- Problem 2:
-- Question: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
--Main Query:
-- Selects the user_id and username from the 'Users' table.
-- Counts the number of orders for each user using the COUNT() function on the order_id.
-- Uses a JOIN operation to connect rows from 'Users' to 'Orders' based on the common column user_id.
-- JOIN clause:
-- Connects rows from 'Users' to 'Orders' based on the common column user_id.
-- GROUP BY clause:
-- Groups the results by user_id, so the count of orders is calculated for each user separately.
--
-- Main query to count the number of orders for each user
SELECT u.user_id, u.username, count(o.order_id) FROM Users u
    JOIN Orders o
        ON u.user_id=o.user_id  -- Joining Users and Orders tables based on user_id
    GROUP BY u.user_id          -- Grouping the results by user_id

-- Problem 3:
-- Question: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
-- Main Query:
-- Selects the product_id and product_name from the 'Products' table.
-- Calculates the average rating for each product using the AVG() function on the rating column from the 'Reviews' table.
-- Uses a JOIN operation to connect rows from 'Products' to 'Reviews' based on the common column product_id.
-- JOIN clause:
-- Connects rows from 'Products' to 'Reviews' based on the common column product_id.
-- GROUP BY clause:
-- Groups the results by product_id, so the average rating is calculated for each product separately.
--
-- Main query to calculate the average rating for each product based on reviews
SELECT r.product_id, p.product_name, AVG(r.rating) FROM Products p
    JOIN Reviews r
        ON p.product_id=r.product_id  -- Joining Products and Reviews tables based on product_id
    GROUP BY r.product_id             -- Grouping the results by product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
--
-- Main Query:
-- Selects the user_id and username from the 'Users' table.
-- Calculates the total amount spent by each user using the SUM() function on the total_amount column from the 'Orders' table.
-- Uses a JOIN operation to connect rows from 'Users' to 'Orders' based on the common column user_id.
-- JOIN clause:
-- Connects rows from 'Users' to 'Orders' based on the common column user_id.
--
-- Groups the results by user_id and username, so the total amount is calculated for each user separately.
-- Orders the results in descending order based on the total amount (3 represents the position of the SUM(o.total_amount) expression in the SELECT list).
-- Limits the result set to the top 5 users by total amount spent.
--
-- Main query to calculate the total amount spent by each user and limit the result to the top 5 users by total amount
SELECT u.user_id, u.username, sum(o.total_amount) FROM Users u
    JOIN Orders o
        ON u.user_id=o.user_id          -- Joining Users and Orders tables based on user_id
    GROUP BY u.user_id, u.username      -- Grouping the results by user_id and username
    ORDER BY 3 DESC                     -- Ordering the results in descending order based on total amount
    LIMIT 5                             -- Limit the result to the top 5 users by total amount











