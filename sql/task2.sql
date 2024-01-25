-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
with temp_table as (
    select p.product_id, p.product_name, round(avg(r.rating):: numeric, 1) as average_rating 
    from products as p 
    join reviews as r 
    on p.product_id = r.product_id 
    group by p.product_id
) 
select * 
from temp_table 
group by product_id, product_name, average_rating 
having average_rating = (
    select max(average_rating) 
    from temp_table
);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
select u.user_id, u.username
from users as u
join orders as o 
on u.user_id = o.user_id
join order_items as oi 
on o.order_id = oi.order_id
join products as p 
on oi.product_id = p.product_id
join categories as c 
on p.category_id = c.category_id
group by u.user_id, u.username
having count(distinct c.category_id) = (
       select count(*) from categories
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
select p.product_id, p.product_name 
from products as p 
where p.product_id not in (
    select r.product_id 
    from reviews as r
);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
select distinct u.user_id, u.username
from users as u
join orders as o1 on u.user_id = o1.user_id
join orders as o2 on u.user_id = o2.user_id
where o1.order_date <> o2.order_date
and ((o1.order_date - o2.order_date = interval '1 day') 
or (o2.order_date - o1.order_date = interval '1 day'));
