-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Here, all data from Products table is returned, which has category ID corresponding to category name
-- 'Sports & Outdoors' in Categories table. This returns 2 rows as output.
-- Join (By default, inner join) is used instead of a nested queries as joins tend to be more efficient for
-- larger databases.
SELECT P.*
FROM Products P
JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_name='Sports & Outdoors';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Here, user_id, username and total orders made by each user is returned.
-- Inner join is used to connect Orders and users table based on the user_id column, and the group by clause
-- groups results based on user_id and username, due to which count is calculated for unique combinations of
-- user_id and username.
SELECT O.user_id, U.username, count(O.order_id) as total_orders
FROM Orders O
JOIN Users u ON O.user_id = U.user_id
GROUP BY O.user_id, U.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Here, the product_id, product_name and the average rating of the product, aliased as avg_rating is returned.
-- To trim the unnecessary 0s after decimal, I've Casted the values returned by avg(rating) such that there will
-- be a total of 3 digits, with 2 digits after decimal.
-- Inner join on reviews and products is done using the key product_id, and the group by clause
-- groups results based on product_id and product_name, due to which average is calculated for unique combinations
-- of product_id and product_name.
SELECT R.product_id, P.product_name,
CAST(AVG (rating) AS DECIMAL (3,2)) as avg_rating
FROM Reviews R
JOIN Products P ON R.product_id = P.product_id
GROUP BY R.product_id, P.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Here, returned columns are user_id, username, and the total amount each user has spent.
-- After grouping on user_id and username, the rows are order by descending value of the total amount and then
-- LIMIT 5 is used to get the 1st 5 rows, ie, the top 5 users who've spent the most.
SELECT O.user_id, U.username, sum(total_amount) AS total_amount
FROM Orders O
JOIN Users U ON O.user_id = U.user_id
GROUP BY O.user_id, U.username
ORDER BY total_amount DESC
LIMIT 5;