use schema_name;
-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Here it starts to get much more tricky. We now need to use CTEs as the hint states, though we have already used
-- sub-queries. To do this we are going to create our own sub-query called ranks, that will return us a table containing
-- the ranks of each of the averages of the products. This is done by passing the RANK() over the descending ordered
-- average list. This could be done with limits, to get the top x number of average ratings, but we would have no way
-- of calculating ties like we can here.

WITH ranks AS (SELECT products.product_id, products.product_name, AVG(reviews.rating) AS average_rating,
    RANK() OVER (ORDER BY AVG(reviews.rating) DESC) AS rating_rank FROM products JOIN
    reviews ON products.product_id = reviews.product_id GROUP BY products.product_id, products.product_name)

SELECT product_id, product_name, average_rating FROM ranks WHERE rating_rank = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Here we just need to use some more sub-queries instead of CTEs, we also see many joins (inner) here. All of the joins
-- are just to connect the tables together via their shared characteristics so that we can pull all of the necessary
-- data into the query so we can successfully run our group by's and counts on them. With our first time using having here,
-- we just ensure that the counts of the distinct number of category id's is the same number as the count of the distinct
-- GROUPED results in the previous line, since they are also grouped by category id

SELECT users.user_id, users.username FROM users
    JOIN orders ON users.user_id = orders.user_id
    JOIN order_items ON orders.order_id = order_items.order_id
    JOIN products ON order_items.product_id = products.product_id
    JOIN categories ON products.category_id = categories.category_id
    GROUP BY users.user_id, users.username, categories.category_id
    HAVING COUNT(DISTINCT categories.category_id) = (SELECT COUNT(DISTINCT category_id));

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- This one seems like it is too easy for its place in the tasks, but after a lot of testing, it does seem to work...
-- The other possible method would be using a left join on product id's from reviews and products tables, and seeing
-- if the results are ever NULL. That may be more efficient but this is definitely less code.
-- To explain it, all it is is seeing if the product id from products ever doesnt occur in reviews

SELECT product_id, product_name FROM products WHERE product_id NOT IN (SELECT product_id FROM reviews);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- For this one we really used all we have learned and more! For this, we used the window function lag to get, in this
-- case the date before the current date, so we could compare them. The lag is done over the window which in this case
-- is each individual user id (partition breaks it up into individual sets) which is taken from the orders table inner
-- joined on the orders table by user id, to once again combine the tables, so we could run the lag over it.
-- We than used this CTE to just compare the value we made with the lag (previous_date) with the order date using
-- datediff to ensure that it was only one day apart. I also printed the two days out for fun to show proof that it works.
WITH consecutiveOrders AS (SELECT user_id, username, order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date
    FROM (SELECT users.user_id, users.username, orders.order_id, orders.order_date FROM users JOIN
    orders ON users.user_id = orders.user_id) AS orders)

SELECT DISTINCT user_id, username, order_date AS repitition_day_one, previous_date
    AS repitition_day_two FROM consecutiveOrders WHERE DATEDIFF(order_date, previous_date) = 1;

