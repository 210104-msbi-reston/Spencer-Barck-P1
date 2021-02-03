
--sub distributor
--distributor
--country

DECLARE @sub_dist_iterator int = 1 
DECLARE @number_of_distributors int = (select count(*) from distributors)
DEClARE @sub_distrubutor_count int = 1
while @sub_dist_iterator<@number_of_distributors+1
begin

	insert into secondary_distributors values(@sub_distrubutor_count,concat('Sub Distributor ',@sub_distrubutor_count),@sub_dist_iterator
				,(select fk_country_id from distributors where pk_distributor_id=@sub_dist_iterator))
	SET @sub_distrubutor_count = @sub_distrubutor_count+1

	insert into secondary_distributors values(@sub_distrubutor_count,concat('Sub Distributor ',@sub_distrubutor_count),@sub_dist_iterator
				,(select fk_country_id from distributors where pk_distributor_id=@sub_dist_iterator))
	SET @sub_distrubutor_count = @sub_distrubutor_count+1

	SET @sub_dist_iterator = @sub_dist_iterator+1
end

select * from secondary_distributors



select production_house_name,wearhouse_name,distributor_name,secondary_distributor_name from secondary_distributors
	inner join distributors on fk_distributor_id = pk_distributor_id
	inner join warehouses on fk_warehouse_id=pk_warehouse_id
	inner join production_houses on fk_production_house_id = pk_production_house_id
	order by pk_production_house_id

--create channel_partners table
create table channel_partners(
	pk_channel_partner_id int PRIMARY KEY,
	channel_partner_name varchar(20) unique not null,
	fk_secondary_distributor_id int not null,
	fk_zone_id int not null,
	FOREIGN KEY (fk_secondary_distributor_id) REFERENCES secondary_distributors(pk_secondary_distributor_id),
	FOREIGN KEY (fk_zone_id) REFERENCES zones(pk_zone_id)
)
--end create stores tabl


--secondary distributor id 
--zone id

DECLARE @chan_iterator int = 1
DECLARE @number_of_zones int = (select count(*) from zones)
DECLARE @chan_count int = 1
while @chan_iterator<@number_of_zones+1
begin
	
	DECLARE @dist_id int =(select top 1 pk_secondary_distributor_id from find_secondary_distributors_available_to_zone(@chan_iterator) order by secondary_distributor_name)
	DECLARE @dist_id2 int =(select top 1 pk_secondary_distributor_id from find_secondary_distributors_available_to_zone(@chan_iterator) order by secondary_distributor_name DESC)

	insert into channel_partners values(@chan_count,concat('Channel Partner ',@chan_count),@dist_id,@chan_iterator)
	SET @chan_count = @chan_count+1
	insert into channel_partners values(@chan_count,concat('Channel Partner ',@chan_count),@dist_id2,@chan_iterator)
	SET @chan_count = @chan_count+1

	SET @chan_iterator = @chan_iterator+1
end

select * from channel_partners

delete from channel_partners

DECLARE @dist_iterator int = 1 
DECLARE @number_of_countries int = (select count(*) from countries)
while @dist_iterator<@number_of_countries+1
begin
	DECLARE @dist_warehouse_id int = (select top 1 pk_warehouse_id from find_warehouses_available_to_country(@dist_iterator)order by NEWID())

	insert into distributors values(@dist_iterator,concat('Distributor ',@dist_iterator),@dist_warehouse_id
				,@dist_iterator)
	SET @dist_iterator = @dist_iterator+1
end


if Object_id('find_secondary_distributors_available_to_zone') is not null
	drop function find_secondary_distributors_available_to_zone
go

--parameter, the id of the country you wish to find the avaiable warehouses of
create function find_secondary_distributors_available_to_zone(
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

select top 1 * from find_secondary_distributors_available_to_zone(29) order by secondary_distributor_name

select top 1 * from find_secondary_distributors_available_to_zone(29) order by secondary_distributor_name DESC

select * from zones

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

--channel partner id
--zone id

delete from stores

DECLARE @store_iterator int = 1 
DECLARE @number_of_sub_dist int = (select count(*) from channel_partners)
DECLARE @store_count int = 1
while @store_iterator<@number_of_sub_dist+1
begin
	DECLARE @store_zone_id int = (select top 1 fk_zone_id from channel_partners where pk_channel_partner_id=@store_iterator)

	insert into stores values(@store_count,concat('Store ',@store_count),concat('Address ',@store_count),@store_iterator,@store_zone_id)
	SET @store_count = @store_count+1
	insert into stores values(@store_count,concat('Store ',@store_count),concat('Address ',@store_count),@store_iterator,@store_zone_id)
	SET @store_count = @store_count+1
	insert into stores values(@store_count,concat('Store ',@store_count),concat('Address ',@store_count),@store_iterator,@store_zone_id)
	SET @store_count = @store_count+1

	SET @store_iterator = @store_iterator+1
end

select * from stores


if Object_id('find_secondary_distributors_available_to_zone') is not null
	drop function find_secondary_distributors_available_to_zone
go


select * from device_statuses

insert into event_types values(0,'Manufacture')

select * from event_types

insert into device_statuses values (7,'Return At Store')
insert into device_statuses values (8,'Return At Channel Partner')
insert into device_statuses values (9,'Return At Sub Distributor')
insert into device_statuses values (10,'Return At Distributor')
insert into device_statuses values (11,'Return At Warehouse')

select * from devices
select * from models


select * from cost_to_manufacture
select * from event_types

if Object_id('proc_manufacure_device') is not null
	drop procedure proc_manufacure_device
go
--create new device
--create device history with location where device was created
--warehouse must belong to the production house
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

exec proc_manufacure_device 1,100,1

if Object_id('proc_manufacure_device_rand_warehouse') is not null
	drop procedure proc_manufacure_device_rand_warehouse
go
--create new device
--create device history with location where device was created
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

exec proc_manufacure_device 1,1,1

exec proc_manufacure_device_rand_warehouse 1,1

select * from production_houses
select * from warehouses

insert into devices values(1,1)
insert into device_history values(1,1,1,GETDATE()
		,(select top 1 cost_to_manufacture from cost_to_manufacture where fk_production_house_id=1 AND fk_model_id = 1),1000006,0)

delete from devices


declare @i int = 1
while @i <200
begin
	declare @prod_house_rand int = (select RAND()*(18-1)+1)
	declare @model_rand int = (select RAND()*(50-1)+1)
	exec proc_manufacure_device_rand_warehouse @prod_house_rand,@model_rand
	SET @i = @i+1
end

select * from event_types
select * from device_history


select fk_device_serial_number,model_name,post_event_device_cost,production_house_name,event_type_desc from device_history 
			inner join devices on fk_device_serial_number = pk_serial_number
			inner join models on fk_model_id = pk_model_id
			inner join event_types on fk_event_type_id = pk_event_type_id
			inner join production_houses on event_sender_id = pk_production_house_id


if Object_id('v_manufacture_events') is not null
	drop view v_manufacture_events
go

create view v_manufacture_events as
select * from device_history where fk_event_type_id = 0

select * from v_manufacture_events


if Object_id('proc_ship_to_distriubutor') is not null
	drop procedure proc_ship_to_distriubutor
go

--distributor must belong to the same production house as the device 
--device must be currently in a warehouse
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
	PRINT N'ERROR: The device cannot be shipped to this distributor'
end

select * from devices

select * from v_devices_in_warehouses

select * from distributors

proc_ship_to_distriubutor 1000233,17

select * from device_history

select top 1 WarehouseId from v_devices_in_warehouses where DeviceSerialNo = 1000006
select top 1 DeviceSerialNo from v_devices_in_warehouses where DeviceSerialNo = 1000006

delete from device_history where fk_device_serial_number = 1000006

select post_event_device_cost from device_history where fk_device_serial_number = 1000008

select * from distributors inner join warehouses on fk_warehouse_id = pk_warehouse_id

select * from warehouses

declare @itorator int = 1
declare @num_warehouses int = (select count(*) from warehouses)
while @itorator<@num_warehouses
begin
	if (select top 1 pk_distributor_id from fn_distributors_available_to_warehouse(@itorator))is not null
	begin
		DECLARE @device_to_ship int= (select top 1 DeviceSerialNo from fn_devices_in_warehouse(@itorator))
		DECLARE @dist int=(select top 1 pk_distributor_id from fn_distributors_available_to_warehouse(@itorator))

		exec proc_ship_to_distriubutor @device_to_ship,@dist
	end
	set @itorator = @itorator +1
end

select pk_serial_number,device_status_name from device_history inner join devices on fk_device_serial_number=pk_serial_number inner join device_statuses on fk_device_status_id = pk_device_status_id

select * from device_history


if Object_id('proc_ship_to_sub') is not null
	drop procedure proc_ship_to_sub
go

--sub distributor must belong to distributor of device
--device must be currently with a distributor
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
	PRINT N'ERROR: The device cannot be shipped to this distributor'
end

select * from device_history where fk_device_serial_number = 1000231
select * from secondary_distributors

exec proc_ship_to_sub 1000256,93

select * from devices where pk_serial_number = 1000231

select * from secondary_distributors where fk_distributor_id = 47

select * from v_devices_with_a_distributor where DistributorId=66
select top 1 fk_distributor_id from secondary_distributors where pk_secondary_distributor_id=119

select * from device_statuses


if Object_id('proc_ship_to_channel') is not null
	drop procedure proc_ship_to_channel
go

--channel must belong to sub of device
--device must be currently with a sub
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
		update devices set fk_device_status_id=3 where pk_serial_number=@device_serial
	end
	else
	PRINT N'ERROR: The device cannot be shipped to this distributor'
end



exec proc_ship_to_channel 1000256,161

select * from device_history

select * from secondary_distributors where fk_distributor_id = 55

exec proc_ship_to_sub 1000227,109

select * from channel_partners where fk_secondary_distributor_id = 109

exec proc_ship_to_channel 1000227,19

select * from devices order by fk_device_status_id
select * from device_history order by fk_event_type_id

update devices set fk_device_status_id=4 where pk_serial_number= 1000227

select * from event_types

if Object_id('proc_channel_to_store') is not null
	drop procedure proc_channel_to_store
go

--store must belong to channel of device
--device must be currently with a channel
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
	PRINT N'ERROR: The device cannot be shipped to this distributor'
end

1000227

delete from device_history where pk_device_history_id = 454

select * from device_history order by fk_event_type_id desc
exec proc_channel_to_store 1000227,56

update devices set fk_device_status_id=4 where pk_serial_number= 1000227

select * from c where fk_channel_partner_id = 190

select * from channel_partners where fk_secondary_distributor_id = 109
select * from stores where fk_channel_partner_id = 19

select * from devices where pk_serial_number = 1000227


if Object_id('proc_sell_to_customer') is not null
	drop procedure proc_sell_to_customer
go

--device must be currently in a store
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

select * from customers

exec proc_sell_to_customer 1000227,10


select * from return_info


if Object_id('proc_return_a_device') is not null
	drop procedure proc_return_a_device
go

--device must be already sold
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

insert into return_info values(0,' ',2,1)

select * from device_history

select * from event_types

select * from device_statuses

insert into device_statuses values(12,'Return At Product House')

exec proc_return_a_device 1000227,'This is a device return description',1

select * from devices where pk_serial_number=1000227

update devices set fk_device_status_id = 6 where pk_serial_number = 1000227

delete from device_history where fk_event_type_id >5



select * from event_types

	delete from event_types where pk_event_type_id >0

	insert into event_types values(1,'WH to Distributor')
	insert into event_types values(2,'Distributor To Sub')
	insert into event_types values(3,'Sub To Chan')
	insert into event_types values(4,'Chan To Store')
	insert into event_types values(5,'Sale')
	insert into event_types values(6,'Return')
	insert into event_types values(7,'Return to Chan')
	insert into event_types values(8,'Return To Sub')
	insert into event_types values(9,'Return To Distributor')
	insert into event_types values(10,'Return To Warehouse')


select * from customers

select * from models
select * from cost_to_manufacture

select * from devices
select event_receiver_id from device_history

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


	
select * from v_manufacture_events 
	left join v_distributor_events on v_distributor_events.fk_device_serial_number=v_manufacture_events.fk_device_serial_number
	left join v_sub_events on v_manufacture_events.fk_device_serial_number=v_sub_events.fk_device_serial_number

	select fk_device_serial_number from device_history 

DECLARE @iterator int = 1
while @iterator <50
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

select * from device_history where fk_event_type_id=0 order by event_sender_id 
select * from devices 

select * from cost_to_manufacture

select * from customers

select * from return_reasons

select * from return_info inner join return_reasons on fk_return_reason_id = pk_return_reason_id