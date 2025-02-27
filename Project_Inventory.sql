/*

create below tables in inventory 
1	Supplier
2	Product
3	Stock
4	Customer
5	Orders

/*
(Current task is)		
1	Create Database-IMS	Done
2	Create Tables inside the DB	Done
3	Apply Constraints	Done
4	Insert appropriate records	Done
*/

IN THE INVENTORY STRUCTURE DISPLAY  (Mini Project):

1) PID, PDESC, CATEGORY, SNAME, SCITY

2 ) DISPLAY OID , ODATE , CNAME, CADDRESS, CPHONE, PDESC, PRICE,OQTY, AMT
*/

Create database Projects
Use projects

/*
Supplier	Add_Supp
SID	        PK
Sname		Not Null
Sadd		Not Null
Scity		Delhi
Sphone		Unique
Email		NC	
*/

Create table Supplier
(SID varchar(5), 
Sname varchar(20) not null, 
Sadd varchar(50) not null, 
Scity varchar(10) default 'Delhi', 
Sphone varchar(20) Unique,
Email varchar(100),
Primary Key (SID))

alter table supplier
alter column SID varchar(5) not null

insert into Supplier(SID, Sname, Sadd, Sphone, Email)
values('S0001',	'Sharon',	'3rd Floor','318-171-2939',	'sdowker0@moonfruit.com'),
('S0002',	'Victoria',	'Apt 561',	'926-882-0077',	'vkoubek1@cornell.edu'),
('S0003',	'Brana',	'Apt 1283',	'743-989-0180',	'bglasscoe2@latimes.com'),
('S0004',	'Fay'	,'Room 1605',	'911-865-4123',	'fkilshall3@oakley.com'),
('S0005',	'Christabel',	'Room 1180',	'588-858-9126',	'ccurds4@mayoclinic.com'),
('S0006',	'Harriot',	'Room 825',	'816-887-5728',	'hatger5@wikipedia.org'),
('S0007',	'Mariska',	'Room 583',	'865-341-6132',	'mgeldard6@taobao.com'),
('S0008',	'Judie',	'Room 218',	'899-326-2213',	'jshernock7@alibaba.com'),
('S0009',	'Lenna',	'Suite 24',	'217-950-6655',	'llibby8@vinaora.com'),
('S0010',	'Pieter',	'PO Box 85290',	'352-310-5008',	'pduthie9@theguardian.com')

select * from Supplier

/*
Product	Addprod
PID		PK
PDESC	Not Null
Price	>0
category IT, HA, HC
SID		 FK

*/

Create table Product
(PID varchar(5) not null,
PDESC varchar(10) not null,
Price int check(Price>0),
Category varchar(10) check(Category in ('IT', 'HA', 'HC')),
SID varchar(5),
FOreign key (SID) references supplier(SID))

select * from Product

alter table product
add constraint pkID primary key(PID)

alter table product
alter column PDESC varchar(20)

-- price was int, need to be changed to float, but due to constraint we need to drop constraint first then column

-- below query is to find constraint name
SELECT name 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('Product') AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('Product'), 'Price', 'ColumnId');

-- drop the constraint
ALTER TABLE Product
DROP CONSTRAINT CK__Product__Price__398D8EEE;
-- drop column
ALTER TABLE Product
DROP COLUMN Price;

alter table product
add Price float check(price>0)

insert into Product(PID, PDESC, Price, Category, SID)
values
('P0001',	'digital camera',	85.20,	'HA',	'S0001'),
('P0002',	'digital camera',	139.65,	'HA',	'S0002'),
('P0003',	'fitness tracker',	363.78,	'HA',	'S0003'),
('P0004',	'gaming console',	183.04,	'HA',	'S0004'),
('P0005',	'smartphone',	291.45,	'HC',	'S0005'),
('P0006',	'e-reader'	,324.93,	'HC',	'S0006'),
('P0007',	'smartphone',	342.72,	'HA',	'S0007'),
('P0008',	'smartphone',	470.81,	'IT',	'S0008'),
('P0009',	'portable speaker',	424.77,	'HC',	'S0009'),
('P0010',	'tablet',	402.02,	'IT',	'S0010'),
('P0011',	'desktop computer',	279.07,	'HA',	null),
('P0012',	'smart TV',	124.87,	'IT',	null),
('P0013',	'fitness tracker',	359.61,	'IT',	null),
('P0014',	'virtual headset',	157.42,	'HA',	null),
('P0015',	'drone',	478.12,	'HC',	null)

/*
STOCK	Add_Stock
PID	FK
SQTY	>=0
ROL	>0
MOQ	>=5
*/

create table Stock
(PID varchar(5),
Foreign key (PID) references Product(PID),
SQTY int check(SQTY>=0),
ROL int check(ROL>0),
MOQ int check(MOQ>=5))

insert into Stock
values('P0001',	982,	58,	10),
('P0002',	969,	24,	45),
('P0003',	331,	67,	25),
('P0004',	924,	76,	39),
('P0005',	83,	25,	74)


select * from Stock

/*
Customer	Add_Cust
CID	PK
CNAME	Not Null
ADDRESS	Not Null
CITY	Not Null
PHONE	Not Null
EMAIL	Not Null
DOB	<2000-01-01
*/

Create table Customer
(
CID	varchar(5) not null,
Primary key(CID),
CNAME varchar(20)	Not Null,
ADDRESS	varchar(30) Not Null,
CITY varchar(20)	Not Null,
PHONE varchar(20)	Not Null,
EMAIL varchar(30)	Not Null,
DOB	date check (dob<'2000-01-01')
)

insert into Customer
values
('C0001',	'Edith',	'Apt 1935',	'Bendorubuh',	'378-400-6289',	'ehayford0@1688.com',	'1995-06-15'),
('C0002',	'Rivi',	'Apt 412',	'Aghavnadzor',	'195-475-1990',	'rdilucia1@squarespace.com'	,'1986-01-12'),
('C0003',	'Reidar',	'Apt 1293',	'Chaowai',	'688-962-9139',	'rgalland2@constantcontact.com',	'1984-11-17'),
('C0004',	'Kathy',	'Room 96',	'Pinillos',	'104-722-5747',	'kshedd3@cocolog-nifty.com',	'1968-05-08'),
('C0005',	'Cross'	,'Apt 637',	'Nanjie',	'398-595-6649',	'czelake4@biblegateway.com',	'1968-10-14'),
('C0006',	'Lorain',	'PO Box 25648',	'Paris' ,	'896-184-3990',	'lbullingham5@1688.com',	'1965-10-20'),
('C0007',	'Sascha',	'9th Floor',	'Hengtanggang',	'706-441-7067',	'sbinham6@myspace.com',	'1964-03-16'),
('C0008',	'Caron',	'PO Box 97430',	'Amiens',	'811-928-9459',	'ccully7@pen.io',	'1991-03-31'),
('C0009',	'Ilka',	'PO Box 88346',	'Tintafor',	'257-830-6162',	'irubie8@si.edu',	'1994-11-27'),
('C0010',	'Othilia',	'PO Box 73750',	'Santa', '	583-101-0928',	'omuris9@ihg.com',	'1997-04-02'),
('C0011',	'Sinclare',	'Room 52',	'La Unión',	'868-182-5372',	'seadmeadsa@opera.com',	'1980-12-26'),
('C0012',	'Wilton',	'PO Box 27721',	'Tama',	'490-187-2589',	'wsouthwoodb@smugmug.com',	'1989-09-01'),
('C0013',	'Frazer',	'PO Box 20875',	'Tukbur',	'497-175-7803',	'fdoerrc@ow.ly',	'1997-06-06'),
('C0014',	'Sandro',	'13th Floor',	'Buritama',	'758-254-7914',	'sbramerd@google.fr',	'1990-02-23'),
('C0015',	'Efren',	'6th Floor',	'Masipi West',	'782-720-3302',	'eoraee@boston.com',	'1992-03-10')

select * from Customer

/*
Orders	
OID	PK
ODATE	
CID	FK
PID	FK
Oqty	>=1
*/

create table Orders
(	
OID varchar(5) not null,
Primary Key (OID),
ODATE	date,
CID varchar(5),
Foreign key (CID) references Customer(CID),
PID varchar(5),
Foreign key (PID) references Product(PID),
Oqty int check(Oqty>=1))

insert into Orders
values
('O0001',	'2024-09-29',	'C0001',	'P0001',	'32'),
('O0002',	'2024-08-31',	'C0002',	'P0002',	'73'),
('O0003',	'2025-12-02',	'C0003',	'P0003',	'100'),
('O0004',	'2024-05-28',	'C0004',	'P0004',	'58'),
('O0005',	'2025-02-18',	'C0005',	'P0005',	'35')

Select * from orders

-- 1. PID, PDESC, CATEGORY, SNAME, SCITY
select * from Product
select * from supplier

select p.PID, s.SID, p.PDESC, p.CATEGORY, s.SNAME, s.SCITY
from Product p
join Supplier s
on p.sid=s.sid

-- 2) DISPLAY OID , ODATE , CNAME, CADDRESS, CPHONE, PDESC, PRICE,OQTY, AMT

select * from Orders
select * from Customer
select * from Product

select 
	c.CNAME, c.ADDRESS as 'CADDRESS', c.PHONE as 'CPHONE',
	o.OID , o.ODATE, p.PDESC, 
	o.OQTY, p.PRICE,
	o.oqty*p.price as 'AMT'
from Customer c
inner join Orders o on o.cid=c.cid
inner join Product p on p.PID=o.PID

/*
Customer is joined with Orders using CID (Customer ID).
Orders is joined with Product using PID (Product ID).
The result includes details from all three tables.

Inner join is used for fetching matching records.

we can use full outer joi but result would be inconclusive.
*/

select 
	c.CNAME, c.ADDRESS as 'CADDRESS', c.PHONE as 'CPHONE',
	o.OID , o.ODATE, p.PDESC, 
	o.OQTY, p.PRICE,
	o.oqty*p.price as 'AMT'
from Customer c
full join Orders o on o.cid=c.cid
full join Product p on p.PID=o.PID
order by o.oqty desc

