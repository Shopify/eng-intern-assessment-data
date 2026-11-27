-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- We use a CTE of the previous problem so that we can reference it twice

with avg_reviews as
(
    -- This is a table of the average reviews of each product
	select products.product_id, products.product_name, avg(reviews.rating) avg_review
	from products left join reviews on products.product_id = reviews.product_id
	group by products.product_id
	order by avg_review desc nulls last
)
-- Then we take all rows for which the average review is equal to the maximum average review
select * from avg_reviews
where avg_reviews.avg_review = 
(
	select max(avg_review) from avg_reviews
);




-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- I wasn't 100% sure what the question meant by one order in each category, I decided to retrieve
-- all users that had ordered at least one item in each category.
-- Although I suppose it could mean all users which had, for every category, a distinct order with an
-- item of that category in that order.

-- I assume that category_id is distinct


select users.user_id, users.username from
(
    -- By left joining onto order_items, we get a table of all items ordered, which we then
    -- group by user_id to count the number of distinct product categories for each user.
	select orders.user_id, count(distinct products.category_id) num from order_items
	left join products on products.product_id = order_items.product_id
	left join orders on orders.order_id = order_items.order_id
	group by orders.user_id
) as unique_counts
-- We now have the counts for each user, so we can see which ones
-- have a count equal to the total number of categories
left join users on users.user_id = unique_counts.user_id
where unique_counts.num = 
(
    select count (category_id) from categories
);




-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- This one is quite straightforward. On a left join with reviews we will have
-- null values if there are no reviews to join with.

select products.product_id, products.product_name from products
left join reviews on products.product_id = reviews.product_id
where review_id is null;




-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- We count the number of days between each order for each user and then
-- select the users which have at least one order that directly proceeded the
-- previous one.

select distinct users.user_id, users.username from 
users left join
(
	-- This subquery counts days between orders for each order. Since it is partitioned by user, we
	-- do not include cases where user 4 ordered one day after user 3
	select orders.order_id, orders.user_id, orders.order_date, orders.order_date - lag(orders.order_date)
	over (partition by orders.user_id order by orders.order_date) as days_between
	from orders
) as count_days
on count_days.user_id = users.user_id
where count_days.days_between = 1;