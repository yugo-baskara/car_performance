-- ======================= --
-- Most Fuel Efficient Car --
-- ======================= --

select
	distinct brand,
    model,
    max(combination_mpg) as best_combination_mpg
from
	portofolio.car_performance_clean
group by
	brand, model
order by
	best_combination_mpg desc
;	


-- =================================== --
-- Correlation Cylinder to Consumption --
-- =================================== --

select
	brand,
    model,
    cylinders,
    round(avg(combination_mpg),2) as avg_combination_mpg
from
	portofolio.car_performance_clean
group by
	brand,
    model,
    cylinders
order by
	avg_combination_mpg desc
;


-- ======================= --
-- Car Efficient Per Class --
-- ======================= --

select
	class,
    avg(combination_mpg) as avg_mpg_fuel
from
	portofolio.car_performance_clean
group by
	class
order by
	avg_mpg_fuel desc
;


-- ============================ --
-- Comparation Car Transmission --
-- ============================ --

select
    transmission,
    count(transmission) as total_transmission
from
	portofolio.car_performance_clean
group by
	transmission
order by
	total_transmission
;


-- ====================================== --
-- Average Fuel Consumption to Drive type --
-- ====================================== --

select
	drive,
    avg(combination_mpg) as avg_mpg_fuel
from
	portofolio.car_performance_clean
group by
	drive
order by
	avg_mpg_fuel desc
;


-- ================================== --
-- Fuel Efficiency According to Brand --
-- ================================== --

select
	brand,
    round(avg(combination_mpg), 2) as avg_fuel
from
	portofolio.car_performance_clean
group by
	brand
having
	count(*) >= 5
order by
	avg_fuel desc
;


-- ============================ --
-- Efficiency Fuel Year to Year --
-- ============================ --

select
	brand,
	model,
    year,
    round(avg(combination_mpg)) as avg_consumption_fuel_mpg
from
	portofolio.car_performance_clean
group by
	brand, model, year
order by
	avg_consumption_fuel_mpg desc
;


-- ======================= --
-- Highest Sales Car Brand --
-- ======================= --

select
	brand,
    count(brand) as total_models
from
	portofolio.car_performance_clean
group by
	brand
order by
	total_models desc
;


-- ============================================ --
-- Comparison Between Fuel and Electric Vehicle --
-- ============================================ --

select
	fuel_type,
    count(fuel_type) as total_cars,
    round(avg(combination_mpg), 2) as avg_mpg
from
	portofolio.car_performance_clean
group by
	fuel_type
;
