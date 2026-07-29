--Top 5 highly paid countries based on avg salaries
SELECT 
    c.country_name, 
    ROUND(AVG(sf.salary), 2) AS average_salary,
    COUNT(*) AS job_count
FROM job_analytics.salary_fact sf
JOIN job_analytics.city ci ON sf.city_id = ci.city_id
JOIN job_analytics.country c ON ci.country_id = c.country_id
GROUP BY c.country_name
HAVING COUNT(*) > 100 -- Checking only countries with more data
ORDER BY average_salary DESC
LIMIT 5;
--The USA, Canada, UK, Germany and Sweden have the highest average salaries.

--Top Industries
SELECT 
    i.industry_name, 
    ROUND(AVG(sf.salary), 2) AS average_salary
FROM job_analytics.salary_fact sf
JOIN job_analytics.industry i ON sf.industry_id = i.industry_id
GROUP BY i.industry_name
ORDER BY average_salary DESC;
--Education, media, telecom, technology

--remote or on site
SELECT 
    r.remote_work_name, 
    ROUND(AVG(sf.salary), 2) AS average_salary
FROM job_analytics.salary_fact sf
JOIN job_analytics.remote_work_type r ON sf.remote_work_id = r.remote_work_id
GROUP BY r.remote_work_name;
--Working from home (Remote) usually pays better than working in an office

