
# 🤗 Introduction to My Shopify Data Engineering Intern Assessment Solution

Welcome to the GitHub repository for my solution to the Shopify Data Engineering Intern Assessment. This project showcases my approach to the challenging and exciting problems presented in the assessment. As an aspiring data engineer, I have employed a combination of Python programming, MySQL queries, and innovative problem-solving techniques to address the tasks at hand. My solution aims to demonstrate not only technical proficiency but also a clear understanding of data engineering principles and practices. 

## 🆕 Changes Made:
In this update to the Shopify Data Engineering Intern Assessment solution, significant enhancements have been made to the SQL queries. The files `task1.sql, task2.sql, and task3.sql` address specific questions that arise from the provided `schema.sql`. My approach involved utilizing various SQL techniques such as `GROUP BY`, `JOIN`, and others to answer these questions effectively.

## 🧪 Testing:
To ensure the accuracy and efficiency of the SQL queries, modifications were made to the `test_sql_queries.py` file. These changes include the addition of comprehensive test cases for each task file. The successful execution of these tests confirms the reliability and correctness of the queries in line with the assessment requirements. This thorough testing process not only validates the functionality of the queries but also ensures they meet the specified criteria in the assessment.

## 🔑 Violating Foreign Key Constraints

### Overview
In the specified database schema, there are multiple tables (Order_Items, Reviews, and Cart_Items) that reference the `product_id` column from the `Products` table as a foreign key.

### Schema Definition
```sql
CREATE TABLE Order_Items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10, 2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Reviews (
  review_id INT PRIMARY KEY,
  user_id INT,
  product_id INT,
  rating INT,
  review_text TEXT,
  review_date DATE,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Cart_Items (
  cart_item_id INT PRIMARY KEY,
  cart_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
```

## ⚠️ Issue/ Limitation
The `Products` table contains only 16 product IDs. Consequently, inserting data into any of the tables (Order_Items, Reviews, or Cart_Items) that reference the `product_id` from the `Products` table can cause an issue. This is because the FOREIGN KEY constraint in these tables enforces that every `product_id` referenced must already exist in the `Products` table. However, if there are more than 16 entries in the Order_Items, Reviews, and Cart_Items tables, this leads to a violation of the foreign key constraint, resulting in an error.

## ✅ Solution
The issue was resolved by truncating the size of the Order_Items, Reviews, and Cart_Items tables to 17 entries, ensuring that no invalid `product_id` references occur.