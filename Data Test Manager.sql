create database CaseStudy

use CaseStudy 

--Booking Payment detailed:
--This table contains the operations done per date (operation_date_time)  ,  
--one row per operation,  the amount is in the operation_amount   field.

CREATE TABLE booking_payment_detailed (
    booking_code           CHAR(20)       NOT NULL,
    ticket_number          CHAR(16)       NOT NULL,
    operation_date_time    DATETIME2      NOT NULL,
    base_price             DECIMAL(18,2)  NOT NULL,
    base_price_vat         DECIMAL(18,2)  NOT NULL,
    management_fee         DECIMAL(18,2)  NOT NULL,
    management_fee_vat     DECIMAL(18,2)  NOT NULL,
    payment_fee            DECIMAL(18,2)  NOT NULL,
    payment_fee_vat        DECIMAL(18,2)  NOT NULL,
    operation_amount       DECIMAL(18,2)  NOT NULL,
    penalty_tariff         DECIMAL(18,2)  NOT NULL,
    amount_not_refunded    DECIMAL(18,2)  NULL,
    compensation_type      NVARCHAR(MAX)  NULL,
    compensation_reason    NVARCHAR(MAX)  NULL,
    compensation_status    NVARCHAR(MAX)  NULL,
    card_number            NVARCHAR(MAX)  NULL,
    authorization_code     BIGINT         NULL,
    order_id               NVARCHAR(MAX)  NULL,
    transaction_id         NVARCHAR(MAX)  NULL,
    status_payment_card    NVARCHAR(MAX)  NULL,
    card_brand             NVARCHAR(MAX)  NULL,
    bill_number            DECIMAL(18,2)  NULL,
    bill_status            NVARCHAR(MAX)  NULL,
    train_number           NVARCHAR(50)   NOT NULL,
    departure_date_time    DATETIME2      NOT NULL,
    arrival_date_time      DATETIME2      NOT NULL,
    od                     NVARCHAR(100)  NOT NULL,
    origin_station         NVARCHAR(50)   NOT NULL,
    destination_station    NVARCHAR(50)   NOT NULL,
    class                  NVARCHAR(50)   NOT NULL,
    tariff                 NVARCHAR(50)   NOT NULL,
    reserved_number_of_seats SMALLINT     NULL,
    status                 NVARCHAR(50)   NOT NULL,
    card_serial_number     INT            NULL,
    card_user_name         NVARCHAR(100)  NULL,
    sales_station          NVARCHAR(100)  NULL,
    sales_channel          NVARCHAR(100)  NOT NULL,
    equipment_code         NVARCHAR(100)  NULL,
    payment_mode           NVARCHAR(50)   NOT NULL,
    coach_number           SMALLINT       NULL,
    seat_number            SMALLINT       NULL,
    country_code           CHAR(4)        NULL,
    name                   NVARCHAR(100)  NULL,
    surname                NVARCHAR(100)  NULL,
    gender                 NVARCHAR(50)   NULL,
    document_type          NVARCHAR(50)   NULL,
    document               NVARCHAR(100)  NULL,
    prefix                 NVARCHAR(10)   NULL,
    telephone              NVARCHAR(50)   NULL,
    email                  NVARCHAR(255)  NULL,
    profile                NVARCHAR(50)   NULL,
    validating_time        DATETIME2      NULL,
    checked_on_board       NVARCHAR(10)   NULL,
    detail_type            SMALLINT       NULL,
    tipology               NVARCHAR(50)   NULL,
    compensated            CHAR(3)        NULL,
    include_fare_revenue   CHAR(3)        NULL,
    last_operation_channel NVARCHAR(10)   NULL,
    last_operation_equipment_code NVARCHAR(10) NULL
);

select * from booking_payment_detailed

/* Train List 
This table contains the tickets traveling per departure date (departure_date)  ,  one row per ticket,  the amount is in the     operation_amount   field.

IMPORTANT
The field  groupyn  is YES when the booking code  (booking_code field)   is for a group
*/

CREATE TABLE train_list
(
    departure_date DATETIMEOFFSET NOT NULL,
    train_number VARCHAR(5) NOT NULL,
    od VARCHAR(35) NOT NULL,
    origin_station VARCHAR(5) NOT NULL,
    destination_station VARCHAR(5) NOT NULL,
    coach_number VARCHAR(5) NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    class VARCHAR(20) NOT NULL,
    booking_code VARCHAR(10) NOT NULL,
    ticket_number VARCHAR(20) NOT NULL,
    tariff VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    payment_mode VARCHAR(20),
    media_type VARCHAR(10),
    sales_channel VARCHAR(10) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    vat_base_price DECIMAL(10,2) NOT NULL,
    management_fee DECIMAL(10,2) NOT NULL,
    vat_management_fee DECIMAL(10,2) NOT NULL,
    payment_fee DECIMAL(10,2) NOT NULL,
    vat_payment_fee DECIMAL(10,2) NOT NULL,
    operation_amount DECIMAL(10,2) NOT NULL,
    penalty_tariff DECIMAL(10,2) NOT NULL,
    amount_not_refunded DECIMAL(10,2),
    compensation_type VARCHAR(40),
    compensation_reason VARCHAR(MAX),
    compensation_status VARCHAR(45),
    nationality VARCHAR(5),
    gender VARCHAR(10),
    name VARCHAR(50),
    surname VARCHAR(100),
    document VARCHAR(20),
    prefix VARCHAR(5),
    telephone VARCHAR(15),
    profile VARCHAR(20),
    special_needs VARCHAR(35),
    validating_time DATETIMEOFFSET,
    groupyn VARCHAR(5),
    checked_on_board VARCHAR(5),
    train_hour TIME,
    departure_date_short DATE,
    train_od_short VARCHAR(20),
    stretch VARCHAR(20),
    week_day VARCHAR(5),
    week_num DECIMAL(3,0),
    train_key VARCHAR(40),
    train_departure_date_time DATETIME,
    train_departure_date_short DATE,
    last_operation_channel VARCHAR(10),
    last_operation_equipment_code VARCHAR(10),
    service_train_departure_date_short DATETIME,
    operation_date_time DATETIME,
    operation_date DATE,
    birth_date DATE,
    CONSTRAINT PK_train_list PRIMARY KEY (ticket_number)
);

select * from booking_payment_detailed

select * from train_list

/*
1.	Sales per month: Accessing the Booking Payment Detailed table fill in the following excel table:

Sales per month
			
Year 	Month	Number of operations	Total amount
2024	01		956,000					2,056,883.00
2024	02		
*/

select
	Year(operation_date_time) as Year,
	MONTH(operation_date_time) as Month,
	count(*) as 'Number of operations',
	SUM(operation_amount) as 'Total amount'
from
	booking_payment_detailed
group by
	Year(operation_date_time),
	MONTH(operation_date_time)

/*
2.	Travelers per month
In this case you must use the Train List table to fill in the following table.

Travelers per month
			
Year 	Month	Number of passengers	Total amount
2024	01		834						1,850,883.53
*/

select
	YEAR(departure_date) as Year,
	Month(departure_date) as Month,
	count(*) as 'Number of passengers',
	sum(operation_amount) as 'Total amount'
from
	train_list
group by
	YEAR(departure_date),
	Month(departure_date)

/*
3.	Groups Sales per month
For this is necessary to take into account only the groups bookings.  
The field  groupyn  in the train list table is YES when the booking code  (booking_code field)   is for a group.

Groups Sales per month
			
Year 	Month	Number of operations	Total amount
2024	01	176,000	456,883.00
2024	02		
*/

select
	Year(b.operation_date_time) as Year,
	MONTH(b.operation_date_time) as Month,
	count(*) as 'Number of operations',
	SUM(b.operation_amount) as 'Total amount'
from
	booking_payment_detailed b
join train_list t
on b.booking_code = t.booking_code
where t.groupyn = 'Yes'
group by
	Year(b.operation_date_time),
	MONTH(b.operation_date_time)

/*
4.	Groups Travelers per month
In this case you must use the Train List table to fill in the following table.

Groups Travelers per month
			
Year 	Month	Number of passengers	Total amount
2024	01		834						1,850,883.53
			
*/

select
	YEAR(departure_date) as Year,
	Month(departure_date) as Month,
	count(*) as 'Number of passengers',
	sum(operation_amount) as 'Total amount'
from
	train_list
where
	groupyn = 'Yes'
group by
	YEAR(departure_date),
	Month(departure_date)