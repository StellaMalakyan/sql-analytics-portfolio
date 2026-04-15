DROP TABLE IF EXISTS job_analytics.city CASCADE;
CREATE TABLE job_analytics.city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    country_id INT REFERENCES job_analytics.country(country_id),
    UNIQUE (city_name, country_id)
);

INSERT INTO job_analytics.city (city_name, country_id)
SELECT DISTINCT
    s.location, 
    c.country_id
FROM job_analytics._stg_salary_prediction s
JOIN job_analytics.country c ON s.location = c.country_name
WHERE s.location NOT IN ('Remote', 'Europe', 'Asia') 
  AND s.location IS NOT NULL;

  