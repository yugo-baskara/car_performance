select
	count(*) as total_rows,
    count(cylinders) as non_null_cylinders,
    count(displacement) as non_null_displacement
from
	portofolio.car_performance_clean
;
