----------------------------------------VIEWS----------------------------------------

if Object_id('v_geography_overview') is not null
	drop view v_geography_overview
go

create view v_geography_overview as
select zone_name as 'Zone',country_name as 'Country',continent_name as 'Continent' from zones inner join countries on fk_country_id=pk_country_id inner join continents on fk_continent_id = pk_continent_id

if Object_id('v_supply_overview') is not null
	drop view v_supply_overview
go

create view v_supply_overview as
select store_name as 'Store',channel_partner_name as 'Channel Partner',secondary_distributor_name as 'Sub Distibutor',distributor_name as 'Distibutor',wearhouse_name as 'Warehouse',production_house_name as 'Production House'
	from stores 
	inner join channel_partners on fk_channel_partner_id=pk_channel_partner_id
	inner join secondary_distributors on fk_secondary_distributor_id=pk_secondary_distributor_id
	inner join distributors on fk_distributor_id=pk_distributor_id
	inner join warehouses on fk_warehouse_id=pk_warehouse_id
	inner join production_houses on fk_production_house_id=pk_production_house_id


if Object_id('v_manufacture_events') is not null
	drop view v_manufacture_events
go

create view v_manufacture_events as
select * from device_history where fk_event_type_id = 0

if Object_id('v_devices_in_warehouses') is not null
	drop view v_devices_in_warehouses
go

create view v_devices_in_warehouses as
select pk_serial_number AS 'DeviceSerialNo', event_receiver_id as 'WarehouseId', post_event_device_cost as 'CurrentCost' from devices 
	inner join device_history on pk_serial_number = fk_device_serial_number where fk_device_status_id = 1 AND fk_event_type_id = 0

if Object_id('v_distributor_events') is not null
	drop view v_distributor_events
go

create view v_distributor_events as
select * from device_history where fk_event_type_id = 1


if Object_id('v_devices_with_a_distributor') is not null
	drop view v_devices_with_a_distributor
go

create view v_devices_with_a_distributor as
select pk_serial_number AS 'DeviceSerialNo', event_receiver_id as 'DistributorId', post_event_device_cost as 'CurrentCost' from devices 
	inner join device_history on pk_serial_number = fk_device_serial_number where fk_device_status_id = 2 AND fk_event_type_id = 1

if Object_id('v_sub_events') is not null
	drop view v_sub_events
go

create view v_sub_events as
select * from device_history where fk_event_type_id = 2

if Object_id('v_devices_with_a_sub') is not null
	drop view v_devices_with_a_sub
go

create view v_devices_with_a_sub as
select pk_serial_number AS 'DeviceSerialNo', event_receiver_id as 'SubId', post_event_device_cost as 'CurrentCost' from devices 
	inner join device_history on pk_serial_number = fk_device_serial_number where fk_device_status_id = 3 AND fk_event_type_id = 2


if Object_id('v_channel_events') is not null
	drop view v_channel_events
go

create view v_channel_events as
select * from device_history where fk_event_type_id = 3

if Object_id('v_devices_with_a_channel') is not null
	drop view v_devices_with_a_channel
go

create view v_devices_with_a_channel as
select pk_serial_number AS 'DeviceSerialNo', event_receiver_id as 'ChannelId', post_event_device_cost as 'CurrentCost' from devices 
	inner join device_history on pk_serial_number = fk_device_serial_number where fk_device_status_id = 4 AND fk_event_type_id = 3


if Object_id('v_store_events') is not null
	drop view v_store_events
go

create view v_store_events as
select * from device_history where fk_event_type_id = 4

if Object_id('v_devices_with_a_store') is not null
	drop view v_devices_with_a_store
go

create view v_devices_with_a_store as
select pk_serial_number AS 'DeviceSerialNo', event_receiver_id as 'StoreId', post_event_device_cost as 'CurrentCost' from devices 
	inner join device_history on pk_serial_number = fk_device_serial_number where fk_device_status_id = 5 AND fk_event_type_id = 4

if Object_id('v_sale_events') is not null
	drop view v_sale_events
go

create view v_sale_events as
select * from device_history where fk_event_type_id = 5

if Object_id('v_devices_owned_by_a_customer') is not null
	drop view v_devices_owned_by_a_customer
go

create view v_devices_owned_by_a_customer as
select pk_serial_number AS 'DeviceSerialNo', event_receiver_id as 'CustomerId', post_event_device_cost as 'CurrentCost' from devices 
	inner join device_history on pk_serial_number = fk_device_serial_number where fk_device_status_id = 6 AND fk_event_type_id = 5


if Object_id('v_return_events') is not null
	drop view v_return_events
go

create view v_return_events as
select * from device_history where fk_event_type_id = 6

if Object_id('v_List_Of_Store_Returns') is not null
	drop view v_List_Of_Store_Returns
go

create view v_List_Of_Store_Returns as
select event_receiver_id AS 'Store',fk_device_serial_number AS 'Device Returned' from device_history where fk_event_type_id = 6

if Object_id('v_Return_Reasons') is not null
	drop view v_Return_Reasons
go

create view v_Return_Reasons as
select pk_return_info_id As 'Return Id',model_name AS 'Model',pk_serial_number AS 'Serial_Number',return_desc AS 'Return_Notes',fk_transaction_id AS 'Transaction_Id'
	,return_reason_name AS 'Return_Reason',event_datetime AS 'Return_Date' from return_info 
	inner join return_reasons on fk_return_reason_id = pk_return_reason_id
	inner join device_history on fk_transaction_id=pk_device_history_id
	inner join devices on fk_device_serial_number=pk_serial_number
	inner join models on fk_model_id=pk_model_id

if Object_id('v_Random_Supply_Path') is not null
	drop view v_Random_Supply_Path
go

create view v_Random_Supply_Path as
select top 1 pk_store_id as 'Store',pk_channel_partner_id as 'Channel_Partner',pk_secondary_distributor_id as 'Sub_Distributor'
		,pk_distributor_id as 'Distributor',pk_warehouse_id as 'Warehouse',pk_production_house_id as 'Production_House' from stores 
	inner join channel_partners on fk_channel_partner_id=pk_channel_partner_id
	inner join secondary_distributors on fk_secondary_distributor_id = pk_secondary_distributor_id
	inner join distributors on fk_distributor_id = pk_distributor_id
	inner join warehouses on fk_warehouse_id = pk_warehouse_id
	inner join production_houses on fk_production_house_id = pk_production_house_id
	order by NEWID()


----------------------------------------END VIEWS----------------------------------------

----------------------------------------FUNCTIONS----------------------------------------

if Object_id('fn_warehouses_available_to_country') is not null
	drop function fn_warehouses_available_to_country
go

--parameter, the id of the country you wish to find the avaiable warehouses of
create function fn_warehouses_available_to_country(
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


if Object_id('fn_countries_available_to_production_house') is not null
	drop function fn_countries_available_to_production_house
go

--parameter, the id of the production house you wish to find the avaiable countries of
create function fn_countries_available_to_production_house(
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

if Object_id('fn_secondary_distributors_available_to_zone') is not null
	drop function fn_secondary_distributors_available_to_zone
go

--parameter, the id of the country you wish to find the avaiable warehouses of
create function fn_secondary_distributors_available_to_zone(
	@zone_id INT
)
returns table
as

return
	select pk_secondary_distributor_id,secondary_distributor_name,fk_distributor_id,fk_country_id
	from secondary_distributors where fk_country_id in(
		select fk_country_id from zones where pk_zone_id = @zone_id
	)
go
--returns a table with the available warehouses to a country

if Object_id('fn_devices_in_warehouse') is not null
	drop function fn_devices_in_warehouse
go

--parameter, the id of the warehouse you wish to find the inventory of
create function fn_devices_in_warehouse(
	@warehouse_id INT
)
returns table
as

return
	select DeviceSerialNo from v_devices_in_warehouses where WarehouseId = @warehouse_id
go
--returns a table with the warehouse inventory

if Object_id('fn_distributors_available_to_warehouse') is not null
	drop function fn_distributors_available_to_warehouse
go

--parameter, the warehouse of the country you wish to find the avaiable distributors of
create function fn_distributors_available_to_warehouse(
	@warehouse_id INT
)
returns table
as

return
	select pk_distributor_id from distributors where fk_warehouse_id=@warehouse_id
go
--returns a table with the available distributors to a warehouse


if Object_id('fn_devices_with_distributor') is not null
	drop function fn_devices_with_distributor
go

--parameter, the id of the distributor you wish to find the inventory of
create function fn_devices_with_distributor(
	@distributor_id INT
)
returns table
as

return
	select DeviceSerialNo from v_devices_with_a_distributor where DistributorId = @distributor_id
go
--returns a table with the warehouse inventory

if Object_id('fn_subs_available_to_distributor') is not null
	drop function fn_subs_available_to_distributor
go

--parameter, the warehouse of the country you wish to find the avaiable distributors of
create function fn_subs_available_to_distributor(
	@distributor_id INT
)
returns table
as

return
	select pk_secondary_distributor_id from secondary_distributors where fk_distributor_id=@distributor_id
go
--returns a table with the available distributors to a warehouse


if Object_id('fn_devices_with_sub') is not null
	drop function fn_devices_with_sub
go

--parameter, the id of the sub you wish to find the inventory of
create function fn_devices_with_sub(
	@sub_id INT
)
returns table
as

return
	select DeviceSerialNo from v_devices_with_a_sub where SubId = @sub_id
go
--returns a table with the sub inventory

if Object_id('fn_channels_available_to_sub') is not null
	drop function fn_channels_available_to_sub
go

--parameter, the warehouse of the country you wish to find the avaiable distributors of
create function fn_channels_available_to_sub(
	@sub_id INT
)
returns table
as

return
	select pk_channel_partner_id from channel_partners where fk_secondary_distributor_id=@sub_id
go
--returns a table with the available distributors to a warehouse



if Object_id('fn_devices_with_channel') is not null
	drop function fn_devices_with_channel
go

--parameter, the id of the channel you wish to find the inventory of
create function fn_devices_with_channel(
	@channel_id INT
)
returns table
as

return
	select DeviceSerialNo from v_devices_with_a_channel where ChannelId = @channel_id
go
--returns a table with the channel inventory

if Object_id('fn_Stores_available_to_Channel') is not null
	drop function fn_Stores_available_to_Channel
go

--parameter, the channel you want to find the stores of
create function fn_Stores_available_to_Channel(
	@channel_id INT
)
returns table
as

return
	select pk_store_id from stores where fk_channel_partner_id=@channel_id
go
--returns a table with the available stores to a channel


if Object_id('fn_devices_in_store') is not null
	drop function fn_devices_in_store
go

--parameter, the id of the channel you wish to find the inventory of
create function fn_devices_in_store(
	@store_id INT
)
returns table
as

return
	select DeviceSerialNo from v_devices_with_a_store where StoreId = @store_id
go
--returns a table with the channel inventory




if Object_id('fn_customer_devices') is not null
	drop function fn_customer_devices
go

--parameter, the id of the channel you wish to find the inventory of
create function fn_customer_devices(
	@customer_id INT
)
returns table
as

return
	select DeviceSerialNo from v_devices_owned_by_a_customer where CustomerId = @customer_id
go
--returns a table with the channel inventory

if Object_id('fn_find_returns_by_store') is not null
	drop function fn_find_returns_by_store
go

--parameter, the id of the channel you wish to find the inventory of
create function fn_find_returns_by_store(
	@store_id INT
)
returns table
as

return
	select event_receiver_id AS 'Store',fk_device_serial_number AS 'Device Returned' from device_history where event_receiver_id=@store_id AND fk_event_type_id = 6
go
--returns a table with all store returns




if Object_id('fn_device_history') is not null
	drop function fn_device_history
go

--parameter, the id of the channel you wish to find the inventory of
create function fn_device_history(
	@serial_number INT
)
returns table
as

return
	select fk_device_serial_number,event_sender_id,event_receiver_id,event_datetime,post_event_device_cost,event_type_desc from device_history 
		inner join event_types on fk_event_type_id=pk_event_type_id where fk_device_serial_number=@serial_number
--returns a table with all store returns
go

if Object_id('fn_find_number_of_models') is not null
	drop function fn_find_number_of_models
go

--parameter, the id of the channel you wish to find the inventory of
create function fn_find_number_of_models(
	@model_name varchar(30)
)
returns table
as

return
	select pk_serial_number as 'Device',model_name as 'Model' from devices inner join models on fk_model_id=pk_model_id where model_name=@model_name
--returns a table with all store returns
go

----------------------------------------END FUNCTIONS----------------------------------------


----------------------------------------PROCEDURES----------------------------------------

if Object_id('proc_manufacure_device') is not null
	drop procedure proc_manufacure_device
go
--create new device
--create device history with location where device was created
--warehouse must belong to the production house
--parameters production house device is made at,warehouse device will be stored at,model of device
CREATE PROCEDURE proc_manufacure_device
	@production_house int,
	@warehouse int,
	@model int
AS
begin
	if (select top 1 pk_warehouse_id from warehouses where fk_production_house_id = @production_house AND pk_warehouse_id = @warehouse)is not null
	begin
		insert into devices values(@model,1)
		declare @device_serial_no int  = (select top 1 pk_serial_number from devices order by pk_serial_number desc)
		declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1
		insert into device_history values(@event_id,@production_house,@warehouse,GETDATE()
			,(select top 1 cost_to_manufacture from cost_to_manufacture where fk_production_house_id=@production_house AND fk_model_id = @model),@device_serial_no,0)
	end
	else 
		PRINT N'ERROR: The warehouse in question does not belong to the Production House in question'
end

if Object_id('proc_manufacure_device_rand_warehouse') is not null
	drop procedure proc_manufacure_device_rand_warehouse
go
--create new device
--create device history with location where device was created
--parameters production house device is made at,model of device
CREATE PROCEDURE proc_manufacure_device_rand_warehouse
	@production_house int,
	@model int
AS
begin
	insert into devices values(@model,1)
	declare @device_serial_no int  = (select top 1 pk_serial_number from devices order by pk_serial_number desc)
	declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1
	declare @warehouse_id int = (select top 1 pk_warehouse_id from warehouses where fk_production_house_id = @production_house order by NEWID())

	insert into device_history values(@event_id,@production_house,@warehouse_id,GETDATE()
		,(select top 1 cost_to_manufacture from cost_to_manufacture where fk_production_house_id=@production_house AND fk_model_id = @model),@device_serial_no,0)

end

if Object_id('proc_ship_to_distriubutor') is not null
	drop procedure proc_ship_to_distriubutor
go

--distributor must belong to the same production house as the device 
--device must be currently in a warehouse
--parameters device to ship, distributor to ship to
CREATE PROCEDURE proc_ship_to_distriubutor
	@device_serial int,
	@distributor int
as
begin
	DECLARE @warehouse_id int = (select top 1 fk_warehouse_id from distributors where pk_distributor_id=@distributor)

	IF (select top 1 DeviceSerialNo from v_devices_in_warehouses where DeviceSerialNo = @device_serial AND WarehouseId=@warehouse_id)is not null
	begin
		--change device status
		--insert into device history with updated price
		declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1
		insert into device_history values(@event_id,@warehouse_id,@distributor,GETDATE()
			,(select top 1 CurrentCost from v_devices_in_warehouses where DeviceSerialNo = @device_serial)*1.08,@device_serial,1)
		update devices set fk_device_status_id=2 where pk_serial_number=@device_serial
	end
	else
	PRINT N'ERROR: The device cannot be shipped to this distributor'
end

if Object_id('proc_ship_to_sub') is not null
	drop procedure proc_ship_to_sub
go

--sub distributor must belong to distributor of device
--device must be currently with a distributor
--parameters device to ship, sub distributor to ship to
CREATE PROCEDURE proc_ship_to_sub
	@device_serial int,
	@sub int
as
begin
	DECLARE @distributor_id int = (select top 1 fk_distributor_id from secondary_distributors where pk_secondary_distributor_id=@sub)

	IF (select top 1 DeviceSerialNo from v_devices_with_a_distributor where DeviceSerialNo = @device_serial AND DistributorId=@distributor_id)is not null
	begin
		--change device status
		--insert into device history with updated price
		declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1
		insert into device_history values(@event_id,@distributor_id,@sub,GETDATE()
			,(select top 1 CurrentCost from v_devices_with_a_distributor where DeviceSerialNo = @device_serial)*1.08,@device_serial,2)
		update devices set fk_device_status_id=3 where pk_serial_number=@device_serial
	end
	else
	PRINT N'ERROR: The device cannot be shipped to this sub distributor'
end

if Object_id('proc_ship_to_channel') is not null
	drop procedure proc_ship_to_channel
go

--channel must belong to sub of device
--device must be currently with a sub
--parameters device to ship, channel partner to ship to
CREATE PROCEDURE proc_ship_to_channel
	@device_serial int,
	@channel int
as
begin
	DECLARE @sub_id int = (select top 1 fk_secondary_distributor_id from channel_partners where pk_channel_partner_id=@channel)

	IF (select top 1 DeviceSerialNo from v_devices_with_a_sub where DeviceSerialNo = @device_serial AND SubId=@sub_id)is not null
	begin
		--change device status
		--insert into device history with updated price
		declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1
		insert into device_history values(@event_id,@sub_id,@channel,GETDATE()
			,(select top 1 CurrentCost from v_devices_with_a_sub where DeviceSerialNo = @device_serial)*1.08,@device_serial,3)
		update devices set fk_device_status_id=4 where pk_serial_number=@device_serial
	end
	else
	PRINT N'ERROR: The device cannot be shipped to this channel partner'
end


if Object_id('proc_channel_to_store') is not null
	drop procedure proc_channel_to_store
go

--store must belong to channel of device
--device must be currently with a channel
--parameters device to ship, store to ship to
CREATE PROCEDURE proc_channel_to_store
	@device_serial int,
	@store int
as
begin
	DECLARE @channel_id int = (select top 1 fk_channel_partner_id from stores where pk_store_id=@store)

	IF (select top 1 DeviceSerialNo from v_devices_with_a_channel where DeviceSerialNo = @device_serial AND ChannelId=@channel_id)is not null
	begin
		--change device status
		--insert into device history with updated price
		declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1
		insert into device_history values(@event_id,@channel_id,@store,GETDATE()
			,(select top 1 CurrentCost from v_devices_with_a_channel where DeviceSerialNo = @device_serial)*1.08,@device_serial,4)
		update devices set fk_device_status_id=5 where pk_serial_number=@device_serial
	end
	else
	PRINT N'ERROR: The device cannot be shipped to this store'
end


if Object_id('proc_sell_to_customer') is not null
	drop procedure proc_sell_to_customer
go

--device must be currently in a store
--parameters device to sell, customer to sell to
CREATE PROCEDURE proc_sell_to_customer
	@device_serial int,
	@customer int
as
begin 

	IF (select top 1 DeviceSerialNo from v_devices_with_a_store where DeviceSerialNo = @device_serial)is not null
	begin
		DECLARE @store_id int = (select top 1 StoreId from v_devices_with_a_store where DeviceSerialNo = @device_serial)
		declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1

		insert into device_history values(@event_id,@store_id,@customer,GETDATE()
			,(select top 1 CurrentCost from v_devices_with_a_store where DeviceSerialNo = @device_serial)*1.08,@device_serial,5)
		update devices set fk_device_status_id=6 where pk_serial_number=@device_serial
	end
	else
	PRINT N'ERROR: The device is not at a store'
end


if Object_id('proc_return_a_device') is not null
	drop procedure proc_return_a_device
go

--device must be already sold
--parameters serial number of device to return,discription of return,return category
CREATE PROCEDURE proc_return_a_device
	@device_serial int,
	@return_desc varchar(200),
	@return_reason int
as
begin 

	IF (select top 1 DeviceSerialNo from v_devices_owned_by_a_customer where DeviceSerialNo = @device_serial)is not null
	begin
		DECLARE @return_cost float = (select top 1 CurrentCost from v_devices_owned_by_a_customer where DeviceSerialNo = @device_serial)

		DECLARE @customer_id int = (select top 1 CustomerId from v_devices_owned_by_a_customer where DeviceSerialNo = @device_serial)
		DECLARE @store_id int = (select top 1 event_sender_id from device_history where event_receiver_id=@customer_id AND fk_device_serial_number=@device_serial AND fk_event_type_id=5)
		DECLARE @channel_id int = (select top 1 event_sender_id from device_history where event_receiver_id=@store_id AND fk_device_serial_number=@device_serial AND fk_event_type_id=4)
		DECLARE @sub_id int = (select top 1 event_sender_id from device_history where event_receiver_id=@channel_id AND fk_device_serial_number=@device_serial AND fk_event_type_id=3)
		DECLARE @distributor_id int = (select top 1 event_sender_id from device_history where event_receiver_id=@sub_id AND fk_device_serial_number=@device_serial AND fk_event_type_id=2)
		DECLARE @warehouse_id int = (select top 1 event_sender_id from device_history where event_receiver_id=@distributor_id AND fk_device_serial_number=@device_serial AND fk_event_type_id=1)
		DECLARE @production_house_id int = (select top 1 event_sender_id from device_history where event_receiver_id=@warehouse_id AND fk_device_serial_number=@device_serial AND fk_event_type_id=0)

		declare @event_id int = (select top 1 pk_device_history_id from device_history order by pk_device_history_id desc)+1
		declare @return_id int = (select top 1 pk_return_info_id from return_info order by pk_return_info_id desc)+1

		insert into device_history values(@event_id,@customer_id,@store_id,GETDATE(),@return_cost,@device_serial,6)
		insert into return_info values(@return_id,@return_desc,@event_id,@return_reason)

		SET @event_id = @event_id+1
		insert into device_history values(@event_id,@store_id,@channel_id,GETDATE(),@return_cost,@device_serial,7)

		SET @event_id = @event_id+1
		insert into device_history values(@event_id,@channel_id,@sub_id,GETDATE(),@return_cost,@device_serial,8)

		SET @event_id = @event_id+1
		insert into device_history values(@event_id,@sub_id,@distributor_id,GETDATE(),@return_cost,@device_serial,9)

		SET @event_id = @event_id+1
		insert into device_history values(@event_id,@distributor_id,@warehouse_id,GETDATE(),@return_cost,@device_serial,10)

		SET @event_id = @event_id+1
		insert into device_history values(@event_id,@warehouse_id,@production_house_id,GETDATE(),@return_cost,@device_serial,11)

		update devices set fk_device_status_id=12 where pk_serial_number=@device_serial
	end
	else
	PRINT N'ERROR: The device is not at a store'
end

if Object_id('proc_enter_random_data') is not null
	drop procedure proc_enter_random_data
go

--device must be currently in a store
--parameters device to sell, customer to sell to
CREATE PROCEDURE proc_enter_random_data
	@dataAmount int
as
begin 

	DECLARE @iterator int = 1
	while @iterator <@dataAmount
	begin

		declare @ph int
		declare @wh int
		declare @di int
		declare @sd int
		declare @cp int
		declare @st int

		select @ph=Production_House,@wh=Warehouse,@di=Distributor,@sd=Sub_Distributor,@cp=Channel_Partner,@st=Store from v_Random_Supply_Path

		declare @model int = (select RAND()*(50-1)+1)
		exec proc_manufacure_device @production_house=@ph,@warehouse=@wh,@model=@model

		declare @number int = (select top 1 pk_serial_number from devices order by pk_serial_number desc)

		declare @random int = (select RAND()*(10-1)+1)

		declare @randomReason int = (select RAND()*(6-1)+1)

		if @random>2 
		begin 
			exec proc_ship_to_distriubutor @number,@di
			if @random>3
			begin
				exec proc_ship_to_sub @number,@sd
				if @random>4
				begin
					exec proc_ship_to_channel @number,@cp
					if @random>5
					begin
						exec proc_channel_to_store @number,@st
						exec proc_sell_to_customer @number,@model
						exec proc_return_a_device @number,'Example',@randomReason
					end
				end
			end
		end
		set @iterator = @iterator +1
	end
end

----------------------------------------END PROCEDURES----------------------------------------

----------------------------------------INDEXES----------------------------------------

if Object_id('i_event_serial_no') is not null
	drop index i_event_serial_no ON device_history
go

CREATE INDEX i_event_serial_no
ON device_history(fk_device_serial_number)

if Object_id('i_event_sender') is not null
	drop index i_event_sender ON device_history
go

CREATE INDEX i_event_sender
ON device_history(event_sender_id)

if Object_id('i_event_receiver') is not null
	drop index i_event_receiver ON device_history
go

CREATE INDEX i_event_receiver
ON device_history(event_receiver_id)


----------------------------------------END INDEXES----------------------------------------