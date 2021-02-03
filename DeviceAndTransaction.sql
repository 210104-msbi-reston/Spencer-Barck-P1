
select * from customers

select * from models
select * from cost_to_manufacture

select * from devices
select * from device_history

select * from return_info

select * from device_statuses
select * from return_reasons
select * from event_types

select * from continents
select * from countries
select * from zones

select * from stores 
		inner JOIN channel_partners ON fk_channel_partner_id=pk_channel_partner_id
		inner JOIN secondary_distributors ON fk_secondary_distributor_id=pk_secondary_distributor_id
		inner JOIN distributors ON fk_distributor_id=pk_distributor_id
		inner JOIN warehouses ON fk_distributor_id=pk_distributor_id
		inner JOIN production_houses ON fk_production_house_id=pk_production_house_id


select production_house_name,wearhouse_name,distributor_name,secondary_distributor_name,channel_partner_name,store_name,country_name,zone_name from stores
	inner join channel_partners on fk_channel_partner_id=pk_channel_partner_id
	inner join secondary_distributors on fk_secondary_distributor_id=pk_secondary_distributor_id
	inner join distributors on fk_distributor_id=pk_distributor_id
	inner join warehouses on fk_warehouse_id=pk_warehouse_id
	inner join production_houses on fk_production_house_id = pk_production_house_id
	inner join countries on secondary_distributors.fk_country_id=pk_country_id
	inner join zones on stores.fk_zone_id=pk_zone_id
	order by pk_production_house_id

if Object_id('return_info') is not null
	drop table return_info
go

select * from return_info

--create return_info table
create table return_info
(
	pk_return_info_id int primary key,
	return_desc varchar(50),
	fk_transaction_id int,
	fk_return_reason_id int,
	FOREIGN KEY (fk_transaction_id) REFERENCES device_history(pk_device_history_id),
	FOREIGN KEY (fk_return_reason_id) REFERENCES return_reasons(pk_return_reason_id)
)
--end create return_info table

if Object_id('device_history') is not null
	drop table device_history
go

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

if Object_id('event_types') is not null
	drop table event_types
go

--the types of transactions shipping/production/selling/return
create table event_types(
	pk_event_type_id int primary key,
	event_type_desc varchar(50)
)


insert into event_types values(1,'Sale')
insert into event_types values(2,'Shippment')
insert into event_types values(3,'Return')


if Object_id('devices') is not null
	drop table devices
go

--create device table
create table devices
(
	pk_serial_number int primary key identity(1000000,1),
	fk_model_id int not null  REFERENCES models(pk_model_id),
	fk_device_status_id int,
	FOREIGN KEY (fk_device_status_id) REFERENCES device_statuses(pk_device_status_id)
)
--end create device table



