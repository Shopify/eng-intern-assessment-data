import unittest
import mysql.connector # Replace with appropriate database connector based on your database
import os 

class TestSQLQueries(unittest.TestCase):

    def setUp(self):
        # Establish a connection to your test database
        self.conn = mysql.connector.connect(
            dbname='Shopify',
            user='root',
            password='your_password',
            host='127.0.0.1',
            port='3306'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def test_task1(self):
        # Task 1: Example SQL query in task1.sql
        with open('/sql/task1.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 1 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 1: Query output doesn't match expected result.")

    def test_task2(self):
        # Task 2: Example SQL query in task2.sql
        with open('/sql/task2.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 2 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 2: Query output doesn't match expected result.")

    def test_task3(self):
        # Task 3: Example SQL query in task3.sql
        with open('/sql/task3.sql', 'r') as file:
            sql_query = file.read()

        self.cur.execute(sql_query)
        result = self.cur.fetchall()

        # Define expected outcome for Task 3 and compare
        expected_result = [
            # Define expected rows or values here based on the query output
        ]

        self.assertEqual(result, expected_result, "Task 3: Query output doesn't match expected result.")
    
    # Add more test methods for additional SQL tasks
    def load_data(self):
        '''
        Load data into all tables from their respective CSV files.
        '''
        tables = ["Categories", "Products", "Users", "Orders", "Order_Items", "Reviews", "Cart", "Cart_Items", "Payments", "Shipping"]
        for table in tables:
            if self.is_table_empty(table):
                self.load_table_from_csv(table)
                
    def is_table_empty(self, table):
        self.cur.execute(f"SELECT COUNT(*) FROM {table}")
        return self.cur.fetchone()[0] == 0
    
    def load_table_from_csv(self, table):
        """
    Load data into a table from a CSV file.
    """
        csv_file = table.lower() + "_data.csv"
        script_dir = os.path.dirname(__file__)  # get the directory of the current script
        rel_path = f"data/{csv_file}"
        abs_file_path = os.path.join(script_dir, rel_path)  # join the script directory with the relative file path

        sql_command = f"""
        LOAD DATA INFILE '{abs_file_path}'
        INTO TABLE {table}
        FIELDS TERMINATED BY ','
            """
        try:
            self.cur.execute(sql_command)
            self.conn.commit()
            print(f"{table} data added successfully.")
        except Exception as e:
            print(f"An error occurred while loading {table}: {str(e)}")
        
    def disable_foreign_key_checks(self):
        """
        Disable foreign key checks.
        """
        self.cur.execute("SET FOREIGN_KEY_CHECKS = 0;")

    def enable_foreign_key_checks(self):
        """
        Enable foreign key checks.
        """
        self.cur.execute("SET FOREIGN_KEY_CHECKS = 1;")

    def get_all_tables(self):
        """
        Get a list of all tables in the database.
        """
        self.cur.execute("SHOW TABLES;")
        return [table[0] for table in self.cur.fetchall()]


if __name__ == '__main__':
    unittest.main()
