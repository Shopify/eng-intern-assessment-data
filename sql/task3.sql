-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select per_category.category_id, categories.category_name, per_category.total_amount_per_category from
(
    -- This subquery takes the total amounts per item, and sums them per category
	select per_product.category_id, sum(per_product.total_amount_per_product) as total_amount_per_category from
	(
        -- This subquery multiplies quantity and unit price for each item order, then joins twice to get
        -- the category name for that item as well
		select (order_items.quantity * order_items.unit_price) as total_amount_per_product, products.category_id from
		orders
		left join order_items on orders.order_id = order_items.order_id
		left join products on order_items.product_id = products.product_id
	) as per_product
	group by per_product.category_id
) as per_category
-- Then we join with categories to get the name, then order, and take top 3
left join categories on per_category.category_id = categories.category_id
order by total_amount_per_category desc nulls last
limit 3;




-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


select users.user_id, users.username from
(
    -- This subquery returns how many unique games each user has purchased
	select orders.user_id, count(distinct order_items.product_id) as distinct_games from order_items
	left join orders on orders.order_id = order_items.order_id
	left join products on products.product_id = order_items.product_id
	left join categories on categories.category_id = products.category_id
	where categories.category_name = 'Toys & Games'
	group by orders.user_id
) as user_games_counts
left join users on user_games_counts.user_id = users.user_id
where distinct_games =
(
	-- This simply counts how many products are in the Toys & Games category
	select count(categories.category_id) from products left join categories on products.category_id = categories.category_id 
	where categories.category_name = 'Toys & Games'
);




-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- We need to use a subquery since the window operation is performed after the where clause.
-- Once we find the max, and all the products, we can simply take only the products whose prices
-- match the max price. Note that this will take all products in a category that have the same
-- price. This is intended behaviour.

select max_prices.product_id, max_prices.product_name, max_prices.category_id, max_prices.max_price as price from
(
    -- This subquery uses a window function to get the max price, for each category, while still listing all products
	select category_id, product_id, product_name, price, max(price)
	over (partition by category_id) as max_price
	from products
	order by category_id
) as max_prices
where max_prices.max_price = max_prices.price;




-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This is a more complex version of problem 8. In this case, once we have generated the
-- differences between order dates for each order per user, we have to
-- check which ones have at least two "1 day gaps" in a row.
-- We then join with users like in problem 8 and retrieve only the users ones
-- that had two orders immediately after a previous order in a row.

select distinct users.user_id, users.username
from users
left join
(
    -- This subquery includes a column which checks if the previous "days_between"
    -- was also a 1, meaning that we had three consecutive orders.
	select *, count_days.days_between = lag(count_days.days_between)
	over(partition by count_days.user_id) as three_day_order
	from
	(
        -- This subquery counts days between orders for each order. Since it is partitioned by user, we
	    -- do not include cases where user 4 ordered one day after user 3
		select orders.order_id, orders.user_id, orders.order_date, orders.order_date - lag(orders.order_date)
		over (partition by orders.user_id order by orders.order_date) as days_between
		from orders
	) as count_days
) as count_three_days
on users.user_id = count_three_days.user_id
where count_three_days.three_day_order;