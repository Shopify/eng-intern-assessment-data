-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

select * from products
where category_id=8;

-- Alternatively this will allow you to search by a string by joining with the categories table

select * from categories join products on categories.category_id = products.category_id
where category_name = 'Sports & Outdoors';




-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders

-- We group by user id to see how many orders there are per id
-- Note that to test this, it was necessary to change the data so that there was
-- at least one user with no orders, and at least one with more than 1 order.
-- Going forward the data was modified several times for testing

select users.user_id, users.username, count(orders.order_id) num_orders
from users left join orders on users.user_id = orders.user_id
group by users.user_id
-- The order is changed, so this fixes that
order by users.user_id;




-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- This is very similar the the previous one, we use average instead of count, and we
-- join reviews and products, with products on the left.

select products.product_id, products.product_name, avg(reviews.rating) avg_review
from products left join reviews on products.product_id = reviews.product_id
group by products.product_id
order by products.product_id;




-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Again this is very similar the the last one, this time we are summing the total order
-- amount, and sorting by it, then taking the top 5

select users.user_id, users.username, sum(orders.total_amount) total_spent from
users left join orders on users.user_id = orders.user_id
group by users.user_id
-- Note that we must put nulls last, otherwise they will be on top
order by total_spent desc nulls last
limit 5;

-- Also note that users with the same total spending may be sorted arbitrarily here,
-- so they may get cut off even though they are technically in the top 5.
-- We could use a WHERE statement and a comparison to determine which users have at least the amount
-- spent as the 5th highest spender, and list all of them, but I 
-- figure the intent of the query is to only return 5 users.