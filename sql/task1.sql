-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

select *
from `Products` p, `Categories` c
where
    p.category_id = c.category_id
    and c.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

/* select user_id, username, count(order_id) as total_orders from order_data */
select
    order_data.user_id,
    username,
    count(*) as total_orders
    from `Orders` order_data
    LEFT JOIN `Users` user_data ON order_data.user_id = user_data.user_id
    group by order_data.user_id, username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

select
    review_data.product_id,
    product_name,
    avg(rating) as average_rating
from `Reviews` review_data
LEFT JOIN `Products` product_data ON review_data.product_id = product_data.product_id
group by product_id, product_name;

    -- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
    -- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
    -- The result should include the user ID, username, and the total amount spent.

SELECT
    u.user_id,
    u.username,
    SUM(o.total_amount) AS total_amount_spent
FROM
    `Orders` o 
left JOIN
    `Users` u ON u.user_id = o.user_id
GROUP BY
    u.user_id, u.username
ORDER BY
    total_amount_spent DESC
LIMIT 5;
