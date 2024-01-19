import unittest
import psycopg2
import pandas as pd

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='shopify',
            user='postgres',
            password='PostgreSQL_2003',
            host='localhost',
            port='5432'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        with open('./sql/task1.sql', 'r') as file:
            # Get the 4 sql queries in task1.sql
            sql_queries = file.read().split(';')[:-1]
        
        # Store the result of each sql query in the results array
        results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            results.append(self.cur.fetchall())
        
        # Store the expected result of each problem in the expected_results array    
        expected_results = []
        
        # Finding the expected result for Task 1 Problem 1 by data manipulation using pandas:
        product_data = pd.read_csv('./data/product_data.csv')
        category_data = pd.read_csv('./data/category_data.csv')
            # Merge the two dataframes on the 'category_id' column
        merged_data = pd.merge(product_data, category_data, on='category_id')
            # Filter products in the 'Sports' category
        sports_products = merged_data[merged_data['category_name'] == 'Sports & Outdoors']
            # Formatting
        problem1_expected = [(row['product_id'], row['product_name'], row['description'], row['price'], row['category_id'])
                    for index, row in sports_products.iterrows()]
        expected_results.append(problem1_expected)
        
        
        # Finding the expected result for Task 1 Problem 2 by data manipulation using pandas:
        user_data = pd.read_csv('./data/user_data.csv')
        order_data = pd.read_csv('./data/order_data.csv')
            # Merge the two dataframes on the 'user_id' column
        merged_data = pd.merge(user_data, order_data, on='user_id')
            # Group by user ID and calculate the total number of orders
        problem2_expected = [(row['user_id'], row['username'], row['total_orders'])
                    for index, row in merged_data.groupby(['user_id', 'username']).size().reset_index(name='total_orders').iterrows()]
        expected_results.append(problem2_expected)
        
        
        # Finding the expected result for Task 1 Problem 3 by data manipulation using pandas:
        review_data = pd.read_csv('./data/review_data.csv')
        product_data = pd.read_csv('./data/product_data.csv')
            # Merge the two dataframes on the 'product_id' column
        merged_data = pd.merge(review_data, product_data, on='product_id')
            # Group by product ID and calculate the average rating
        problem3_expected = [(row['product_id'], row['product_name'], row['rating'])
                    for index, row in merged_data.groupby(['product_id', 'product_name']).agg({'rating': 'mean'}).reset_index().iterrows()]
        expected_results.append(problem3_expected)
        
        
        # Finding the expected result for Task 1 Problem 4 by data manipulation using pandas:
        user_data = pd.read_csv('./data/user_data.csv')
        order_data = pd.read_csv('./data/order_data.csv')
            # Merge the two dataframes on the 'user_id' column
        merged_data = pd.merge(user_data, order_data, on='user_id')
            # Group by user ID and calculate the total amount spent
        result = merged_data.groupby(['user_id', 'username']).agg({'total_amount': 'sum'}).reset_index()
            # Sort the result by total amount in descending order and get the top 5 users. If total amount is same, then username in alphabetical order is considered
        result_top5 = result.sort_values(by=['total_amount', 'username'], ascending=[False,True]).head(5)
            # Formatting the result
        problem4_expected = [(row['user_id'], row['username'], row['total_amount'])
                            for index, row in result_top5.iterrows()]
        expected_results.append(problem4_expected)

        # Check if the results array and the expected_results array are equal
        self.assertEqual(results, expected_results, "Task 1: Query output doesn't match expected result.")
        
        
    def test_task2(self):
        with open('./sql/task2.sql', 'r') as file:
            # Get the 4 sql queries in task2.sql
            sql_queries = file.read().split(';')[:-1]
        
        # Store the result of each sql query in the results array    
        results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            results.append(self.cur.fetchall())
        
        # Store the expected result of each problem in the expected_results array                  
        expected_results = []
        
        # Finding the expected result for Task 2 Problem 1 by data manipulation using pandas:
        review_data = pd.read_csv('./data/review_data.csv')
        product_data = pd.read_csv('./data/product_data.csv')
           # Merge the two dataframes on the 'product_id' column
        merged_data = pd.merge(review_data, product_data, on='product_id')
           # Group by product ID and calculate the average rating
        result = merged_data.groupby(['product_id', 'product_name']).agg({'rating': 'mean'}).reset_index()
           # Sort the result by rating. If rating is same, then product ID in ascending order is considered
        result_sorted = result.sort_values(by=['rating', 'product_id'], ascending=[False, True])
           # Get the top 5 products
        top5_products = result_sorted.head(5)
           # Formatting the result
        problem1_expected = [(row['product_id'], row['product_name'], row['rating'])
                            for index, row in top5_products.iterrows()]
        expected_results.append(problem1_expected)
        
        
        # Finding the expected result for Task 2 Problem 2 by data manipulation using pandas:
        user_data = pd.read_csv('./data/user_data.csv')
        order_data = pd.read_csv('./data/order_data.csv')
        order_items_data = pd.read_csv('./data/order_items_data.csv')
        product_data = pd.read_csv('./data/product_data.csv')
           # Merge order and order_items dataframes on 'order_id'
        merged_order_data = pd.merge(order_data, order_items_data, on='order_id')
           # Merge order_items and product dataframes on 'product_id'
        merged_product_data = pd.merge(merged_order_data, product_data, on='product_id')
           # Get the unique combinations of user_id, category_id
        unique_user_category_combinations = merged_product_data[['user_id', 'category_id']].drop_duplicates()
           # Group by user_id and count the unique categories
        user_categories_count = unique_user_category_combinations.groupby('user_id')['category_id'].count()
           # Get the user IDs who have made at least one order in each category
        users_in_each_category = user_categories_count[user_categories_count == product_data['category_id'].nunique()].index
           # Filter the user data based on the identified user IDs
        problem2_expected = [(row['user_id'], row['username']) for index, row in user_data[user_data['user_id'].isin(users_in_each_category)].iterrows()]
        expected_results.append(problem2_expected)
        
        
        # Finding the expected result for Task 2 Problem 3 by data manipulation using pandas:
        product_data = pd.read_csv('./data/product_data.csv')
        review_data = pd.read_csv('./data/review_data.csv')
            # Merge the two dataframes on the 'product_id' column using a left join
        merged_data = pd.merge(product_data, review_data, on='product_id', how='left')
            # Filter products that have not received any reviews
        products_without_reviews = merged_data[merged_data['review_id'].isnull()]
            # Formatting the result
        problem3_expected = [(row['product_id'], row['product_name'])
                for index, row in products_without_reviews.iterrows()]
        expected_results.append(problem3_expected)
        
        
        # Finding the expected result for Task 2 Problem 4 by data manipulation using pandas:
        user_data = pd.read_csv('./data/user_data.csv')
        order_data = pd.read_csv('./data/order_data.csv')
            # Convert 'order_date' to datetime format
        order_data['order_date'] = pd.to_datetime(order_data['order_date'])
            # Sort orders by user and order date
        sorted_orders = order_data.sort_values(['user_id', 'order_date'])
            # Create a new column 'difference' based on consecutive order dates
        sorted_orders['difference'] = (sorted_orders['order_date'].diff().dt.days == 1) & (sorted_orders['user_id'].eq(sorted_orders['user_id'].shift()))
            # Identify users who have placed orders on consecutive days
        consecutive_users = sorted_orders[sorted_orders['difference']]
        result_users = user_data[user_data['user_id'].isin(consecutive_users['user_id'].unique())]
        problem4_expected = [(row['user_id'], row['username'])
                            for index, row in result_users.iterrows()]
        expected_results.append(problem4_expected)
        
        # Check if the results array and the expected_results array are equal
        self.assertEqual(results, expected_results, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        with open('./sql/task3.sql', 'r') as file:
            # Get the 4 sql queries in task3.sql
            sql_queries = file.read().split(';')[:-1]
         
        # Store the result of each sql query in the results array        
        results = []
        for sql_query in sql_queries:
            self.cur.execute(sql_query)
            results.append(self.cur.fetchall())
        
        # Store the expected result of each problem in the expected_results array                            
        expected_results = []
        
        # Finding the expected result for Task 3 Problem 1 by data manipulation using pandas:
        category_data = pd.read_csv('./data/category_data.csv')
        product_data = pd.read_csv('./data/product_data.csv')
        order_items_data = pd.read_csv('./data/order_items_data.csv')
            # Merge product and category dataframes
        merged_product_category = pd.merge(product_data, category_data, on='category_id')
            # Merge order items and merged_product_category dataframes
        merged_order_items = pd.merge(order_items_data, merged_product_category, on='product_id')
            # Calculate total sales amount for each category
        merged_order_items['total_sales'] = merged_order_items['unit_price'] * merged_order_items['quantity']
        category_sales = merged_order_items.groupby(['category_id', 'category_name']).agg({'total_sales': 'sum'}).reset_index()
            # Get the top 3 categories with the highest total sales amount
        top3_categories = category_sales.nlargest(3, 'total_sales')[['category_id', 'category_name', 'total_sales']]
            # Formatting the result
        problem1_expected = [(row['category_id'], row['category_name'], row['total_sales'])
                            for index, row in top3_categories.iterrows()]
        expected_results.append(problem1_expected)
        
        
        # Finding the expected result for Task 3 Problem 2 by data manipulation using pandas:
        user_data = pd.read_csv('./data/user_data.csv')
        order_data = pd.read_csv('./data/order_data.csv')
        order_items_data = pd.read_csv('./data/order_items_data.csv')
        product_data = pd.read_csv('./data/product_data.csv')
        category_data = pd.read_csv('./data/category_data.csv')
            # Merge all four data frames
        merged_data = pd.merge(order_items_data, order_data, on='order_id')
        merged_data = pd.merge(merged_data, product_data, on='product_id')
        merged_data = pd.merge(merged_data, category_data, on='category_id')
        merged_data = pd.merge(merged_data, user_data, on='user_id')
            # Filter for products in the "Toys & Games" category
        toys_and_games_data = merged_data[merged_data['category_name'] == 'Toys & Games']
            # Get the users who have placed orders for all products in the "Toys & Games" category
        users_for_toys_and_games = toys_and_games_data.groupby(['user_id', 'username']).size().reset_index(name='order_count')
        users_for_toys_and_games = users_for_toys_and_games[users_for_toys_and_games['order_count'] == len(toys_and_games_data['product_id'].unique())]
            # Formatting the result
        problem2_expected = [(row['user_id'], row['username']) for index, row in users_for_toys_and_games.iterrows()]
        expected_results.append(problem2_expected)
        

        # Finding the expected result for Task 3 Problem 3 by data manipulation using pandas:
        product_data = pd.read_csv('./data/product_data.csv')
        category_data = pd.read_csv('./data/category_data.csv')
            # Merge product and category dataframes
        merged_data = pd.merge(product_data, category_data, on='category_id')
            # Find the row with the maximum price within each category
        max_price_products = merged_data.loc[merged_data.groupby('category_id')['price'].idxmax()]
            # Formatting the result
        problem3_expected = [(row['product_id'], row['product_name'], row['category_id'], row['price'])
                            for index, row in max_price_products.iterrows()]
        expected_results.append(problem3_expected)
        
        
        # Finding the expected result for Task 3 Problem 4 by data manipulation using pandas:
        user_data = pd.read_csv('./data/user_data.csv')
        order_data = pd.read_csv('./data/order_data.csv')
            # Convert 'order_date' to datetime format
        order_data['order_date'] = pd.to_datetime(order_data['order_date'])
            # Sort orders by user and order date
        sorted_orders = order_data.sort_values(['user_id', 'order_date'])
            # Create a new column 'difference' based on consecutive order dates
        sorted_orders['difference'] = (sorted_orders['order_date'].diff().dt.days == 1) & (sorted_orders['user_id'].eq(sorted_orders['user_id'].shift()))
            # Create a new column 'consecutive_days' to check for at least 3 consecutive days
        sorted_orders['consecutive_days'] = sorted_orders['difference'] & sorted_orders['difference'].shift(-1)
            # Identify users who have placed orders on 3 consecutive days
        consecutive_users = sorted_orders[sorted_orders['consecutive_days']]
        result_users = user_data[user_data['user_id'].isin(consecutive_users['user_id'].unique())]
            # Formatting the result
        problem4_expected = [(row['user_id'], row['username'])
                                    for index, row in result_users.iterrows()]
        expected_results.append(problem4_expected)
        
        # Check if the results array and the expected_results array are equal        
        self.assertEqual(results, expected_results, "Task 3: Query output doesn't match expected result.")

        
if __name__ == '__main__':
    unittest.main()