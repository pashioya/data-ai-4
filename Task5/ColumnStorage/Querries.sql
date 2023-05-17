-- clear the cache
DBCC FREEPROCCACHE;

-- Query 1
SELECT dim_Customer.SubscriptionType, COUNT(*) AS NumRides
FROM Fact_velo
         JOIN dim_Customer ON Fact_velo.DIM_CUSTOMER_SUBSCRIPTION_SK = dim_Customer.CUSTOMER_SK
GROUP BY dim_Customer.SubscriptionType;

-- create clustered columnstore index on entire Fact_velo table
create clustered columnstore index full_table_col_store_index on Fact_velo;
drop index full_table_col_store_index on Fact_velo;

-- OR

-- create index on dim_Customer table on SubscriptionType column
Create columnstore index
    [Fact_velo_CCI]
on [dbo].[Fact_velo]
(
    [DIM_CUSTOMER_SUBSCRIPTION_SK]
)
drop index [Fact_velo_CCI] on [dbo].[Fact_velo]

