/*
CREATE BELOW PROCEDURES IN THE INVENTORY DATABASE AS SPECIFIED :

ADDSUPPLIER – SHOULD ADD THE SUPPLIER IN THE SUPLIER TABLE AND DISPLAY THE  DETAILS OF THE NEW SUPPLIER ADDED.

ADDPRO – SHOULD ADD THE PRODUCT IN THE PRODUCT TABLE AND DISPLAY THE  DETAILS OF THE NEW PRODUCT ADDED.

ADDCUST – SHOULD ADD THE CUSTOMER IN THE CUSTOMER TABLE AND DISPLAY THE  DETAILS OF THE NEW CUSTOMER ADDED.

ADDORDER – SHOULD ADD THE ORDER IN THE ORDERS TABLE AND DISPLAY THE DETAILS  OF THE ORDER. ORDER DATE SHOULD BE CURRENT DATE AND SHOULD COME  AUTOMATICALLY.
*/

select * from customer
select * from orders
select * from product
select * from stock
select * from supplier


create procedure ADDSUPPLIER
@SID varchar(5),
@Sname varchar(20),
@Sadd varchar(50),
@Scity varchar(10),
@Sphone varchar(20),
@Email varchar(100)
as
begin
insert into supplier(SID,Sname,Sadd,Scity,Sphone,Email)
values(@SID,@Sname,@Sadd,@Scity,@Sphone,@Email)
select * from supplier where SID=@SID
end

exec ADDSUPPLIER
@SID='S0011',
@Sname = 'Maasha',
@Sadd='Bear House',
@Scity= 'Moscow',
@Sphone= '235-85364',
@Email= 'mashaabear@gmail.com'

select * from Supplier

create procedure ADDPRO 
@PID varchar(5),
@PDESC varchar(20),
@category varchar(10),
@SID varchar(5),
@Price float
as
begin
Insert Into product(PID,PDESC,category,SID,Price)
values(@PID,@PDESC,@category,@SID,@Price)
select * from Product where pid = @pid
end

exec ADDPRO
@PID ='P0016',
@PDESC='AirPods',
@category='HC',
@SID ='S0011',
@Price = 14000.36

select * from product

create procedure ADDCUST
@CID varchar(5),
@cname varchar(20),
@address varchar(30),
@city varchar(20),
@phone varchar(20),
@email varchar(30),
@dob date
as
begin
insert into Customer(CID,cname,address,city,phone,email,dob)
values(@CID,@cname,@address,@city,@phone,@email,@dob)
select * from Customer where CID = @CID
end

exec ADDCUST
@CID = 'C0016',
@cname= 'Maasha',
@address= 'Bear House',
@city='Moscow',
@phone='235-85364',
@email='mashaabear@gmail.com',
@dob='01-01-1995'

select * from Customer

create procedure ADDORDER
@OID varchar(5),
@ODATE date,
@CID varchar(5),
@PID varchar(5),
@Oqty int
as
begin
insert into Orders(OID,ODATE,CID,PID,Oqty)
values(@OID,@ODATE,@CID,@PID,@Oqty)
select * from orders where OID = @OID
end

exec ADDORDER
@OID ='O0006',
@ODATE= '2025-04-11',
@CID='C0006',
@PID='P0016',
@Oqty='45'

select * from Orders