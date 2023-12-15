SELECT EXTRACT(YEAR FROM order_date) AS order_year, EXTRACT(MONTH FROM order_date) AS order_month FROM orders;

SELECT DATE_ADD(order_date, INTERVAL 3 DAY) AS new_order_date FROM orders;
SELECT empname, DATEDIFF(CURDATE(), dob) / 365 AS age
FROM employee;

SELECT s.sid, s.sname
FROM Sailor s
WHERE NOT EXISTS (
    SELECT b.bid
    FROM Boats b
    WHERE NOT EXISTS (
        SELECT 1
        FROM Reserves r
        WHERE r.sid = s.sid AND r.bid = b.bid
    )
);

UPDATE RATING
SET Rev_Stars = 5
WHERE Mov_id IN (SELECT M.Mov_id FROM MOVIES M JOIN DIRECTOR D ON M.Dir_id = D.Dir_id WHERE D.Dir_Name = 'Vineeth Sreenivasan');


Select salarymanagement.calculate('sales') from dual;

CREATE OR REPLACE TRIGGER delete_trigger
AFTER DELETE ON Passenger
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('1 record is deleted');
END;

CREATE OR REPLACE TRIGGER insert_trigger
AFTER INSERT ON Passenger
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('1 record is inserted');
END;


CREATE OR REPLACE TRIGGER insert_trigger
AFTER INSERT ON Passenger
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('1 record is inserted');
END;
/

CREATE TABLE Passenger (
    Passport_id INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Age INTEGER NOT NULL,
    Sex CHAR,
    Address VARCHAR(50) NOT NULL
);
INSERT INTO Passenger (Passport_id, Name, Age, Sex, Address)
VALUES 
    (1, 'John Doe', 35, 'M', '123 Main St'),
    (2, 'Jane Smith', 28, 'F', '456 Elm St'),
    (3, 'Alice Johnson', 42, 'F', '789 Oak St'),
    (4, 'Bob Williams', 25, 'M', '101 Pine St');


INSERT INTO salary (employee_no, employee_name, designation, department, basic_salary, AM, DM, other_allowances, deduction_from_salary)
VALUES (1, 'John Doe', 'Manager', 'Sales', 5000, 1000, 500, 800, 300);

INSERT INTO salary (employee_no, employee_name, designation, department, basic_salary, AM, DM, other_allowances, deduction_from_salary)
VALUES (2, 'Jane Smith', 'Analyst', 'Finance', 4000, 800, 400, 600, 200);

INSERT INTO salary (employee_no, employee_name, designation, department, basic_salary, AM, DM, other_allowances, deduction_from_salary)
VALUES (3, 'Robert Johnson', 'Developer', 'IT', 4500, 900, 450, 700, 250);


CREATE TABLE salary (
    employee_no NUMBER,
    employee_name VARCHAR2(100),
    designation VARCHAR2(100),
    department VARCHAR2(100),
    basic_salary NUMBER,
    AM NUMBER,
    DM NUMBER,
    other_allowances NUMBER,
    deduction_from_salary NUMBER
);


CREATE OR REPLACE PACKAGE BODY SalaryManagement IS

  PROCEDURE UpdateEmployeeSalary(
    emp_id IN NUMBER,
    new_salary IN NUMBER
  ) IS
  BEGIN
    UPDATE salary
    SET basic_salary = new_salary
    WHERE employee_no = emp_id;
    
    DBMS_OUTPUT.PUT_LINE('Employee salary updated successfully.');
  END UpdateEmployeeSalary;
  
   FUNCTION CalculateDepartmentSalaryBudget(
    dept_name IN VARCHAR2
  ) RETURN NUMBER IS
    total_budget NUMBER := 0;
  BEGIN
    SELECT SUM(basic_salary + AM + DM + other_allowances - deduction_from_salary)
    INTO total_budget
    FROM salary
    WHERE department = dept_name;
    
    RETURN total_budget;
    END CalculateDepartmentSalaryBudget;
  
END SalaryManagement;
/


CREATE OR REPLACE PACKAGE SalaryManagement IS
  -- Procedure to update an employee's salary
  PROCEDURE UpdateEmployeeSalary(
    emp_id IN NUMBER,
    new_salary IN NUMBER
  );
  
  -- Function to calculate the total salary budget for a department
  FUNCTION CalculateDepartmentSalaryBudget(
    dept_name IN VARCHAR2
  ) RETURN NUMBER;
  
END SalaryManagement;
/


CREATE OR REPLACE PROCEDURE CalculatePayrollProcess IS
net_salary NUMBER;
  b_salary salary.basic_salary%TYPE;
  AM salary.AM%TYPE;
  DM salary.DM%TYPE;
  other_allowances salary.other_allowances%TYPE;
  deduction salary.deduction_from_salary%TYPE;
  
  CURSOR PAYROLL IS
    SELECT basic_salary, AM, DM, other_allowances, deduction_from_salary 
    FROM salary;

BEGIN
  OPEN PAYROLL;
  
  LOOP
    FETCH PAYROLL INTO b_salary, AM, DM, other_allowances, deduction;
    EXIT WHEN PAYROLL%NOTFOUND;
    
    net_salary := b_salary + AM + DM + other_allowances - deduction;
    dbms_output.put_line('Net salary: ' || net_salary);
  END LOOP;
  
  CLOSE PAYROLL;
END;
/

DECLARE 
  net_salary NUMBER;
  b_salary salary.basic_salary%TYPE;
  AM salary.AM%TYPE;
  DM salary.DM%TYPE;
  other_allowances salary.other_allowances%TYPE;
  deduction salary.deduction_from_salary%TYPE;
  
  CURSOR PAYROLL IS
    SELECT basic_salary, AM, DM, other_allowances, deduction_from_salary 
    FROM salary;

BEGIN
  OPEN PAYROLL;
  
  LOOP
    FETCH PAYROLL INTO b_salary, AM, DM, other_allowances, deduction;
    EXIT WHEN PAYROLL%NOTFOUND;
    
    net_salary := b_salary + AM + DM + other_allowances - deduction;
    dbms_output.put_line('Net salary: ' || net_salary);
  END LOOP;
  
  CLOSE PAYROLL;
END;
/