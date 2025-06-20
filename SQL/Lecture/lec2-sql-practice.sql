-- Set search path to hr schema
set search_path to hr

-- Create departments table
create table departments(
dept_id INT PRIMARY KEY,
dept_name VARCHAR(100),
manager_id INT
);

-- Create jobs table
create table jobs(
job_id VARCHAR(10) PRIMARY KEY,
job_title VARCHAR(100),
min_salary DECIMAL,
max_salary DECIMAL
);

-- Create employees table
create table employees(
emp_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
gender CHAR(1),
dob DATE,
email VARCHAR(100),
phone VARCHAR(15),
dept_id INT REFERENCES departments(dept_id),
job_id VARCHAR(10) REFERENCES jobs(job_id),
hired_date DATE
)

-- Create salaries table
create table salaries(
salary_id INT PRIMARY KEY,
emp_id INT REFERENCES employees(emp_id),
amount DECIMAL,
start_date DATE,
end_date DATE
)

-- Create attendance table
create table attendance(
log_id INT PRIMARY KEY,
emp_id INT REFERENCES employees(emp_id),
log_date DATE,
check_in TIME,
check_out TIME
)

-- Create projects table
create table projects(
project_id VARCHAR(10) PRIMARY KEY,
project_name VARCHAR(100),
dept_id INT REFERENCES departments(dept_id),
start_date DATE,
end_date DATE
)

-- Create assignments table
create table assignments(
emp_id INT REFERENCES employees(emp_id),
project_id VARCHAR(10) REFERENCES projects(project_id),
role VARCHAR(50),
PRIMARY KEY (emp_id, project_id)
)


-- Load data from csv files
-- COPY departments FROM 'departments.csv' CSV HEADER;
-- COPY jobs FROM 'jobs.csv' CSV HEADER;
-- COPY employees FROM 'employees.csv' CSV HEADER;
-- COPY salaries FROM 'salaries.csv' CSV HEADER;
-- COPY attendance FROM 'attendance.csv' CSV HEADER;
-- COPY projects FROM 'projects.csv' CSV HEADER;
-- COPY assignments FROM 'assignments.csv' CSV HEADER;




-- Checking all the tables






-- 1. Get all employees
select * from employees

-- 2. Get first_name, hired_date from employees table who are Females
select first_name, hired_date from employees where gender='F'

-- 3. Get all employees who are not male
select * from employees where gender<>'M'

-- 4. Get all jobs where min_salary is more than 40000
select * from jobs where min_salary > 40000

-- 5. Get all salaries between 55,000 and 100,000 (inclusive)
select * from salaries where amount BETWEEN 55000 and 100000

-- 6. Get all salaries between 55,000 and 100,000 (exclusive)
select * from salaries where amount > 55000 and amount < 100000

-- 7. Get employees who have job id either J101 or J102
select * from employees where job_id in ('J101','J102')

-- 8. Get employees name whose email ends with example.com keyword [like]
select * from employees where email like '%example.com'

-- 9. Get emp_id whose latest salary is not credited (end_date is Null)
select * from salaries where end_date is null


-- DML practice

-- 1. Constraint check and add later if needed  
alter table employees add constraint chk_gender check (gender in ('M','F'))

-- 2. Insert a new department
insert into departments (dept_id, dept_name, manager_id) values (40, 'Marketing', 103);

-- 3. Update the salary of an employee
update salaries set amount=45000 where salary_id=4
select * from salaries

-- 5. Delete from assignments where project_id is P003
delete from assignments where project_id='P003'

-- 6. Delete using condition 
select * from attendance
delete from attendance where log_date < '2023-01-01'

-- 8: Get distinct job_id from employees
select distinct job_id from employees



-- Wildcart and regex

-- 1. Get employees whose first name starts with 'J'
select * from employees where first_name like 'J%'

-- 2. Get employees whose last name ends with 'mith'
select * from employees where last_name like '%mith'

-- 3. Get employees whose email contains 'davis'
select * from employees where email like '%davis%'

-- 4. Get employees with a 5-letter first name ending in 'ily' 
select * from employees where first_name like '__ily'


-- Regular Expression
-- Specific for Postgres
-- Get employees whose first name starts with 'j' or 'J' (case-insensitive)
select * from employees where first_name ~* '^j';

-- Get employees whose email is NOT from @company.com
select * from employees where email !~ '^[^@]+company\.com'



-- Get all employees ordered by dept_id 
select * from employees order by dept_id ASC 

-- Get the first 3 employees from the table
select * from employees LIMIT 3

-- Skip the first 2 employees and get the next 2
select * from employees LIMIT 2 OFFSET 2




-- Math operations
-- Perform a simple math operation (Follows BODMAS)
select 3+5-2*4/2 AS result

-- Calculate 10% bonus on salary amount and alias it as 'bonus'
select emp_id, amount, amount*0.1 as bonus from salaries

-- Get salaries where adding 5000 makes it more than 60,000
select * from salaries where amount+5000 > 60000

-- Show original and adjusted salary after deducting 2000
select emp_id, amount, amount-2000 as adjusted_salary from salaries

-- Find salaries that are exact multiples of 5000
select * from salaries where amount%5000=0

-- Aggregation and Grouping
-- Count how many employees are in each department

-- Count number of employees assigned to each project

-- Show departments with more than 1 employees

-- Show projects that have more than 1 employees assigned


-- Find departments with more than 2 entries in the employees table,
-- where department IDs are between 100 and 200,
-- and show aggregate info about those employees.


-- Assignment
-- Show basic project info where department ID is even
-- and calculate project duration using arithmetic


