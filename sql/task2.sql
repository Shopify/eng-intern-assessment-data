-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
with rating as 
    (select product_id, AVG(rating) as rate
    from Reviews
    group by product_id)
select p.product_id, p.product_name, r.rate
from Products p
inner join rating r
on p.product_id=r.product_id
where r.rate = (select max(rate) from rating);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

select u.user_id, u.username
from Users u
inner join Orders o
on u.user_id = o.user_id
inner join Order_Items oi
on o.order_id = oi.order_id
inner join Products p
on oi.product_id = p.product_id
group by u.user_id
having count(distinct p.category_id) = (select count(category_id) from Category)


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
select p.product_id, p.product_name
from Products p 
left join Reviews r 
on p.product_id = r.product_id
where r.review_id is null;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
with consec as
    (select user_id, order_date,
        LAG(order_date) over (partition by user_id order by order_date) as prev
    from Orders)
select distinct c.user_id, u.username
from consec c
inner join Users u 
on c.user_id = u.user_id
WHERE datediff(day, c.order_date, c.prev) = 1;