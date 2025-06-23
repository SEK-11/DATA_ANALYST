
-- Aggregation and Grouping
-- Count how many employees are in each department
select dept_id, count(*) as total_employees
from employees 
group by dept_id;

-- Count number of employees assigned to each project
select project_id, count(*) as total_employees
from assignments 
group by project_id;

-- Show departments with more than 1 employees
select dept_id, count(*) as total_employees
from employees
group by dept_id
having count(*) > 1

-- Show projects that have more than 1 employees assigned
select project_id, count(emp_id) as team_size
from assignments
group by project_id
having count(*) > 1


-- Subqueries
-- Get employees with salary more than avg salary:
select emp_id, amount 
from salaries
where amount > (select avg(amount) from salaries)


-- Get the first names of employees along with the names of the departments they belong to. (join/ inner join)
select * 
from employees e
inner join departments d on e.dept_id = d.dept_id

-- Give all data of employees and project assigned to them (cross join)
select * from employees cross join projects 

-- Find employees with same department (self join)
select e1.first_name as emp1, e2.first_name as emp2, e1.dept_id
from employees e1
join employees e2 on e1.dept_id = e2.dept_id
where e1.emp_id <> e2.emp_id and e1.emp_id < e2.emp_id


-- Projects with assigned employees and vice versa (Full outer join)
select first_name, project_id
from employees e
full outer join assignments a on e.emp_id = a.emp_id


-- Get emp_id from salaries and attendance
select emp_id from salaries
UNION ALL 
select emp_id from attendance


-- Combination of concepts
-- Find employees earning more than the average salary in their department in asscending order of employee id
select e.first_name, e.last_name, e.dept_id
from employees e
join salaries s on e.emp_id = s.emp_id
where s.amount > 
	(select avg(s2.amount) 
	from salaries s2 join employees e2 on e2.emp_id=s2.emp_id 
	where e.dept_id = e2.dept_id)

-- Show employees and their project names (even if they aren't assigned)
select e.first_name, p.project_name
from employees e
left join assignments a on e.emp_id = a.emp_id
left join projects p on a.project_id = p.project_id

-- Get departments with more than 2 employees assigned to projects
select d.dept_name, count(a.emp_id) as emp_count
from departments d
join projects p on d.dept_id = p.dept_id
join assignments a on p.project_id = a.project_id
group by d.dept_name
having count(a.emp_id) < 2


-- Find employee pairs from the same department (Self Join)
select e1.first_name as emp1, e2.first_name as emp2, e1.dept_id
from employees e1
join employees e2 on e1.dept_id = e2.dept_id
where e1.emp_id < e2.emp_id -- and e1.emp_id < e2.emp_id








