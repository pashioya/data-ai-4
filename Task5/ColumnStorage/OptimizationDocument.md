Optimization Document

Query to Optimize:
SELECT dim_Customer.SubscriptionType, COUNT(*) AS NumRides
FROM Fact_velo
         JOIN dim_Customer ON Fact_velo.DIM_CUSTOMER_SUBSCRIPTION_SK = dim_Customer.CUSTOMER_SK
GROUP BY dim_Customer.SubscriptionType;

Reasons for selecting the query:
The query is selected because it is a common query that is executed by the business users.
The query requires a full lookup of the Fact_velo table, which contains a large volume of data.
The query involves a join operation between the Fact_velo and dim_Customer tables.

Execution Plan Before Optimization:
The execution plan shows a join operation between the Fact_velo and dim_Customer tables,
followed by a group by operation on the SubscriptionType column.
The join operation is performed using the DIM_CUSTOMER_SUBSCRIPTION_SK column
 from the Fact_velo table and the CUSTOMER_SK column from the dim_Customer table.
The group by operation is performed on the SubscriptionType column.

Total Cost: 19.3694



Optimization Plan (Column Store):
We have two column store options for optimization:
1. Clustered Column Store Index

We can create a clustered column store index on the Fact_velo table.
Problem with Clustered Column Store Index:
The clustered column store index is a table-level index.
It stores the entire table in a columnar format.
This means that all columns in the table are stored in a columnar format.
This is not ideal for the Fact_velo table because it contains many columns that are not used in the query.

--Queries to create Clustered Column Store Index
    - CREATE CLUSTERED COLUMNSTORE INDEX full_table_col_store_index ON Fact_velo;
--Query to drop Clustered Column Store Index
    -  DROP INDEX full_table_col_store_index ON Fact_velo;


2. Non-Clustered Column Store Index

We can create a column store index on the DIM_CUSTOMER_SUBSCRIPTION_SK column in the Fact_velo table.
This is a non-clustered column store index.
It stores only the DIM_CUSTOMER_SUBSCRIPTION_SK column in a columnar format.
This is ideal for the Fact_velo table because the DIM_CUSTOMER_SUBSCRIPTION_SK column is used in the join operation.
The column store index is created on the DIM_CUSTOMER_SUBSCRIPTION_SK column.

-- Query to create Column Store Index on a specific column
CREATE COLUMNSTORE INDEX
    [Fact_velo_CCI]
ON [dbo].[Fact_velo]
(
    [DIM_CUSTOMER_SUBSCRIPTION_SK]
)

-- Query to drop Column Store Index on a specific column
DROP INDEX [Fact_velo_CCI] ON [dbo].[Fact_velo]


Execution Plan After Optimization:
Before we test the execution plan after optimization, We cleared the cache using the following query:
DBCC FREEPROCCACHE;
This allows us to test the execution plan without any bias.

The execution plan now takes advantage of column storage.
It performs a columnstore scan on the Fact_velo table, utilizing the compressed columnar format.
The necessary columns (DIM_CUSTOMER_SUBSCRIPTION_SK) are accessed for the join operation, and the group by operation is performed on the SubscriptionType column.

Total Cost: 3.5807



Comparison of Before and After Execution Plan:
Before Optimization:
Table scan on the Fact_velo table
Join operation using the necessary columns (DIM_CUSTOMER_SUBSCRIPTION_SK)
Group by operation on the SubscriptionType column
Total Cost: 19.3694


After Optimization:
Full index scan on the Fact_velo table
Group by operation on the SubscriptionType column
Total Cost: 3.5807


Decision:
Based on the collected information, implementing the column storage optimization is recommended,
especially since the Fact_velo table contains a large volume of data.
The script to enable column storage on the Fact_velo table is provided.
We saw a significant improvement of roughly 83% in the execution plan after implementing the column storage optimization.
