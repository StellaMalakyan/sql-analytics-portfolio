\c salary_prediction;
CREATE TABLE job_analytics.salary_fact (
    fact_id SERIAL PRIMARY KEY,
    job_title_id INT REFERENCES job_analytics.job_title(job_title_id),
    industry_id INT REFERENCES job_analytics.industry(industry_id),
    education_id INT REFERENCES job_analytics.education_level(education_id),
    company_size_id INT REFERENCES job_analytics.company_size(company_size_id),
    remote_work_id INT REFERENCES job_analytics.remote_work_type(remote_work_id),
    employment_type_id INT REFERENCES job_analytics.employment_type(employment_type_id),
    city_id INT REFERENCES job_analytics.city(city_id),
    
    experience_years NUMERIC,
    salary NUMERIC,
    certificates_count INT,
    skills_count INT,
    job_post_date DATE
);

TRUNCATE TABLE job_analytics.salary_fact;

INSERT INTO job_analytics.salary_fact (
    job_title_id, industry_id, education_id, company_size_id, 
    remote_work_id, employment_type_id, city_id, 
    experience_years, salary, certificates_count, skills_count
)
SELECT 
    jt.job_title_id, ind.industry_id, ed.education_id, cs.company_size_id, 
    rw.remote_work_id, 
    (SELECT employment_type_id FROM job_analytics.employment_type WHERE employment_type_name = 'Full-time' LIMIT 1),
    ci.city_id,
    s.experience_years, s.salary, s.certifications, s.skills_count
FROM job_analytics._stg_salary_prediction s
LEFT JOIN job_analytics.job_title jt ON TRIM(s.job_title) = jt.job_title_name
LEFT JOIN job_analytics.industry ind ON TRIM(s.industry) = ind.industry_name
LEFT JOIN job_analytics.education_level ed ON TRIM(s.education_level) = ed.education_name
LEFT JOIN job_analytics.company_size cs ON TRIM(s.company_size) = cs.size_category
LEFT JOIN job_analytics.remote_work_type rw ON TRIM(s.remote_work) = rw.remote_work_name
LEFT JOIN job_analytics.country co ON 
    CASE 
        WHEN TRIM(s.location) = 'USA' THEN 'United States of America'
        WHEN TRIM(s.location) = 'UK' THEN 'United Kingdom'
        WHEN TRIM(s.location) = 'Singapore' THEN 'Singapore'
        ELSE TRIM(s.location)
    END = co.country_name
LEFT JOIN job_analytics.city ci ON co.country_id = ci.country_id;