CREATE TABLE job_analytics.job_title (
    job_title_id SERIAL PRIMARY KEY,
    job_title_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE job_analytics.industry (
    industry_id SERIAL PRIMARY KEY,
    industry_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE job_analytics.company_size (
    company_size_id SERIAL PRIMARY KEY,
    size_category VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE job_analytics.education_level (
    education_id SERIAL PRIMARY KEY,
    education_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE job_analytics.remote_work_type (
    remote_work_id SERIAL PRIMARY KEY,
    remote_work_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE job_analytics.employment_type (
    employment_type_id SERIAL PRIMARY KEY,
    employment_type_name VARCHAR(50) UNIQUE NOT NULL
);


INSERT INTO job_analytics.employment_type (employment_type_name)
VALUES ('Full-time'), ('Part-time'), ('Contract'), ('Freelance')
ON CONFLICT DO NOTHING;

INSERT INTO job_analytics.remote_work_type (remote_work_name)
SELECT DISTINCT TRIM(remote_work) 
FROM job_analytics._stg_salary_prediction 
WHERE remote_work IS NOT NULL 
ON CONFLICT DO NOTHING;

INSERT INTO job_analytics.education_level (education_name)
SELECT DISTINCT TRIM(education_level) 
FROM job_analytics._stg_salary_prediction 
WHERE education_level IS NOT NULL 
ON CONFLICT DO NOTHING;

INSERT INTO job_analytics.job_title (job_title_name)
SELECT DISTINCT TRIM(job_title) 
FROM job_analytics._stg_salary_prediction 
WHERE job_title IS NOT NULL 
ON CONFLICT DO NOTHING;

INSERT INTO job_analytics.industry (industry_name)
SELECT DISTINCT TRIM(industry) 
FROM job_analytics._stg_salary_prediction 
WHERE industry IS NOT NULL 
ON CONFLICT DO NOTHING;

INSERT INTO job_analytics.company_size (size_category)
SELECT DISTINCT TRIM(company_size) 
FROM job_analytics._stg_salary_prediction 
WHERE company_size IS NOT NULL 
ON CONFLICT DO NOTHING;