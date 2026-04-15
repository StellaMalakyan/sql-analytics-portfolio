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
