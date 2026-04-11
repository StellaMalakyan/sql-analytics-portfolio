\c salary_prediction;

DROP TABLE IF EXISTS job_analytics._stg_salary_prediction;

CREATE TABLE job_analytics._stg_salary_prediction (
    job_title VARCHAR(100),
    experience_years INT,
    education_level VARCHAR(100),
    skills_count INT,
    industry VARCHAR(100),
    company_size VARCHAR(100),
    location VARCHAR(100),
    remote_work VARCHAR(50),
    certifications INT,
    salary INT
);