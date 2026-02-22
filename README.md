## Solution & Reflection
My solution for the Shopify Data Engineering Intern Assessment introduces significant improvements to the SQL queries. Specifically, modifications have been made to the task1.sql, task2.sql, and task3.sql files to address distinct queries derived from the provided schema.sql. My methodology involved leveraging diverse SQL techniques, such as GROUP BY, JOIN, and aggregate functions, to effectively respond to these questions. 

## Testing:
To ensure the precision and efficacy of the SQL queries, adjustments were applied to the test_sql_queries.py file. These modifications encompass the addition of comprehensive test cases for each main task. 

## Limitation: 
The Products table in the database comprises only 16 product IDs, posing a potential challenge during data insertion into related tables such as order_items, reviews, or cart_items. This complexity arises from the FOREIGN KEY constraint within these tables, mandating that every product_id reference must preexist in the Products table. Consequently, if entries in  order_items, reviews, or cart_items exceed 16, it leads to a violation of the foreign key constraint, triggering an error.

# Data Engineer Intern Assessment

Welcome to the Data Engineer Intern assessment for Shopify! This assessment is designed to evaluate your skills in SQL, data manipulation, and problem-solving. Please follow the instructions below to complete the assessment.

## Dataset

The assessment is based on a simulated dataset containing sales information from an e-commerce platform. The dataset is provided in the `/data` directory as a number of CSV files named `<table-name>_data.csv`. These dataset includes columns such as `product_id`, `sales_amount`, `customer_id`, etc.

## Instructions

1. **Fork the Repository:** Start by forking this repository to your local machine.
2. **Create a new Branch:** Create a new branch to store your work in 
3. **Data Understanding:** Review the `schema.sql` file and data `.csv` files and understand its structure and columns.
4. **Write SQL Queries:** Create SQL files (`task1.sql`, `task2.sql`, `task3.sql`) in the `/sql` directory to solve each task mentioned above.
5. **Submit your Work:** Once completed, create a pull request with your changes to the Shopify `main` branch and submit the link to your PR

## Notes

- Ensure your SQL files contain clear and commented queries for each task.
- Use the provided datasets (`<table-name>_data.csv`) for all tasks.
- Feel free to ask any clarifying questions by creating an issue in this repository.

Good luck, and we look forward to reviewing your work!
