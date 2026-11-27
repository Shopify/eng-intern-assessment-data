-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- **********Explanation**********:

-- The query written below is a generic SQL which can be applied to retrieving all products in any
-- category by simply changing the '%sports%' value.
SELECT P.*
FROM Products AS P
INNER JOIN Categories AS C ON P.category_id = C.category_id
WHERE lower(C.category_name) Like '%sports%';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- **********Explanation**********:

-- Join the relevant tables with Users to find the orders of each user. Then use the COUNT function
-- to get the total number of orders for each user.
SELECT U.user_id, U.username, COUNT(O.order_id) AS total_orders
FROM Users AS U 
LEFT JOIN Orders AS O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- **********Explanation**********:

-- Join the relevant tables using left join on product since a review cannot exist without a product.
-- Then use the AVG aggregate function to calculate the average rating for each product
SELECT P.product_id, P.product_name, AVG(R.rating) AS avergage_rating
FROM Products AS P 
LEFT JOIN Reviews AS R ON P.product_id = R.product_id
GROUP BY 1,2


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- **********Explanation**********:

-- Join the relevant tables and use the SUM aggregate function to sum the amount for each user.
-- Then use the GROUP_BY clause to group by user and order users descendingly for total amount spend.
-- use the limit clause to return the top 5 users.
SELECT U.user_id, U.username, SUM(O.total_amount) AS total_amount_spent
FROM Users AS U
INNER JOIN Orders AS O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username
ORDER BY total_amount_spent DESC
LIMIT 5;
