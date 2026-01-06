--Business questions

/* 1) What is the average rental price of 1 room, 2 room, 3 room and 4 room apartments in some of the major cities in Poland? 
	Arrange the result such that avg rent for each type fo room is shown in seperate column */

	select city, round(avg_rent_1R,2) as avg_rent_1R
	, round(avg_rent_2R,2) as avg_rent_2R, round(avg_rent_3R,2) as avg_rent_3R
	, round(avg_rent_4R,2) as avg_rent_4R
	from (
	    select city,no_of_rooms,price_new
	    from otodom_data_transformed
	    where city in ('Warszawa', 'Wrocław', 'Kraków', 'Gdańsk', 'Katowice', 'Łódź')
	    and apartment_flag = 'apartment'
	    and is_for_sale='false' 
	    and no_of_rooms in (1,2,3,4)) x
	pivot 
	    (
	        avg(price_new)
	        for no_of_rooms in ('1','2','3','4')
	    ) 
	    as p(city,avg_rent_1R, avg_rent_2R, avg_rent_3R, avg_rent_4R)
	order by avg_rent_4R desc 


/* 2) What size of an apartment can I expect with a monthly rent of 3000 to 4000 PLN in different major cities of Poland? */

	select city, avg(surface_new) avg_area
	from otodom_data_transformed
	where city in ('Warszawa', 'Wrocław', 'Kraków', 'Gdańsk', 'Katowice', 'Łódź')
	and apartment_flag = 'apartment'
	and is_for_sale = 'false'
	and price_new between 3000 and 4000
	group by city
	order by avg_area;

/* 3) What is the avg sale price for 3 room apartments within 50-70 m2 area in major cities of Poland? */

	select city, round(avg(price_new),2) as avg_sale_price
	from otodom_data_transformed
	where city in ('Warszawa', 'Wrocław', 'Kraków', 'Gdańsk', 'Katowice', 'Łódź')
	and apartment_flag = 'apartment'
	and is_for_sale = 'true'
    and no_of_rooms = 3
	and surface_new between 50 and 70
	group by city
	order by avg_sale_price desc;

	
/* 4) What is the average rental price and sale price in some of the major cities in Poland? */
	
	with cte as
	(select city
	, (case when is_for_sale='false' then round(avg(price_new),2) end) as avg_rental
	, (case when is_for_sale='true'  then round(avg(price_new),2) end) as avg_sale
	from otodom_data_transformed
	where city in ('Warszawa', 'Wrocław', 'Kraków', 'Gdańsk', 'Katowice', 'Łódź')
	and apartment_flag = 'apartment'
	group by city, is_for_sale)
	select city, max(avg_rental) as avg_rental, max(avg_sale) as avg_sale
	from cte
	group by city
	order by avg_rental desc ;	

/* 5) What is the average rental price for apartments in warsaw in different suburbs? 
	Categorize the result based on surface area 0-50, 50-100 and over 100. */

	with cte1 as
	(select a.*
	, case when surface_new between 0 and 50 then '0-50'
	when surface_new between 50 and 100 then '50-100'
	when surface_new > 100 then '>100'
	end as area_category
	from otodom_data_transformed a
	where city = 'Warszawa'
	and apartment_flag = 'apartment'
	and is_for_sale = 'false'
	and suburb is not null ),
	cte2 as
	(select suburb
	, case when area_category = '0-50' then avg(price_new) end as avg_price_upto50
	, case when area_category = '50-100' then avg(price_new) end as avg_price_upto100
	, case when area_category = '>100' then avg(price_new) end as avg_price_over100
	from cte1
	group by suburb,area_category)
	select suburb
	, round(max(avg_price_upto50),2) as avg_price_upto_50
	, round(max(avg_price_upto100),2) as avg_price_upto_100
	, round(max(avg_price_over100),2) as avg_price_over_100
	from cte2
	group by suburb
	order by suburb;
