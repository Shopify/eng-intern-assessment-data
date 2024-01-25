# Data Engineer Intern Assessment

Welcome to the Data Engineer Intern assessment for Shopify! This assessment is designed to evaluate your skills in SQL, data manipulation, and problem-solving. Please follow the instructions below to complete the assessment.

## Dataset

The assessment is based on a simulated dataset containing sales information from an e-commerce platform. The dataset is provided in the `/data` directory as a number of CSV files named `<table-name>_data.csv`. These dataset includes columns such as `product_id`, `sales_amount`, `customer_id`, etc.

## Instructions

1. **Fork the Repository:** Start by forking this repository to your local machine.
2. **Create a new Branch:** Create a new branch to store your work in.
3. **Data Understanding:** Review the `schema.sql` file and data `.csv` files and understand its structure and columns.
4. **Write SQL Queries:** Create SQL files (`task1.sql`, `task2.sql`, `task3.sql`) in the `/sql` directory to solve each task mentioned above.
5. **Submit your Work:** Once completed, create a pull request with your changes to the Shopify `main` branch and submit the link to your PR

## Notes

- Ensure your SQL files contain clear and commented queries for each task.
- Use the provided datasets (`<table-name>_data.csv`) for all tasks.
- Feel free to ask any clarifying questions by creating an issue in this repository.

Good luck, and we look forward to reviewing your work!

## Notes from the candidate

- To facilitate ingesting the data into an SQLite database, I've made `load_data.py` which takes in all the CSVs, does a bit of data formatting, and then creates the database with the data in it.
- I've slightly modified some of the data in the CSV files to test more edge cases (e.g. a user having 0 orders, or multiple). These changes are in effect in the files on this branch.
