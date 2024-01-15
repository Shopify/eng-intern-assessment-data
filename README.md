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

# Walkthrough Solution:

### 1. Understanding Table Schema:

Using the file schema.sql relationships in between the tables can be identified. For instance `products` table has relation with `categories`, while `orders`, `reviews`, and `cart` tables have relation with `users` table. These would be important for JOIN operations.

### 2. Understanding the Data:

It is important to learn about data before ingestion. Here are some important information that were noted before making any decisions:

- 1. The data for this test is all available in csv format which is a structured data format, and fortunately, SQL works best with structured data.
- 2. The size of the data files are fairly small, indicating a small number of records. This makes it easy to ingest and work with the data. For this particular reason, simply MySQL workbench is used to ingest the data. It is worth noting that MySQL workbench is considerably slow for big data, however, this is not an issue for this test.
- 3. By a quick look at the data files (they are not that many therefore easy to read), it is clear that the data is clean and well-structured.

### 3. Data Ingestion and Database Creation:

As mention before, the data is imported using MySQL workbench. Alternatives like using the computer's terminal or python scripts would also work perfectly fine.

A database is set up and tables are conveniently created using the make_db.sql using MySQL. Subsequently, the data is imported into the tables using MySQL workbench import wizard. It is important to note that the tables should be populated in a particular order, avoiding any foreign key constraints.

### 4. Queries:
