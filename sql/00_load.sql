DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions AS
SELECT * FROM read_csv_auto('processed/transactions.csv');
