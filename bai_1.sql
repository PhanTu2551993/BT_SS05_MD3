create database baitap_ss5_1;
use baitap_ss5_1;

create table if not exists Products (
                                        Id int auto_increment primary key ,
                                        productCode varchar(50) not null ,
                                        productName varchar(255) not null ,
                                        productPrice decimal(10,2) not null ,
                                        productAmount int not null ,
                                        productDescription text,
                                        productStatus enum('Active', 'Inactive') not null
);

insert into Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
values
    ('P001', 'Laptop Dell XPS 13', 1500.00, 20, 'Powerful laptop with high resolution display', 'Active'),
    ('P002', 'iPhone 12 Pro', 1200.00, 30, 'Latest iPhone model with advanced camera', 'Active'),
    ('P003', 'Samsung Galaxy S21 Ultra', 1300.00, 25, 'Flagship Samsung phone with large display', 'Active'),
    ('P004', 'Sony PlayStation 5', 500.00, 15, 'Next-gen gaming console with high-performance specs', 'Active'),
    ('P005', 'Smart TV LG 4K 55"', 800.00, 10, 'Large screen smart TV with 4K resolution', 'Active');

-- Tạo Unique Index trên cột productCode
create unique index idx_productCode ON Products (productCode);

-- Tạo Composite Index trên cột productName và productPrice
create index idx_productName_productPrice ON Products (productName, productPrice);

-- Sử dụng câu lệnh EXPLAIN để biết cách thực thi câu lệnh SELECT
explain select * from Products where productCode = 'P001';

explain select * from Products where productName = 'iPhone 12 Pro' and productPrice > 1000;

-- Tạo view

create view ProductInfo as
select productCode, productName, productPrice, productStatus from Products;

-- Sửa đổi view
    alter view ProductInfo as
    select productCode, productName, productPrice, productStatus, productAmount from Products;

-- Xoá view
drop view if exists ProductInfo;

-- Store procedure lấy tất cả thông tin của tất cả các sản phẩm
delimiter //
 create procedure GetAllProducts()
begin
    select * from Products;
end ;
// 
call GetAllProducts();

-- Store procedure thêm một sản phẩm mới

delimiter //
create procedure AddProduct(
    in p_productCode varchar(50),
    in p_productName varchar(255),
    in p_productPrice decimal(10, 2),
    in p_productAmount int,
    in p_productDescription text,
    in p_productStatus enum('Active', 'Inactive')
)
begin
    insert into Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    values (p_productCode, p_productName, p_productPrice, p_productAmount, p_productDescription, p_productStatus);
end;
// delimiter 
call AddProduct('P006', 'Smart Phone XX"', 850.00, 11, 'Large screen smart phone', 'Active');
call AddProduct('P007', 'Smart Phone XXX"', 860.00, 12, 'Large screen smart phone XXX', 'Active');

-- Store procedure sửa thông tin sản phẩm theo id
delimiter //
create procedure UpdateProduct(
    in p_Id int,
    in p_productCode varchar(50),
    in p_productName varchar(255),
    in p_productPrice decimal(10, 2),
    in p_productAmount int,
    in p_productDescription text,
    in p_productStatus enum('Active', 'Inactive')
)
begin
    update Products
    set
        productCode = p_productCode,
        productName = p_productName,
        productPrice = p_productPrice,
        productAmount = p_productAmount,
        productDescription = p_productDescription,
        productStatus = p_productStatus
    where Id = p_Id;
end;
delimiter //

call UpdateProduct(8,'P008', 'Smart Phone XXX"', 860.00, 12, 'Large screen smart phone XXX', 'Active');

-- Store procedure xoá sản phẩm theo id
delimiter //
create procedure DeleteProduct(
    in p_Id int
)
begin
    delete from Products where Id = p_Id;
end;
delimiter //

#call DeleteProduct(8);

