--Data loading, processing and transforming

create or replace table otodom_data_dump_short
(
    json_data text
);

--file format

create or replace file format csv_format
type = csv
field_delimiter = ','
field_optionally_enclosed_by = '"';

--stage

create or replace stage my_csv_stage_short
file_format = csv_format;

--load data from stage to table

copy into otodom_data_dump_short
from @my_csv_stage_short;

select count(1)
from otodom_data_dump_short;

select parse_json(json_data):price
from otodom_data_dump_short limit 5;

--flatten data

create or replace table otodom_data_short_flatten
as 
select row_number() over(order by title) as rn
, x.*
from (
select replace(parse_json(json_data):advertiser_type,'"')::string as advertiser_type
, replace(parse_json(json_data):balcony_garden_terrace,'"')::string as balcony_garden_terrace
, regexp_replace(replace(parse_json(json_data):description,'"'), '<[^>]+>')::string as description
, replace(parse_json(json_data):heating,'"')::string as heating
, replace(parse_json(json_data):is_for_sale,'"')::string as is_for_sale
, replace(parse_json(json_data):lighting,'"')::string as lighting
, replace(parse_json(json_data):location,'"')::string as location
, replace(parse_json(json_data):price,'"')::string as price
, replace(parse_json(json_data):remote_support,'"')::string as remote_support
, replace(parse_json(json_data):rent_sale,'"')::string as rent_sale
, replace(parse_json(json_data):surface,'"')::string as surface
, replace(parse_json(json_data):timestamp,'"')::date as timestamp
, replace(parse_json(json_data):title,'"')::string as title
, replace(parse_json(json_data):url,'"')::string as url
, replace(parse_json(json_data):form_of_property,'"')::string as form_of_property
, replace(parse_json(json_data):no_of_rooms,'"')::string as no_of_rooms
, replace(parse_json(json_data):parking_space,'"')::string as parking_space
from OTODOM_DATA_DUMP_SHORT 

) x;


create or replace table otodom_data_flatten_address (
    rn int,
    location text,
    address text
);

copy into otodom_data_flatten_translate
from @my_csv_stage2;

create or replace stage my_csv_stage2
file_format = csv_format;

create or replace table otodom_data_flatten_translate (
    rn int,
    original_text text,
    translated_text text
);

alter table otodom_data_flatten_translate
rename column translated_text to title_eng;

select * from otodom_data_short_flatten limit 5;
select * from otodom_data_flatten_address limit 5;
select * from otodom_data_flatten_translate limit 5;

-- combining all 3 tables

CREATE OR REPLACE TABLE OTODOM_DATA_TRANSFORMED
as
with cte as 
    (select ot.*
    , case when price like 'PLN%' then try_to_number(replace(price,'PLN ',''),'999,999,999.99')
           when price like '€%' then try_to_number(replace(price,'€',''),'999,999,999.99') * 4.43
      end as price_new
    , try_to_double(replace(replace(replace(replace(surface,'m²',''),'м²',''),' ',''),',','.'),'9999.99') as surface_new
    , replace(parse_json(addr.address):suburb,'"', '') as suburb
    , replace(parse_json(addr.address):city,'"', '') as city
    , replace(parse_json(addr.address):country,'"', '') as country
    , trans.title_eng as title_eng
    from otodom_data_short_flatten ot 
    left join otodom_data_flatten_address addr on ot.rn=addr.rn 
    left join otodom_data_flatten_translate trans on ot.rn=trans.rn)
select *
, case when lower(title_eng) like '%commercial%' or lower(title_eng) like '%office%' or lower(title_eng) like '%shop%' then 'non apartment'
       when is_for_sale = 'false' and surface_new <=330 and price_new <=55000 then 'apartment'
       when is_for_sale = 'false' then 'non apartment'
       when is_for_sale = 'true'  and surface_new <=600 and price_new <=20000000 then 'apartment'
       when is_for_sale = 'true'  then 'non apartment'
  end as apartment_flag
from cte;

DESC TABLE otodom_data_short_flatten;

select *
from otodom_data_transformed limit 10;


