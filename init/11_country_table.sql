DROP TABLE IF EXISTS job_analytics.country CASCADE;
CREATE TABLE job_analytics.country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL,
    country_code VARCHAR(10),
    geom GEOMETRY(MULTIPOLYGON, 4326)
);

-- 4th step
INSERT INTO job_analytics.country (country_name, country_code, geom)
SELECT country_name, country_code, geom
FROM job_analytics._stg_world_countries;