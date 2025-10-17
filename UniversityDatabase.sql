create database University;

use University;

create table Student(
id int primary key,
name varchar(50),
age int not null,
marks int default 0,
grade char,
home varchar(50),
route varchar(50)
);

insert into Student values
(232400002, "Fahim",23,70,'B',"Dhamrai","7E"),
(232400004, "Antor",20,25,'F',"Mirpur","8B"),
(232400010, "Hasib",22,75,'B',"Hostel",null),
(232400022, "Sourov",22,82,'A',"Gorai","7D"),
(232400023, "Mahfuj",22,60,'C',"Gorai","7D"),
(232400025,"Farhad",23,85,'A',"Jamgora","7B"),
(232400026,"Samia",21,38,'F',"Hostel",null),
(232400029, "Antara",21,85,'A',"Hostel",null);

select * from Student;

select * from Student where marks >=80;
select * from Student where marks >=40 and marks<80;
select * from Student where marks between 40 and 79;
select * from Student order by marks desc;
select max(marks) from Student;
select avg(marks) from Student;
select count(id) from Student;


set SQL_SAFE_UPDATES=0;
update Student set route = "Campus" where route is null;
update Student set marks =40 and grade ='E' where marks >=37 and marks <=39;
set SQL_SAFE_UPDATES=1;

delete from Student where marks<40;

alter table Student add column department varchar(50);
alter table Student modify age varchar(2);
alter table Student change age student_age int;
alter table Student drop column student_age;
alter table Student rename to student;

select name, marks from Student where marks>=(select avg(marks) from Student);

create view view1 as select id, name, home from Student;
select * from view1;


select * from Student;
truncate table Student;
drop table Student; 
