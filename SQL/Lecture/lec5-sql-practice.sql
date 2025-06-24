-- ==============================================
-- SQL FILE: Text and Date-Time String Operations
-- Purpose: Practice essential string & datetime operations for data science
-- ==============================================

-- Set schema if needed
SET search_path TO hr;

-- =====================
-- STRING CLEANING & FORMATTING
-- =====================

-- Remove leading/trailing spaces
-- "    hello world   "
select rtrim('    hello world   ') as trimmed_text
-- trim, rtrim, ltrim

-- Convert to upper and lower case
-- "john doe" -> upper -> JOHN DOE
-- "JOHN DOE" -> lower -> john doe
select lower('JOHn dOE') as lower_text

-- Capitalize first letter (PostgreSQL only)
-- "reliance industries private limited" -> INITCAP
select initcap('reliance industries private limited') as capitalized_text

-- Replace characters
-- "123-78213-321" replace "-" with " "
select replace('123-78213-321', '-', '   ') as clean_phone


-- Extract substring (Index of string is being strted from 1)
-- 'DataScience' 
--  select substring(input_string, start_index of substring, lenght of substring)
select substring('DataScience', 5, 3)


-- Split email into username and domain
-- 'username@example.com/.in'
select
split_part('username@example.com', '@', 1) as username,
split_part('username@example.com', '@', 2) as domain_name

-- Concatenate strings
-- summation of string 'cat'+'-'+'dog'
select concat(first_name, ' ', last_name) as full_name from employees

-- Pad string
-- '123' -> '  123' -> '00123' (left) -> '12300'
select rpad('123',5, '0') as padded_right


-- =====================
-- DATE-TIME STRING CLEANING & FORMATTING
-- =====================
-- DATE, TIME, DATETIME

-- Current date and time
-- Current date
select current_date as today, current_time as now_time, now() as full_timestamp

-- Extract parts of a date
-- Extract year, month and date from the hired_date of employees table
select 
hired_date,
extract(year from hired_date) as year_of_hired,
extract(month from hired_date) as month_of_hired,
extract(day from hired_date) as date_of_hired
from employees


-- Convert date to text
-- 'datetime' -> 'text': TO_CHAR()
select hired_date, to_char(hired_date,'YYYY-MM-DD') as fromatted_date from employees

-- Convert string to timestamp
-- 'text' -> 'timestamp': to_timestamp()
select to_timestamp('2023/12/31', 'YYYY/MM/DD') as parsed_date

-- Convert string to date
-- 'text' -> 'date' : to_date()
select to_date('2023-12-31 00:00:00+05:30', 'YYYY-MM-DD HH24:MI:SS') as parsed_date

-- Calculate number of days worked
select emp_id, first_name, current_date - hired_date as days_worked from employees

-- Calculate age (interval)
select emp_id,first_name, age(current_date, dob) as age from employees

-- Format timestamp as readable string
select to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as fromatted_date 


-- Creating view for emp_salary table 
create view emp_salary_view as
select e.first_name, e.last_name, s.amount
from employees e
join salaries s on e.emp_id = s.emp_id

-- Access/ view the emp_salary_view table
select * from emp_salary_view


-- ==================
-- Optimization tools
-- ==================

-- Analyze query performance
EXPLAIN ANALYZE
select * from employees

-- Indexing 
CREATE INDEX emp_id_index ON employees(emp_id);









-- Drop if exists
DROP TABLE IF EXISTS employee_logs;


-- Create a sample table
CREATE TABLE employee_logs (
  log_id SERIAL PRIMARY KEY,
  emp_id INT,
  log_date DATE,
  activity TEXT
);

-- Insert 1 million rows (simulate with generate_series)
INSERT INTO employee_logs(emp_id, log_date, activity)
SELECT 
  FLOOR(RANDOM() * 1000)::INT,
  CURRENT_DATE - (FLOOR(RANDOM() * 365))::INT,
  'Logged In'
FROM generate_series(1, 1000000);

-- This will be slow without index
EXPLAIN ANALYZE
SELECT * 
FROM employee_logs 
WHERE emp_id = 500;

CREATE INDEX idx_emp_id ON employee_logs(emp_id);
create INDEX lvl2_index on idx_emp_id

-- Rerun the same query
EXPLAIN ANALYZE
SELECT * 
FROM employee_logs 
WHERE emp_id = 500;
