-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

select p.product_id,
p.product_name 
from Products as p
join Categories  as c
on c.category_id=p.category_id
where category_name like '%Sports%'; --Category name can be changed and also the filter will be applied wherever the term is found

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

select o.user_id,
u.username, 
total_orders
from 
(
	select user_id, 
	count(order_id) as total_orders 
	from Orders
	group by user_id
) as o
inner  join Users as u
on u.user_id=o.user_id;



-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

select r.product_id,
p.product_name,
average_rating  
from(
	select product_id, 
	round(AVG(rating),2) as average_rating  --Rounding the values of average
	from Reviews
	group by product_id
) as r
join Products as p
on p.product_id=r.product_id; 

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.


with rank_cust_spend as
(
	select user_id,
	sum(total_amount) as total_amount_spent,
	ROW_NUMBER() OVER (ORDER BY  sum(total_amount)  DESC) AS rank_num --assigning row numbers to users 
    from Orders
	group by user_id
)


select r.user_id,
u.username,
r.total_amount_spent
from rank_cust_spend as r
join Users as u
on r.user_id=u.user_id
where r.rank_num<6; 
