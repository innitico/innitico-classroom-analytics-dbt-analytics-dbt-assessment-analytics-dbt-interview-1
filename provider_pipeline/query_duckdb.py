import duckdb
import pandas as pd

def query_duckdb():
    try:
        # Corrected connection with the specified file path (using raw string literal to handle backslashes)
        con = duckdb.connect(database=r"C:\Users\MuhilA\Kyruus_dbt\analytics-dbt-assessment-CT-muhilam\provider_pipeline\dev.duckdb", read_only=True)

        # Check if the table exists in the database
        check_query = "SELECT name FROM sqlite_master WHERE type='table' AND name='provider_address_agg';"
        table_exists = con.execute(check_query).fetchone()

        if not table_exists:
            raise Exception("Table 'provider_address_agg' does not exist in the database.")

        # Main query to fetch data from the table
        query = "SELECT * FROM provider_address_agg"

        # Execute the query and fetch the results into a pandas DataFrame
        df = con.execute(query).fetchdf()

        # Close the connection
        con.close()

        # Print the resulting DataFrame
        print(df)
        return df

    except Exception as e:
        # Handle and print any errors that occur
        print(f"An error occurred: {e}")
        return None

if __name__ == "__main__":
    query_duckdb()
