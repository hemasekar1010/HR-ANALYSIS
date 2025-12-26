-- CREATE DATABASE
CREATE DATABASE project_hr_analytics;

USE project_hr_analytics;

SELECT * FROM HR;

DESC HR;

-- TOTAL COUNT
SELECT COUNT(*) FROM HR;

-- TO CHANGE THE BIRTHDATE FORMAT
UPDATE HR
SET birthdate = DATE_FORMAT(STR_TO_DATE(birthdate, '%d-%m-%Y'), '%Y-%m-%d'),
    hire_date = DATE_FORMAT(STR_TO_DATE(hire_date, '%d-%m-%Y'), '%Y-%m-%d');
    
-- TO CHANGE THE DATATYPE 
ALTER TABLE HR 
MODIFY COLUMN birthdate DATE,
MODIFY COLUMN hire_date DATE;

-- TO CHANGE FORMAT
UPDATE HR
SET termdate = CASE
    WHEN termdate = '' THEN NULL
    ELSE STR_TO_DATE(REPLACE(termdate,' UTC',''), '%Y-%m-%d %H:%i:%s')
END;
-- TO CHANGE DATATYPE
ALTER TABLE HR
MODIFY COLUMN termdate DATE;

-- QUESTIONS NEED TO BE FIND
--  NO OF THE EMPLOYES
SELECT COUNT(id) AS total_employees FROM HR;

-- PERCENT OF WORKERS WORKING REMOTELY AND IN HQ
SELECT * FROM HR;
SELECT 
    ROUND(100 * SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END) / COUNT(*), 2) AS remote_percent,
    ROUND(100 * SUM(CASE WHEN location = 'Headquarters' THEN 1 ELSE 0 END) / COUNT(*), 2) AS hq_percent
FROM HR;

-- Percent of workers working remotely and in HQ (as ratios)
SELECT  
    SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS remote_ratio,
    SUM(CASE WHEN location = 'Headquarters' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS hq_ratio
FROM HR;



-- FIND THE AVG AGE
SELECT * FROM HR;
SELECT AVG(Age) AS avg_age_of_employee FROM HR;




-- HIRING RATE BY YEAR
SELECT 
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS hires_in_year,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM HR), 2) AS percent_of_total
FROM HR
GROUP BY YEAR(hire_date)
ORDER BY hires_in_year DESC;

-- GENDER OF EMPLOYEES
SELECT gender, 
    COUNT(*) AS gender_count
FROM HR
GROUP BY gender;

-- EMPLOYEES BY STATE,DEPARTMENT,RACE
SELECT 
    location_state AS state,
    department,
    race,
    COUNT(*) AS employee_count
FROM HR
WHERE location_state IS NOT NULL 
  AND department IS NOT NULL 
  AND race IS NOT NULL
GROUP BY location_state, department, race
ORDER BY location_state, department, race;

-- EMPLOYEES BY STATE
SELECT 
    location_state AS state,
    COUNT(*) AS employee_count
FROM HR
WHERE location_state IS NOT NULL
GROUP BY location_state
ORDER BY employee_count DESC;

-- Employees by Department
SELECT 
    department,
    COUNT(*) AS employee_count
FROM HR
WHERE department IS NOT NULL
GROUP BY department
ORDER BY employee_count DESC;

-- EMPLOYEES BY RACE
SELECT 
    race,
    COUNT(*) AS employee_count
FROM HR
WHERE race IS NOT NULL
GROUP BY race
ORDER BY employee_count DESC;

-- DISTRIBUTION OF JOB ACROSS THE COMPANY
SELECT jobtitle, COUNT(*) AS employee_count
FROM HR
WHERE age > 18 
  AND termdate IS NULL
GROUP BY jobtitle
ORDER BY employee_count DESC;
-- AGE DISTRIBUTION 
SELECT 
      CASE
          WHEN age>=18 AND age<=24 THEN '18-24'
          WHEN age>=25 AND age<=34 THEN '25-34'
          WHEN age>=35 AND age<=44 THEN '35-44'
          WHEN age>=45 AND age<=54 THEN '45-54'
          WHEN age>=55 AND age<=64 THEN '55-64'
          ELSE '65+'
	END AS age_group,
    COUNT(*) AS no_of_count
    FROM HR
    WHERE termdate IS NULL
    GROUP BY age_group
    ORDER BY age_group;
    
    -- WHAT IS THE AVERAGE LENGTH OF EMPLOYMENT WHO HAVE BEEN TERMINATED
    
    SELECT ROUND(AVG(year(termdate)-year(hire_date)),0) AS length_of_emp
    FROM HR
    WHERE termdate IS NOT NULL AND termdate <=curdate()
    
-- Which department has the highest turnover rate?
SELECT  department, total, total_term, ROUND((total_term / total) * 100, 2) AS ratio
FROM (
    SELECT department,
           COUNT(*) AS total,
           SUM(CASE
                   WHEN termdate IS NOT NULL AND termdate <= CURDATE()
                   THEN 1
                   ELSE 0
               END) AS total_term
    FROM HR
    WHERE age > 18
    GROUP BY department
) AS subquery
ORDER BY  total_term DESC, ratio DESC;

-- How has the company’s workforce changed year by year
SELECT 
    YEAR(hire_date) AS year,
    COUNT(*) AS hires,
    SUM(CASE 
            WHEN termdate IS NOT NULL AND termdate <= CURDATE() 
            THEN 1 
            ELSE 0 
        END) AS terminations
FROM hr
GROUP BY YEAR(hire_date)
ORDER BY year;

-- 


    
    SELECT * FROM HR;