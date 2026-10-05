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
