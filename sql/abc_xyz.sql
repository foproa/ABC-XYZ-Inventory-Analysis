with abc_xyz as(
select 
	table_abc.name,
	table_abc.abc_sales,
	table_abc.abc_amount,
	table_xyz.xyz
from result_abc as table_abc
join result_xyz as table_xyz
	on table_abc.name = table_xyz.name
order by table_abc.name
)
select 
	name,
	abc_sales || xyz as abc_xyz_sales,
	abc_amount || xyz as abc_xyz_amount
from abc_xyz