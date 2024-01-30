-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- select product id, product name and the average
SELECT prod.product_id, prod.product_name, avg(rating) as avg_rating
	from products prod, reviews rev 
	where prod.product_id = rev.product_id 
	group by prod.product_id 
	order by avg_rating desc 
	limit 5; --limit to 5 responses for postgres

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- select userid, username from a joined query 
SELECT usrs.user_id, usrs.username 
from products prod, users usrs, orders ords, order_items ord_items, categories cat
where usrs.user_id = ords.user_id --verify user id is the same
and ords.order_id = ord_items.order_id  -- verify order id is the same
and prod.product_id = ord_items.product_id -- verify product id is the same
and prod.category_id = cat.category_id -- verify category id is the same
group by usrs.user_id --group by user_id
having count(distinct cat.category_id) = 
(
	-- aggregate function to determine the number of users who have made at least one order
	select count(distinct cat.category_id)
	from categories cat
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- select all the products which have review_id set to null
SELECT prod.product_id, prod.product_name 
from products prod 
left join reviews rev on prod.product_id=rev.product_id -- use left join as suggested
where rev.review_id is NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- here we will search for and return using DATE_PART to get interval
select usrs.user_id, usrs.username 
from users usrs, orders ords1, orders ords2 
where usrs.user_id = ords1.user_id 
and usrs.user_id =  ords2.user_id
and DATE_PART('day', ords2.order_date) - DATE_PART('day', ords1.order_date) = 1
and ords2.order_id != ords1.order_id; -- remove duplicates