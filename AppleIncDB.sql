
--if database not created execute this
use master
if Object_id('AppleIncDB') is not null
	drop database AppleIncDB
go
create database AppleIncDB
--end create database

--project1
--AppleIncDB
--
--created by: Spencer Barck
--created: 1/21/2021
use AppleIncDB

--drop all tables

if Object_id('stores') is not null
	drop table stores
go

if Object_id('channel_partners') is not null
	drop table channel_partners
go

if Object_id('secondary_distributors') is not null
	drop table secondary_distributors
go

if Object_id('distributors') is not null
	drop table distributors
go

if Object_id('warehouses') is not null
	drop table warehouses
go

if Object_id('cost_to_manufacture') is not null
	drop table cost_to_manufacture
go

if Object_id('production_houses') is not null
	drop table production_houses
go

if Object_id('customers') is not null
	drop table customers
go

if Object_id('return_info') is not null
	drop table return_info
go


if Object_id('transactions') is not null
	drop table transactions
go

if Object_id('transaction_types') is not null
	drop table transaction_types
go

if Object_id('device_statuses') is not null
	drop table devices
go

if Object_id('devices') is not null
	drop table devices
go

if Object_id('return_info') is not null
	drop table return_info
go

if Object_id('zones') is not null
	drop table zones
go

if Object_id('countries') is not null
	drop table countries
go

if Object_id('continents') is not null
	drop table continents
go

if Object_id('models') is not null
	drop table models
go

if Object_id('return_reasons') is not null
	drop table return_reasons
go

if Object_id('device_statuses') is not null
	drop table device_statuses
go
--end drop all tables

use AppleIncDB

----create geography tables
--create continents table
create table continents(
	pk_continent_id int PRIMARY KEY,
	continent_name varchar(20) unique not null
)
--end create continents table

--create countries table
create table countries
(
	pk_country_id int PRIMARY KEY,
	country_name varchar(20) unique not null,
	country_tax float,
	fk_continent_id int not null,
	FOREIGN KEY (fk_continent_id) REFERENCES continents(pk_continent_id)
)
--end create countries table

--create zones table
create table zones(
	pk_zone_id int PRIMARY KEY,
	zone_name varchar(20) unique not null,
	fk_country_id int not null,
	FOREIGN KEY (fk_country_id) REFERENCES countries(pk_country_id)
)
--end create zones table
----end create geography tables

----create supply chain tables
--create production_houses table
create table production_houses(
	pk_production_house_id int PRIMARY KEY,
	production_house_name varchar(20) unique not null,
	fk_country_id int not null,
	FOREIGN KEY (fk_country_id) REFERENCES countries(pk_country_id)
)
--end create production_houses table

--create wearhouses table
create table warehouses(
	pk_warehouse_id	int primary key,
	wearhouse_name varchar(40),
	fk_production_house_id int not null,
	fk_country_id int not null,
	FOREIGN KEY (fk_production_house_id) REFERENCES production_houses(pk_production_house_id),
	FOREIGN KEY (fk_country_id) REFERENCES countries(pk_country_id)
)
--end create wearhouses table

--create distributor table
create table distributors(
	pk_distributor_id int PRIMARY KEY,
	distributor_name varchar(20) unique not null,
	fk_warehouse_id int not null,
	fk_country_id int not null,
	FOREIGN KEY (fk_warehouse_id) REFERENCES warehouses(pk_warehouse_id),
	FOREIGN KEY (fk_country_id) REFERENCES countries(pk_country_id)
)
						
--end create distributor table

--create secondary_distributor table
create table secondary_distributors(
	pk_secondary_distributor_id int PRIMARY KEY,
	secondary_distributor_name varchar(20) unique not null,
	fk_distributor_id int not null,
	fk_country_id int not null,
	FOREIGN KEY (fk_distributor_id) REFERENCES distributors(pk_distributor_id),
	FOREIGN KEY (fk_country_id) REFERENCES countries(pk_country_id)
)
--end create secondary_distributor table

--create channel_partners table
create table channel_partners(
	pk_channel_partner_id int PRIMARY KEY,
	channel_partner_name varchar(20) unique not null,
	fk_secondary_distributor_id int not null,
	fk_zone_id int not null,
	FOREIGN KEY (fk_secondary_distributor_id) REFERENCES secondary_distributors(pk_secondary_distributor_id),
	FOREIGN KEY (fk_zone_id) REFERENCES zones(pk_zone_id)
)
--end create stores table

--create stores table
create table stores(
	pk_store_id int PRIMARY KEY,
	store_name varchar(20) unique not null,
	store_address varchar(30) unique not null,
	fk_channel_partner_id int not null,
	fk_zone_id int not null,
	FOREIGN KEY (fk_channel_partner_id) REFERENCES channel_partners(pk_channel_partner_id),
	FOREIGN KEY (fk_zone_id) REFERENCES zones(pk_zone_id)
)
--end create stores table
----end create supply chain tables

--other tables to create

	--customers
	--wearhouses
	--devices
	--transactions
	--products

--devices serialNo,model,dateTimeCreated,productionHouseId,wearhouseId,dateTimeShippedFromWearhouse,distributerId,
--dateTimeShippedFromDistributer,subDistributerId,dateTimeShippedFromSubDistributer,channelPartnerId,
--dateTimeShippedFromChannelPartner,storeId,dateTimeSold,cutomerId,status,returnId,price

create table customers
(
	pk_customer_unique_id int primary key identity(0,1),
	customer_name varchar(20),
	customer_address varchar(30),
	customer_email varchar(30) unique,
	customer_phone varchar(20)
)

create table models
(
	pk_model_id	int primary key,
	model_name varchar(20),
	model_release_datetime datetime
)

--the cost to manufacture for a specific model at a specific location
create table cost_to_manufacture(
	pk_cost_to_manufacture_id int primary key identity(0,1),
	cost_to_manufacture float not null,
	fk_production_house_id int not null,
	fk_model_id int not null,
	FOREIGN KEY (fk_production_house_id) REFERENCES production_houses(pk_production_house_id),
	FOREIGN KEY (fk_model_id) REFERENCES models(pk_model_id)
)

--where a device is currently or if the device has been sold
create table device_statuses(
	pk_device_status_id int primary key,
	device_status_name varchar(50)
)

create table devices
(
	pk_serial_number int primary key identity(1000000,1),
	fk_model_id int not null  REFERENCES models(pk_model_id),
	fk_device_status_id int,
	FOREIGN KEY (fk_device_status_id) REFERENCES device_statuses(pk_device_status_id)
)

--the types of transactions shipping/production/selling/return
create table transaction_types(
	pk_transaction_type_id int primary key,
	transaction_type_desc varchar(50)
)

create table transactions
(
	pk_transaction_id int primary key,
	transaction_sender_id int,
	transaction_receiver_id int,
	transaction_datetime datetime,
	post_transaction_device_cost float,
	fk_device_serial_number int not null,
	fk_transaction_type_id int,
	FOREIGN KEY (fk_device_serial_number) REFERENCES devices(pk_serial_number),
	FOREIGN KEY (fk_transaction_type_id) REFERENCES transaction_types(pk_transaction_type_id)
)

--the list of return reasons
create table return_reasons
(
	pk_return_reason_id int primary key,
	return_reason_name varchar(20)
)

--this is were detailed info about a return is stored
create table return_info
(
	pk_return_info_id int primary key,
	return_desc varchar(50),
	fk_transaction_id int,
	fk_return_reason_id int,
	FOREIGN KEY (fk_transaction_id) REFERENCES transactions(pk_transaction_id),
	FOREIGN KEY (fk_return_reason_id) REFERENCES return_reasons(pk_return_reason_id)
)

select * from customers
select * from models

select * from devices

select * from transactions

select * from cost_to_manufacture

select * from device_statuses

select * from return_reasons
select * from return_info


--sample geography data
insert into continents values(1,'Asia')
insert into continents values(2,'Europe')
insert into countries values(10,'China',0.1,1)
insert into countries values(11,'France',0.15,2)
insert into zones values(1000,'China 1',10)
insert into zones values(1001,'China 2',10)
insert into zones values(1002,'France 1',11)

select * from countries

select zones.zone_name AS 'Zone',countries.country_name AS 'Country'
		from zones LEFT JOIN countries ON fk_country_id=pk_country_id
--end geography data

--sample supply chain data
insert into production_houses values(1,'Apple South Asia',10)
insert into warehouses values(1,'House 1',1,10)
insert into distributors values(1,'Vietnam Electronics',1,10)
insert into secondary_distributors values(1,'Hanoi Devices',1,10)
insert into channel_partners values(1,'Monsoon Suppliers',1,1000)
insert into stores values(1,'Apple Hanoi','4442 West road',1,1000)

select * from stores
select * from channel_partners
select * from secondary_distributors
select * from distributors
select * from warehouses
select * from production_houses

select * from cost_to_manufacture

use AppleIncDB

select * from stores 
		inner JOIN channel_partners ON fk_channel_partner_id=pk_channel_partner_id
		inner JOIN secondary_distributors ON fk_secondary_distributor_id=pk_secondary_distributor_id
		inner JOIN distributors ON fk_distributor_id=pk_distributor_id
		inner JOIN warehouses ON fk_distributor_id=pk_distributor_id
		inner JOIN production_houses ON fk_production_house_id=pk_production_house_id
--end supply chain data

insert into device_statuses values(1,'At Warehouse')
insert into device_statuses values(2,'At Distributor')
insert into device_statuses values(3,'At Sub Distributor')
insert into device_statuses values(4,'At Channel Partner')
insert into device_statuses values(5,'At Store')
insert into device_statuses values(6,'Sold')

insert into transaction_types values(1,'Sale')
insert into transaction_types values(2,'Shippment')
insert into transaction_types values(3,'Return')

insert into return_reasons values(1,'Screen')
insert into return_reasons values(2,'Battery')
insert into return_reasons values(3,'Wrong Model')
insert into return_reasons values(4,'No Longer Needed')
insert into return_reasons values(5,'Unsatisfied With Product')
insert into return_reasons values(6,'Other')

select * from device_statuses

insert into models values(1,'Model first',GETDATE())
insert into devices values(1,1)
insert into devices values(1,1)
insert into devices values(1,1)
insert into devices values(1,1)
insert into devices values(1,1)
insert into devices values(1,1)
insert into devices values(1,1)
insert into devices values(1,1)


select GETDATE() 

insert into models values (2,'Model Second',GETDATE())

select * from devices

select * from customers

select pk_serial_number as 'Device Serial Number',models.model_name as 'Model',device_statuses.device_status_name as 'Status' from devices
	inner join models on devices.fk_model_id = models.pk_model_id
	inner join device_statuses on devices.fk_device_status_id = device_statuses.pk_device_status_id

select * from countries

insert into countries values(64,'Cuba',0.20342123,5)

select country_name  as 'Country',country_tax as 'Tax Rate',continent_name as 'Continent' from countries inner join continents on countries.fk_continent_id = continents.pk_continent_id

select zone_name as 'Zone', country_name  as 'Country',continent_name as 'Continent'  from zones inner join countries on fk_country_id=pk_country_id 
					inner join continents on fk_continent_id = pk_continent_id
					order by pk_country_id,pk_continent_id

select count(zone_name) as 'Number of Zones' ,country_name from zones inner join countries on fk_country_id=pk_country_id group by country_name order by [Number of Zones]

select continent_name as 'Continent', count(zone_name) as 'Number of Zones' from zones inner join countries on fk_country_id=pk_country_id 
														inner join continents on fk_continent_id = pk_continent_id group by continent_name order by [Number of Zones]


select * from production_houses
select * from models
select * from cost_to_manufacture

delete from models where pk_model_id=2

select * from countries inner join continents on fk_continent_id=pk_continent_id

select * from production_houses

truncate table cost_to_manufacture

DECLARE @i int = 1
WHILE @i < 18
BEGIN
	DECLARE @n int = 1
	
	WHILE @n < 50
	BEGIN
		insert into cost_to_manufacture values(ROUND(RAND(CHECKSUM(NEWID())) * (1000), 2),18,@n)
		SET @n = @n + 1
	end
	SET @i = @i + 1

END


select * from countries
select * from production_houses


insert into warehouses values(1,concat('Warehouse ',1,'-',1,'-',(select top 1 country_name from countries where pk_country_id=1)),1,1)



if Object_id('find_countries_available_to_production_house') is not null
	drop function find_countries_available_to_production_house
go

--parameter, the id of the production house you wish to find the avaiable countries of
create function find_countries_available_to_production_house(
	@producion_house_id INT
)
returns table
as

return
	select pk_country_id,country_name,country_tax,fk_continent_id
	from countries where fk_continent_id in(
		select pk_continent_id from production_houses inner join countries on fk_country_id=pk_country_id
		inner join continents on fk_continent_id=pk_continent_id
		where pk_production_house_id = @producion_house_id
	)
go
--returns a table with the available countries to that production house

select * from find_countries_available_to_production_house(18)

DECLARE @j int = (select top 1 pk_country_id from find_countries_available_to_production_house(18) order by NEWID())

delete from warehouses

DECLARE @j int = 1
DECLARE @wearhouse_id int = 1
WHILE @j < 19
BEGIN
	
	declare @w int= 1
	while @w < 5
	begin
		declare @country_id int=(select top 1 pk_country_id from find_countries_available_to_production_house(@j)order by NEWID())
		insert into warehouses values(@wearhouse_id
								,concat('Warehouse ',@j,'-',@w,'-',(select top 1 country_name from countries where pk_country_id = @country_id)
								),@j,@country_id)
		SET @w = @w + 1
		set @wearhouse_id = @wearhouse_id +1
	end
	SET @j = @j + 1

END

select count(*)as 'Number of Warehouses',country_name from warehouses inner join countries on fk_country_id = pk_country_id
							inner join continents on fk_continent_id = pk_continent_id
							group by country_name
							order by 'Number of Warehouses'

select * from warehouses where fk_production_house_id = 3

select * from warehouses inner join countries on fk_country_id = pk_country_id
							inner join continents on fk_continent_id = pk_continent_id
							order by country_name

select * from zones inner join  countries on fk_country_id = pk_country_id order by country_name

delete from distributors

DECLARE @dist_iterator int = 1 
DECLARE @number_of_countries int = (select count(*) from countries)
while @dist_iterator<@number_of_countries+1
begin
	DECLARE @dist_warehouse_id int = (select top 1 pk_warehouse_id from find_warehouses_available_to_country(@dist_iterator)order by NEWID())

	insert into distributors values(@dist_iterator,concat('Distributor ',@dist_iterator),@dist_warehouse_id
				,@dist_iterator)
	SET @dist_iterator = @dist_iterator+1
end

select distributor_name,country_name from distributors inner join countries on fk_country_id = pk_country_id

select production_house_name,wearhouse_name,distributor_name,secondary_distributor_name,channel_partner_name,store_name,country_name,zone_name from stores
	inner join channel_partners on fk_channel_partner_id=pk_channel_partner_id
	inner join secondary_distributors on fk_secondary_distributor_id=pk_secondary_distributor_id
	inner join distributors on fk_distributor_id=pk_distributor_id
	inner join warehouses on fk_warehouse_id=pk_warehouse_id
	inner join production_houses on fk_production_house_id = pk_production_house_id
	inner join countries on secondary_distributors.fk_country_id=pk_country_id
	inner join zones on stores.fk_zone_id=pk_zone_id
	order by pk_production_house_id

if Object_id('find_warehouses_available_to_country') is not null
	drop function find_warehouses_available_to_country
go

--parameter, the id of the country you wish to find the avaiable warehouses of
create function find_warehouses_available_to_country(
	@country_id INT
)
returns table
as

return
	select pk_warehouse_id,wearhouse_name,fk_production_house_id,fk_country_id
	from warehouses where fk_country_id in(
		select pk_country_id from countries where fk_continent_id = (select fk_continent_id from countries 
			inner join continents on fk_continent_id=pk_continent_id 
			where pk_country_id = @country_id)
	)
go
--returns a table with the available warehouses to a country

select * from find_warehouses_available_to_country(30)

select * from warehouses


