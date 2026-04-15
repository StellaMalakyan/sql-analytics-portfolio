\c salary_prediction;
CREATE SCHEMA IF NOT EXISTS job_analytics;
DROP TABLE IF EXISTS job_analytics.country CASCADE;
CREATE TABLE job_analytics.country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL,
    country_code VARCHAR(10),
    geom GEOMETRY(MULTIPOLYGON, 4326)
);

