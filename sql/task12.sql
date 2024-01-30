-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderedDates AS (
  SELECT
    user_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
    LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
  FROM
    Orders
),
ConsecutiveOrders AS (
  SELECT
    user_id,
    order_date,
    CASE
      WHEN order_date = prev_order_date + INTERVAL '1 day' OR
           order_date = next_order_date - INTERVAL '1 day' THEN 1
      ELSE 0
    END AS is_consecutive
  FROM
    OrderedDates
),
ConsecutiveGroups AS (
  SELECT
    user_id,
    SUM(is_consecutive) OVER (PARTITION BY user_id ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS consecutive_days
  FROM
    ConsecutiveOrders
)
SELECT DISTINCT
  U.user_id,
  U.username
FROM
  Users U
JOIN
  ConsecutiveGroups CG ON U.user_id = CG.user_id
WHERE
  consecutive_days >= 2;
