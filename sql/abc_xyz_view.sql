create or replace view result_abc as (
with data as(
select 
	Item_Name as name,
	sum(Total_Sales_Value) as sales,
	sum(Total_Annual_Units) as amount
from inventory
group by Item_Name
)
select
	name,
	case
		when sum(sales) over (order by sales desc) / sum(sales) over () <= 0.8 then 'A'
		when sum(sales) over (order by sales desc) / sum(sales) over () <= 0.95 then 'B'
		else 'C'
	end as abc_sales,
	case
		when sum(amount) over (order by amount desc) / sum(amount) over () <= 0.8 then 'A'
		when sum(amount) over (order by amount desc) / sum(amount) over () <= 0.95 then 'B'
		else 'C'
	end as abc_amount
from data
)

--create view result_xyz
create or replace view result_xyz as (
with t1 as (
select
        Item_Name as name,
        month,
        sales
    from inventory
    unpivot (
        sales FOR month IN (
            Jan_Demand, Feb_Demand, Mar_Demand, Apr_Demand,
            May_Demand, Jun_Demand, Jul_Demand, Aug_Demand,
            Sep_Demand, Oct_Demand, Nov_Demand, Dec_Demand
        )
    )
),
xyz as (
select
	month,
	name,
	stddev_pop(sales) over (partition by name) as std,
	avg(sales) over (partition by name) as average,
	stddev_pop(sales) over (partition by name) / avg(sales) over (partition by name) as cv
from t1
)
select
	DISTINCT name,
	round(cv,3) as cv,
	case
		when cv <= 0.1 then 'X'
		when cv <= 0.2 then 'Y'
		else 'Z'
	end as xyz
from xyz
order by name
)