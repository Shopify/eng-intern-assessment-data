-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select c.category_id, c.category_name,
    sum(oi.quantity * oi.unit_price) as total
from Categories c
inner join Products p 
on c.category_id = p.category_id
inner join Order_Items oi 
on p.product_id = oi.product_id
inner join Orders o
on oi.order_id = o.order_id
group by c.category_id, c.category_name
order by total desc
limit 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select u.user_id, u.username
from Users u
inner join Orders o 
on u.user_id = o.user_id
inner join Order_Items oi 
on o.order_id = oi.order_id
inner join Products p 
on oi.product_id = p.product_id
inner join Categories c 
on p.category_id = c.category_id
where c.category_name = 'Toys & Games'
group by u.user_id
having count(distinct oi.product_id) = (select count(*) 
                                        from Products p
                                        left join Categorues c
                                        on p.category_id = c.category_id
                                        where c.category_id = 'Toys & Games');


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with ranking as 
    (select product_id, product_name, category_id, price, rank() over (partition by category_id order by price desc) as rank
    from Products)
select product_id, product_name, category_id, price
from ranking 
where rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with tmp as 
    (select user_id,order_date,
        LAG(order_date, 1) over (partition by user_id order by order_date) as prev,
        LAG(order_date, 2) OVER (partition by user_id order by order_date) AS pprev
    from Orders)
select distinct u.user_id, u.username
from Users u
left join tmp
on u.user_id = tmp.user_id
where DATEDIFF(day, order_date, prev) = 1 and DATEDIFF(day, pprev, prev) = 1;