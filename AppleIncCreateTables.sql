
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

if Object_id('device_history') is not null
	drop table device_history
go

if Object_id('event_types') is not null
	drop table event_types
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

--the types of events shipping/production/selling/return
create table event_types(
	pk_event_type_id int primary key,
	event_type_desc varchar(50)
)

--create device history table
create table device_history
(
	pk_device_history_id int primary key,
	event_sender_id int,
	event_receiver_id int,
	event_datetime datetime,
	post_event_device_cost float,
	fk_device_serial_number int not null,
	fk_event_type_id int,
	FOREIGN KEY (fk_device_serial_number) REFERENCES devices(pk_serial_number),
	FOREIGN KEY (fk_event_type_id) REFERENCES event_types(pk_event_type_id)
)
--end create device history table

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
	FOREIGN KEY (fk_transaction_id) REFERENCES device_history(pk_device_history_id),
	FOREIGN KEY (fk_return_reason_id) REFERENCES return_reasons(pk_return_reason_id)
)
