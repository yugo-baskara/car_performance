create table portofolio.car_performance_clean as
select
	cast(city_mpg as unsigned) as city_mpg,
	class,
    cast(combination_mpg as unsigned) as combination_mpg,
case
	when trim(cylinders) regexp '^[0-9]+(\\.0+)?$'
    then cast(cast(trim(cylinders) as decimal(3,1)) as unsigned) else null
end as cylinders,
case
	when displacement regexp '^[0-9]+(\\.[0-9]+)?$'
    then cast(trim(displacement) as decimal(4,1)) else null
end as displacement,
drive,
fuel_type,
cast(highway_mpg as unsigned) as highway_mpg,
brand,
model,
transmission,
cast(year as unsigned) as year
from 
	portofolio.car_performance_raw
;
