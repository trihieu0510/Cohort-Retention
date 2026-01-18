import pandas as pd

df = pd.read_excel("raw/Online Retail.xlsx")  
df = df[["InvoiceNo","StockCode","Description","Quantity","InvoiceDate","UnitPrice","CustomerID","Country"]]


df = df.dropna(subset=["CustomerID", "InvoiceDate"])
df["CustomerID"] = df["CustomerID"].astype(int)
df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])


df["InvoiceNo"] = df["InvoiceNo"].astype(str)
df = df[~df["InvoiceNo"].str.startswith(("C","c"))] 


df = df[(df["Quantity"] > 0) & (df["UnitPrice"] > 0)]

df.to_csv("processed/transactions.csv", index=False)
