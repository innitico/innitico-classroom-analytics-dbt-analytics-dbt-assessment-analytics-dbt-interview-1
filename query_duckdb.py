import duckdb
import pandas as pd
 
def query_duckdb():
    conn = duckdb.connect(database="tmp/dev.duckdb", read_only=False)
    
    query = "SELECT * FROM provider_address_agg;"
    
    df = conn.execute(query).fetchdf()  
    
    conn.close()
    return df
 
if __name__ == "__main__":
    result = query_duckdb()
    print(result.to_string(index=False))