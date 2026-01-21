load data infile
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/car_data.csv'
into table
	portofolio.car_performance_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
;
