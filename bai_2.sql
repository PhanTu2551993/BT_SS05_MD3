create database btth;
use btth;

create table dmmh(
    maMh char(4) primary key ,
    tenMh varchar(50),
    soTiet tinyint
);
create table dmkhoa(
                       maKhoa char(2) primary key ,
                       tenKhoa varchar(50)
);
create table dmsv(
                     maSv char(3) primary key ,
                     hoSv varchar(15),
                     tenSv varchar(7),
                     phai char(7),
                     ngaySinh datetime,
                     noiSinh varchar(20),
                     maKhoa char(2),
                     foreign key (maKhoa) references dmkhoa(maKhoa)
);
create table ketqua(
    maSv char(3),
    maMh char(4),
    lanThi tinyint  ,
    diem decimal(4,2),
    primary key (maSv,maMh),
    foreign key (maSv) references dmsv(maSv),
    foreign key (maMh) references dmmh(maMh)
);

INSERT INTO dmmh (maMh, tenMh, soTiet)
VALUES
        ('MH1', 'Toán', 45),
        ('MH2', 'Vật lý', 50),
        ('MH3', 'Hóa học', 45),
        ('MH4', 'Ngữ văn', 60),
        ('MH5', 'Tiếng Anh', 60);
INSERT INTO dmkhoa (maKhoa, tenKhoa)
                                 VALUES
                                     ('K1', 'Khoa Toán'),
                                     ('K2', 'Khoa Vật lý'),
                                     ('K3', 'Khoa Hóa học'),
                                     ('K4', 'Khoa Ngữ văn'),
                                     ('K5', 'Khoa Tiếng Anh');
INSERT INTO dmsv (maSv, hoSv, tenSv, phai, ngaySinh, noiSinh, maKhoa)
                                                              VALUES
                                                                  ('SV1', 'Nguyễn', 'Văn', 'Nam', '2000-01-01', 'Hà Nội', 'K1'),
                                                                  ('SV2', 'Trần', 'Thị', 'Nữ', '2000-02-02', 'Hải Phòng', 'K2'),
                                                                  ('SV3', 'Lê', 'Quốc', 'Nam', '2000-03-03', 'Đà Nẵng', 'K3'),
                                                                  ('SV4', 'Phạm', 'Hải', 'Nam', '2000-04-04', 'TP HCM', 'K4'),
                                                                  ('SV5', 'Hoàng', 'Yến', 'Nữ', '2000-05-05', 'Cần Thơ', 'K5');
INSERT INTO ketqua (maSv, maMh, lanThi, diem)
VALUES
        ('SV1', 'MH1', 1, 8.5),
        ('SV1', 'MH2', 1, 7.2),
        ('SV1', 'MH3', 1, 9.0),
        ('SV1', 'MH4', 1, 8.0),
        ('SV1', 'MH5', 1, 7.5),
        ('SV2', 'MH1', 1, 5.5),
        ('SV2', 'MH2', 1, 6.2),
        ('SV2', 'MH3', 1, 7.0),
        ('SV2', 'MH4', 1, 8.0),
        ('SV2', 'MH5', 1, 9.5),
        ('SV3', 'MH1', 1, 3.5),
        ('SV3', 'MH2', 1, 4.2),
        ('SV3', 'MH3', 1, 5.0),
        ('SV3', 'MH4', 1, 6.0),
        ('SV3', 'MH5', 1, 7.5),
        ('SV4', 'MH1', 1, 3.5),
        ('SV4', 'MH2', 1, 4.2),
        ('SV4', 'MH3', 1, 5.0),
        ('SV4', 'MH4', 1, 6.0),
        ('SV4', 'MH5', 1, 7.5),
        ('SV5', 'MH1', 1, 3.5),
        ('SV5', 'MH2', 1, 4.2),
        ('SV5', 'MH3', 1, 5.0),
        ('SV5', 'MH4', 1, 6.0),
        ('SV5', 'MH5', 1, 7.5);
#a. Procedure in danh sách sinh viên sắp xếp theo khoa:

delimiter //
create procedure ListStudentsOrderByDepartment()
begin
    select d.tenKhoa as 'Khoa',s.maSv as 'Mã sv', concat(s.hoSv, ' ', s.tenSv) as 'Họ tên sinh viên', s.phai, s.ngaySinh, s.noiSinh
    from dmsv s
    join dmkhoa d on d.maKhoa = s.maKhoa
    order by d.tenKhoa;
end; //
call ListStudentsOrderByDepartment();

#Procedure thêm mới sinh viên:
delimiter //
create procedure AddStudent(
    in in_maSv char(3),
    in in_hoSv varchar(15),
    in in_tenSv varchar(7),
    in in_phai char(7),
    in in_ngaySinh datetime,
    in in_noiSinh varchar(20),
    in in_maKhoa char(2)
)
begin
    insert into dmsv(maSv, hoSv, tenSv, phai, ngaySinh, noiSinh, maKhoa)
        values (in_maSv,in_hoSv,in_tenSv,in_phai,in_ngaySinh,in_noiSinh,in_maKhoa);
end //
delimiter ;
call AddStudent('SV6', 'Phan', 'Tu', 'Nam', '1999-05-05', 'Thai Bình', 'K5');

#c. Procedure lấy thông tin các khoa:

delimiter //
create procedure GetAllDepartments()
begin
    select * from dmkhoa;
end; //

call GetAllDepartments();

#d. Procedure thêm mới khoa:

delimiter //
create procedure AddDepartments(
    in in_maKhoa char(2) ,
    in in_tenKhoa varchar(50)
)
begin
    insert into dmkhoa(maKhoa, tenKhoa)
        values (in_maKhoa,in_tenKhoa);
end//
delimiter ;
call AddDepartments('K6', 'Khoa Tiếng Nhật');

#e. Procedure thêm mới khoa và trả ra số lượng của khoa hiện tại:

delimiter //
create procedure AddDepartmentsAndGetCount(
    in in_maKhoa char(2) ,
    in in_tenKhoa varchar(50),
    out out_soLuong int
)
begin
    declare maKhoaExist int;

    -- Kiểm tra xem giá trị maKhoa đã tồn tại trong bảng hay chưa
    select count(*) into maKhoaExist from dmkhoa where maKhoa = in_maKhoa;

    -- Nếu giá trị maKhoa đã tồn tại, không thực hiện thêm và trả về -1
    if maKhoaExist > 0 then
        set out_soLuong = -1;
    else
        -- Nếu giá trị maKhoa chưa tồn tại, thêm vào bảng và trả về số lượng bản ghi sau khi thêm
        insert into dmkhoa(maKhoa, tenKhoa) values (in_maKhoa, in_tenKhoa);
        select count(*) into out_soLuong from dmkhoa;
        select out_soLuong;
    end if;
end;//

call AddDepartmentsAndGetCount('K7', 'Khoa Tiếng Hàn',@soLuong);

#f. Procedure cập nhật thông tin khoa:

delimiter //
create procedure UpdateDepartments(
    in in_maKhoa char(2) ,
    in in_tenKhoa varchar(50)
)
begin
    update dmkhoa set tenKhoa = in_tenKhoa where maKhoa = in_maKhoa;
end //
delimiter ;
call UpdateDepartments('K7','Khoa tiếng Trung');

#g. Procedure nhập vào 2 mã sinh viên và 1 mã môn học,
# trả ra thông tin sinh viên có điểm cao nhất trong lần thi 1:

delimiter //
create procedure GetTopStudentByFirstExam(
    in in_maSv1 char(3),
    in in_maSv2 char(3),
    in in_maMh char(4),
    out out_hoTen varchar(50),
    out out_diem decimal(4,2)
)
begin
    select max(s.tenSv), max(k.diem) into out_hoTen, out_diem
    from dmsv s
    join ketqua k on s.maSv = k.maSv
    where (s.maSV = in_maSV1 or s.maSV = in_maSV2)
      and k.maMH = in_maMH and k.lanThi = 1;
    select out_hoTen,out_diem;
end//
delimiter ;
call GetTopStudentByFirstExam('SV1','SV2','MH1',@hoten,@diem);

#h.	Viết procedure nhập vào 1 môn học và 1 mã sinh viên,
# kiểm tra xem sinh viên có đậu môn này hay không trong lần thi đầu tiên. Nếu đậu thì trả ra “PASS”, không đậu trả ra “FAIL”,
# Chưa có điểm trả ra “NOT MARK”

delimiter //
create procedure CheckPassOrFailFirstExam( IN_maSV CHAR(3),
                                           IN_maMH CHAR(4)

)
begin
    declare base_diem decimal(4,2);
    declare Out_result varchar(150);
    select diem into base_diem
    from ketqua
        where maSv = IN_maSV and maMh = IN_maMH and lanThi = 1;
    if base_diem is null then
        set OUT_result = 'NOT MARK';
    elseif base_diem >= 5 then
        set OUT_result = 'PASS';
    else
        set OUT_result = 'FAIL';
    end if;
    select OUT_result as 'Kết Quả';
end //
delimiter ;
call CheckPassOrFailFirstExam('SV','MH1');

#i.	Viết procedure nhập vào mã sinh viên và môn học, trả ra các điểm thi của sinh viên môn học đó .

delimiter //
create procedure GetExamScoresByStudentAndSubject(IN_maSV CHAR(3),
                                                  IN_maMH CHAR(4)
)
begin
    select lanThi,diem
    from ketqua
        where maSv = IN_maSV and maMh = IN_maMH;
end //
delimiter ;

call GetExamScoresByStudentAndSubject('SV1','MH1');

#j.	Viết procedure nhập vào mã sinh viên, in ra các môn học sinh viên đã học

delimiter //
create procedure ListSubjectsByStudent(IN_maSV CHAR(3)
)
begin
    select k.maSv,tenMh,soTiet
    from ketqua k JOIN dmmh d on d.maMh = k.maMh
    where k.maSv = IN_maSV;
end //
delimiter ;

call ListSubjectsByStudent('SV1');

#k.	Viết procedure nhập vào mã môn học, in ra các sinh viên đã học môn đó

delimiter //
create procedure ListStudentsBySubject(IN_maMh char(4))
begin
    select s.maSv,s.tenSv
           from ketqua k join dmsv s on s.maSv = k.maSv
    where maMh = IN_maMh;
end //
delimiter ;
call ListStudentsBySubject('MH3');

