--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;
	select * from employees;
    SELECT * FROM employees;
    SET FOREIGN_KEY_CHECKS = 0; 
ALTER TABLE employees MODIFY COLUMN emp_no INT AUTO_INCREMENT;
SET FOREIGN_KEY_CHECKS = 1;
    INSERT INTO employees (birth_date, first_name, last_name, gender, hire_date)
    VALUES ('1995-10-04', 'Pepe', 'Lopez', 'M', '2019-10-03'),
    ('1995-10-06', 'Pepe', 'Rodriguez', 'M', '2019-10-06'),
    ('1998-04-15', 'Anna', 'Perez', 'F', '2020-02-11'),
    ('1988-04-04', 'Pepe', 'Marin', 'M', '2017-3-01'),
    ('1975-01-11', 'Lucia', 'Sanchez', 'F', '2000-01-01'),
    ('1999-12-20', 'Pedro', 'Garza', 'M', '2020-08-02'),
    ('1967-10-24', 'Pablo', 'Gonzalez', 'M', '1990-01-11'),
    ('1969-07-17', 'Pepa', 'Ortiz', 'F', '1993-10-01'),
    ('1975-12-20', 'Luis', 'Cortázar', 'M', '1997-10-03'),
    ('1999-05-13', 'Jose', 'Sierra', 'M', '2019-10-10'),
    ('1962-03-07', 'Manuela', 'Puig', 'F', '1983-10-03'),
    ('1980-05-23', 'Oscar', 'Lopez', 'M', '2005-06-12'),
    ('1998-10-04', 'Carlos', 'Boadas', 'M', '2021-11-13'),
    ('1999-01-16', 'Mar', 'Torrent', 'F', '2020-03-12'),
    ('2000-01-12', 'Cristina', 'Gomez', 'F', '2021-12-22');
    SELECT * FROM employees;
    
    INSERT INTO departments (dept_no, dept_name) VALUES
    ('mrk', 'marketing'),
    ('cont', 'contabilidad'),
    ('adm', 'administración');
    SELECT * FROM departments;
    
    INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date)
    VALUES (11, 'mrk', '1983-10-03', '2024-01-01'),
    (7, 'cont', '1990-01-11', '2025-02-02'),
    (8, 'adm', '1993-10-01', '2023-12-20'),
    (9, 'cont', '1997-10-03', '2026-01-12'),
    (5, 'mrk', '2000-01-01', '2027-02-16');
    SELECT * FROM dept_manager;
    INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
     VALUES (12, 'mrk', '2005-06-12', '2026-01-01'),
     (13,'mrk', '2021-11-13', '2027-02-04'),
     (14,'mrk', '2020-03-12', '2025-04-08'),
     (15,'cont', '2021-12-22', '2025-01-04'),
     (1,'cont', '2019-10-03', '2028-12-04'),
     (2,'mrk', '2019-10-06', '2026-09-14'),
     (3,'adm', '2020-02-11', '2028-08-20'),
     (4,'cont', '2017-3-01', '2029-06-19'),
     (6,'mrk', '2020-08-02', '2024-11-17');
     INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date) VALUES
     (10,'adm', '2019-10-10', '2025-12-19');
     
     SELECT * FROM dept_emp;
     
     INSERT INTO titles (emp_no, title, from_date, to_date) VALUES 
     (1, 'economia', '2013-10-07', '2020-08-23'),
     (2, 'derecho', '2012-03-22', '2019-05-22'),
     (3, 'marketing', '2013-02-12', '2020-06-23'),
     (4, 'publicidad', '2013-04-15', '2019-06-21'),
     (5, 'relacionaes publicas', '2018-05-13', '2020-07-17'),
     (6, 'administracion de empresas', '2016-04-10', '2020-10-02'),
     (7, 'derecho mercantil', '2011-03-10', '2019-10-23'),
     (8, 'economia', '2013-08-14', '2020-06-21'),
     (9, 'historia', '2017-10-20', '2019-02-10'),
     (10, 'economia', '2015-05-14', '2019-06-23'),
     (11, 'publicidad', '2012-12-03', '2019-07-22'),
     (12, 'marketing', '2012-03-12', '2019-08-12'),
     (13, 'periodismo', '2012-03-12', '2019-07-22'),
     (14, 'economia', '2016-05-24', '2020-06-22'),
     (15, 'derecho', '2012-10-10', '2019-07-22');
     DROP TABLE IF EXISTS titles;
     SELECT * FROM titles;
     INSERT INTO salaries (emp_no, salary, from_date, to_date) VALUES
     (1, 10000,'2018-03-10', '2020-04-10'),
     (2, 44000, '2020-08-12', '2021-03-15'),
     (3, 22000, '2019-07-09', '2020-03-13'),
     (4, 33000, '2018-03-10', '2022-03-10'),
     (5, 45000,'2019-07-14', '2021-03-11'),
     (6, 50000, '2018-03-10', '2020-11-10'),
     (7, 5000, '2019-11-14', '2021-03-04'),
     (8, 18000, '2019-12-10', '2022-11-10'),
     (9, 49000, '2018-02-10', '2023-06-10'),
     (10, 36000, '2019-03-10', '2024-08-14'),
     (11, 32000, '2018-03-10', '2022-10-10'),
     (12, 21000, '2020-03-10', '2030-03-11'),
     (13, 30000, '2017-06-10', '2023-03-15'),
     (14, 15000, '2018-12-16', '2023-12-10'),
     (15, 16000, '2018-05-16', '2030-12-16');
     SELECT * FROM salaries;
     SELECT emp_no FROM employees where first_name ='Lucas';
    DROP TABLE IF EXISTS employees;
    UPDATE employees
SET first_name = 'Alba'
WHERE emp_no = 3;
UPDATE departments
SET dept_name = 'marketingcool'
WHERE dept_no = 'mrk';
UPDATE departments
SET dept_name = 'contabilidadcool'
WHERE dept_no = 'cont';
UPDATE departments
SET dept_name = 'administracióncool'
WHERE dept_no = 'adm';
 SELECT * FROM salaries where salary > 20000; 
 SELECT employees.emp_no,  salaries.salary, employees.first_name, employees.last_name
FROM salaries
INNER JOIN employees ON salaries.emp_no=employees.emp_no where salaries.salary > 20000;
 SELECT employees.emp_no,  salaries.salary, employees.first_name, employees.last_name
FROM salaries
INNER JOIN employees ON salaries.emp_no=employees.emp_no where salaries.salary < 10000;
UPDATE salaries
SET salary = 6000
WHERE emp_no = 2;
  SELECT employees.emp_no,  salaries.salary, employees.first_name, employees.last_name
FROM salaries
INNER JOIN employees ON salaries.emp_no=employees.emp_no where salaries.salary < 50000 and salaries.salary > 14000;  
SELECT max(emp_no) as mayor from employees;