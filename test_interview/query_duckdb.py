import duckdb
import pandas as pd

def query_duckdb():
    # Connection
    con = duckdb.connect(database="/tmp/dev.duckdb", read_only=True)

    query = "SELECT * FROM provider_address_agg"
    df = con.execute(query).fetchdf()
    con.close()
    print(df)

    return df

if __name__ == "__main__":
    query_duckdb()
