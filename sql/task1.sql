-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
select * 
from products 
where category_id in (
    select category_id 
    from Categories 
    where category_name like "%Sports%"
);

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
select u.user_id, u.username, count(o.order_id) as total_orders 
from users as u 
join orders as o 
on u.user_id = o.user_id 
group by u.user_id;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
select p.product_id, p.product_name, round(avg(r.rating)::numeric, 1) as average_rating 
from products as p 
join reviews as r 
on p.product_id = r.product_id 
group by p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
select u.user_id, u.username, sum(o.total_amount) as total_amount_spent 
from users as u 
join orders as o 
on u.user_id = o.user_id 
group by u.user_id 
order by total_amount_spent desc 
limit 5;