--Names Group 6
--Obianujunwa Nwaiwu
--Ogechi Ideozu
--Kosemani Adegbenro
--Oluwanifesimi Okesola
--Juliet Uti
--Mirriam Awio team leader 
--Ogechukwu Nwankwo
--Oluwabori Soyele
--Oluwabunmi Meshach
--Nkechi Ayama



--COPY PUBLIC."Mydata" FROM 'C:\Users\pc\Desktop\Dateset\breweries.csv' DELIMITER ',' CSV HEADER ;
create table csv_Mydata (SALES_ID int not null,SALES_REP varchar (100),
		EMAILS varchar(100), BRANDS varchar(100), PLANT_COST int, 
			UNIT_PRICE int,QUANTITY int, COSTS int,PROFIT int, COUNTRIES varchar(100), 
				REGION varchar(100), MONTHS varchar(100), YEARS int);
				
select * from csv_Mydata;

--PROFIT ANALYSIS

--checting for the distinct country 
select distinct(countries) from csv_Mydata;
-- the output shows  that the dataset has data from five countries which are "Nigeria, Beinin, Senegal,Ghana and Togo"

--Adding a territory column & values to the table
ALTER TABLE csv_Mydata
ADD COLUMN territories TEXT;
UPDATE csv_Mydata
SET territories =
	CASE
		WHEN countries IN ('Nigeria', 'Ghana') THEN 'Anglophone'
		WHEN countries IN ('Benin', 'Senegal', 'Togo') THEN 'Francophone'
	END;

-- checking how many years data was given
select distinct(years) from csv_Mydata;
-- the outpu shows that tthree years data was given

--question one
--calculating for the profit made in the last three years
select sum(profit) as three_profit from csv_Mydata;
-- the profit for the past three years was #105,587,420

-- qustion 2
select distinct(territories), sum(profit) as territories_profit
from csv_Mydata
group by territories
order by territories_profit desc;
-- The output shows that francophone made more profit than Anglophone with the profit of 63,198,160 and 42,389,260 respectively

--question3 . Country that generated the highest profit in 2019
select distinct(countries), sum(profit) as country_profit
from csv_Mydata
where years = 2019
group by countries
order by country_profit
limit 5;
--The output shows that Ghana generated the highest profit by 7,144,070

--question 4 ind the year with the highest profit
select distinct (years), sum(profit) as profit_by_year
from csv_Mydata
group by years
order by profit_by_year desc;
--the output shows that the highest profit was made in 2017

-- question 5 Which month in the three years was the least profit generated?
select distinct (months), sum(profit) as least_profit
from csv_Mydata
group by months
order by least_profit desc;
--April was the month the least profit was generated 

--question 6 What was the minimum profit in the month of December 2018?
select distinct (months), min(profit) as min_profit
from csv_Mydata
where months = 'December' and years = 2018
group by months;
-- The minimun profit in the month of december was 38,150

--guestion 7 Compare the profit in percentage for each of the month in 2019
select
	months, sum(profit),
	(sum(profit) / (select count(profit) * 100
	from csv_Mydata where years = 2019)) as percentage_profit 
	from csv_Mydata where years = 2019
	group by months
	--order by precentage_porfit

-- question 8 Which particular brand generated the highest profit in Senegal
select distinct (brands), sum(profit) as brand_by_profit
from csv_Mydata where countries = 'Senegal'
group by brands
order by brand_by_profit desc;
--In Senegal castle lite generated the highest profit by 70,12,980

--BRAND ANALYSIS
-- question 1 . Within the last two years, the brand manager wants to know the top three brands
--consumed in the francophone countries

select (brands), sum(quantity) as highest_consumed
	from csv_Mydata
	where territories = 'Francophone' and years in (2018,2019)
	group by brands
	order by 2 desc
	limit 3;
-- The top three brand consumed by Francophone countries are Trophy,Hero and Eagle Lager 

--question 2  Find out the top two choice of consumer brands in Ghana
select (brands), sum(quantity) as highest_consumed
	from csv_Mydata
	where countries = 'Ghana'
	group by brands
	order by highest_consumed desc
	limit 2;
--Eagle lager & Castle lite are the top two choice of consumer brands in Ghana

--question 3 . Find out the details of beers consumed in the past three years in the most oil reached country in West Africa.
select (brands), sum(quantity) as bear_consumed
	from csv_Mydata
	where countries = 'Nigeria' and brands not in ('grand malt','beta malt')
	group by brands
	order by bear_consumed desc;
--Output shows the detail of beers consumed in the most oil rich country which are Budweiser, Eagle lager,
--Hero, Trophy and Castle Lite

--question 4 Favorites malt brand in Anglophone region between 2018 and 2019
select 
	brands, sum(Quantity) AS favorite_malt
from csv_Mydata
where territories = 'Anglophone' and brands in ('beta malt', 'grand malt')
		and years in ('2018', '2019')
group by brands
order by favorite_malt desc
limit 2;
-- Anglophon region's favorite malt brand in 2018 and 2019 is Grand Malt

--question 5 . Which brands sold the highest in 2019 in Nigeria?
select
	brands, sum(quantity) as highest_sold
from csv_Mydata
where countries = 'Nigeria' and years in (2019)
group by brands
order by highest_sold desc
limit 3;
--The highest sold brand in Nigeria in 2019 is Hero follewed by Eagle Lager

--question 6 Favorites brand in South_South region in Nigeria
select 
	brands, sum(quantity) as favorite_brand
from csv_Mydata
where countries = 'Nigeria' and region = 'southsouth'
group by brands
order by favorite_brand desc
limit 2;
-- the favorite brand in South_South region in Nigeria was Eagle Lager

--question 7  Bear consumption in Nigeria
select 
	sum(Quantity) as beer_consumed
from csv_Mydata
where countries = 'Nigeria' and brands not in ('beta malt', 'grand malt');
--Total beer consumed in Nigeria was 129,260

--question 8. Level of consumption of Budweiser in the regions in Nigeria
select 
	region, sum(quantity) as level_budweiser_consumed
from csv_Mydata
where countries = 'Nigeria' and brands = 'budweiser'
group by region
order by level_budweiser_consumed desc; 
-- West region in Nigeria has the highest budweiser consumption level

--question 9. Level of consumption of Budweiser in the regions in Nigeria in 2019
select 
	region, sum(quantity) as level_budweiser_consumed
from csv_Mydata
where countries = 'Nigeria' and brands = 'budweiser' and years in (2019)
group by region
order by level_budweiser_consumed desc; 
-- in 2019 Southeast region in Nigeria has the highest budweiser consumption level

--COUNTRIES ANALYSIS
--question 1. Country with the highest consumption of beer
select 
	countries, sum(quantity) as quantity_consumed
from csv_Mydata
where brands not in ('grand malt','beta malt')
group by countries
order by quantity_consumed desc
limit 2;
-- the output shows Senegal as the country with the highest consumption of beer.

--question 2. Highest sales personnel of Budweiser in Senegal
select 
	sales_rep, sum(quantity) as highest_sales
from csv_Mydata
where countries = 'Senegal' and brands = 'budweiser'
group by sales_rep
order by highest_sales desc;
--Jones is the Highest sales personnel of Budweiser in Senegal

--question 3. Country with the highest profit of the fourth quarter in 2019
	
select 
	countries, sum(profit) as highest_profit
from csv_Mydata
where months in('October','November','December') and years = 2019
group by countries 
order by highest_profit desc;

select distinct brands from csv_Mydata 
select * from csv_Mydata