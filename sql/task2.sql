-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
with avg_ratings as (
	select p.product_id, p.product_name, avg(r.rating) as avg_rating
	from products p, reviews r 
	where p.product_id = r.product_id
	group by p.product_id
) 
select ar.product_id, ar.product_name, ar.avg_rating
from avg_ratings ar
where ar.avg_rating = (
	select max(ar.avg_rating) -- get the max value from the avg_ratings CTE above
	from avg_ratings ar
);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
select u.user_id, u.username
from users u
join orders o on u.user_id = o.user_id 
join order_items oi on o.order_id = oi.order_id 
join products p on oi.product_id = p.product_id 
group by u.user_id
having count(distinct p.product_id) = (
	select count(c.category_id) 
	from categories c
);



-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
select p.product_id, p.product_name 
from products p 
where p.product_id	
	not in (
		select r.product_id 
		from reviews r
	);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
select distinct ua.user_id, ua.username
from (
	select u.user_id, u.username, -- return the id and username paired with the date difference per order
		datediff(o.order_date, lag(o.order_date, 1) over (partition by u.user_id order by o.order_date)) as diff
	from users u, orders o 
	where u.user_id = o.user_id 
) ua
where ua.diff is not null and ua.diff = 1 -- only return if it was one consequtive day
	