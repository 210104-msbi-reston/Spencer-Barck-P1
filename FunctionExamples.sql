
--views

select * from v_manufacture_events
select * from v_distributor_events
select * from v_sub_events
select * from v_channel_events
select * from v_store_events
select * from v_sale_events
select * from v_return_events

select * from v_devices_in_warehouses
select * from v_devices_with_a_distributor
select * from v_devices_with_a_sub
select * from v_devices_with_a_channel
select * from v_devices_with_a_store
select * from v_devices_owned_by_a_customer

select * from v_List_Of_Store_Returns
select * from v_List_Of_Store_Returns order by Store

select * from v_Return_Reasons
select count(*) from v_Return_Reasons where Return_Reason = 'Screen'

select * from v_Random_Supply_Path

--functions

select * from fn_warehouses_available_to_country(3)

select * from fn_countries_available_to_production_house(4)

select * from fn_secondary_distributors_available_to_zone(400)
select * from fn_distributors_available_to_warehouse(3)
select * from fn_subs_available_to_distributor(30)
select * from fn_channels_available_to_sub(70)
select * from fn_Stores_available_to_Channel(512)

select * from fn_devices_in_warehouse(3)
select * from fn_devices_with_distributor(20)
select * from fn_devices_with_sub(60)
select * from fn_devices_with_channel(512)
select * from fn_devices_in_store(1371)

select * from fn_customer_devices(10)

select * from fn_find_returns_by_store(25)

select * from fn_device_history(1001899)
select * from device_history order by fk_event_type_id desc

exec proc_enter_random_data 30