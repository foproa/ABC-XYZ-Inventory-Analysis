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
order by name;
    