DROP DATABASE IF EXISTS company;

CREATE DATABASE IF NOT EXISTS company DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE company;

CREATE TABLE IF NOT EXISTS employee (
    employee_id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    surname VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS department (
    department_id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    department_name VARCHAR (20) NOT NULL
);

CREATE TABLE IF NOT EXISTS job_position (
    job_position_id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    job_title VARCHAR (50) NOT NULL
);

CREATE TABLE IF NOT EXISTS employee_department (
    employee_id INT UNSIGNED,
    department_id INT UNSIGNED,
    job_position_id INT UNSIGNED,
    PRIMARY KEY (employee_id, department_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (job_position_id) REFERENCES job_position(job_position_id)
);

CREATE TABLE IF NOT EXISTS salary (
    salary_id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    employee_id INT UNSIGNED,
    salary_amount DECIMAL(8,2),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

-- populating database

INSERT INTO employee (employee_id, name, surname) VALUES
(1, 'Jan', 'Geci'),
(2, 'Darko', 'Sever'),
(3, 'Mia', 'Vuk'),
(4, 'Marija', 'Juric'),
(5, 'Ivan', 'Horvat'),
(6, 'Jasna', 'Zlatic'),
(7, 'Sergej', 'Pitner'),
(8, 'Leon', 'Slatki'),
(9, 'Dijana', 'Babic'),
(10, 'Dino', 'Matic');

INSERT INTO department (department_id, department_name) VALUES
(1, 'Head Office'),
(2, 'Production'),
(3, 'Human resources'),
(4, 'Quality control'),
(5, 'IT'),
(6, 'Sales'),
(7, 'Finance');

INSERT INTO job_position (job_position_id, job_title) VALUES
(1, 'Plant Head'),
(2, 'HR Specialist'),
(3, 'QC Supervisor'),
(4, 'Accounting Specialist'),
(5, 'Maintenance Engineer'),
(6, 'IT assistant'),
(7, 'Customer Service Officer'),
(8, 'HOD'),
(9, 'Production Operator');


INSERT INTO employee_department (employee_id, department_id, job_position_id) VALUES
(1, 2, 9),
(2, 1, 1),
(3, 2, 9),
(4, 7, 4),
(5, 5, 6),
(6, 3, 2),
(7, 6, 8),
(8, 6, 8),
(9, 4, 8),
(9, 2, 9),
(10, 6, 7),
(10, 3, 8);

INSERT INTO salary (salary_id, employee_id, salary_amount) VALUES
(1, 1, 1800.00),
(2, 2, 5000.00),
(3, 3, 2000.00),
(4, 4, 1500.00),
(5, 5, 1700.00),
(6, 6, 1200.00),
(7, 7, 1300.00),
(8, 8, 1200.00),
(9, 9, 1600.00),
(10, 10, 1600.00);

-- Queries

-- Select all employees and their salaries

SELECT e.name, e.surname, s.salary_amount 
FROM employee e 
JOIN salary s ON e.employee_id = s.employee_id;

/*
+--------+---------+---------------+
| name   | surname | salary_amount |
+--------+---------+---------------+
| Jan    | Geci    |       1800.00 |
| Darko  | Sever   |       5000.00 |
| Mia    | Vuk     |       2000.00 |
| Marija | Juric   |       1500.00 |
| Ivan   | Horvat  |       1700.00 |
| Jasna  | Zlatic  |       1200.00 |
| Sergej | Pitner  |       1300.00 |
| Leon   | Slatki  |       1200.00 |
| Dijana | Babic   |       1600.00 |
| Dino   | Matic   |       1600.00 |
+--------+---------+---------------+
*/

-- Select all HODs and their salaries (include job_position and department) / additional query for HODs

SELECT e.name, e.surname, jp.job_title, s.salary_amount
FROM employee e
JOIN salary s ON e.employee_id = s.employee_id
JOIN employee_department ed ON e.employee_id = ed.employee_id
JOIN job_position jp ON ed.job_position_id = jp.job_position_id
WHERE jp.job_title = 'HOD';

/*
+--------+---------+-----------+---------------+
| name   | surname | job_title | salary_amount |
+--------+---------+-----------+---------------+
| Sergej | Pitner  | HOD       |       1300.00 |
| Leon   | Slatki  | HOD       |       1200.00 |
| Dijana | Babic   | HOD       |       1600.00 |
| Dino   | Matic   | HOD       |       1600.00 |
+--------+---------+-----------+---------------+
*/

--Select all HODs and calculate average of their salaries

SELECT FORMAT(AVG(salary_amount), 2) AS average_HOD_salary
FROM salary
WHERE employee_id IN (
    SELECT employee_id
    FROM employee_department
    JOIN job_position ON employee_department.job_position_id = job_position.job_position_id
    WHERE job_position.job_title = 'HOD'
);

/*
+--------------------+
| average_HOD_salary |
+--------------------+
| 1,425.00           |
+--------------------+
*/

-- Create procedure that will calculate average of all salaries (all employees)

DELIMITER $$

CREATE PROCEDURE employees_average_salary()
BEGIN
    SELECT FORMAT(AVG(salary_amount), 2) AS average_salary
    FROM salary;
END $$

DELIMITER ;

CALL employees_average_salary();

/*
+----------------+
| average_salary |
+----------------+
| 1,890.00       |
+----------------+
*/