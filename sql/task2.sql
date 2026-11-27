-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

with avg_ratings as (
    select product_id, avg(rating) as avg_rating
    from Reviews
    group by product_id
)
select p.product_id, p.product_name, a.avg_rating
from Products p
join avg_ratings a on p.product_id = a.product_id
order by a.avg_rating desc;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

select u.user_id, u.username
from Users u
where not exists (
    select 1
    from Categories c
    where not exists (
        select 1
        from Orders o
        join Order_Items oi on o.order_id = oi.order_id
        join Products p on oi.product_id = p.product_id
        where u.user_id = o.user_id and p.category_id = c.category_id
    )
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

select p.product_id, p.product_name
from Products p
left join Reviews r on p.product_id = r.product_id
where r.review_id is null;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

select distinct u.user_id, u.username
from Users u
join Orders o on u.user_id = o.user_id
join Orders o2 on u.user_id = o2.user_id
where o.order_id != o2.order_id
  and ABS(JULIANDAY(o.order_date) - JULIANDAY(o2.order_date)) = 1;
