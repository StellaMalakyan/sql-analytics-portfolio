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