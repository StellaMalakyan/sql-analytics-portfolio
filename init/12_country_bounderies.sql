\c salary_prediction;
DROP TABLE IF EXISTS job_analytics._stg_world_countries CASCADE;
CREATE TABLE job_analytics._stg_world_countries (
    country_name TEXT NOT NULL,
    country_code TEXT NOT NULL,
    geom GEOMETRY(MULTIPOLYGON, 4326) NOT NULL
);


INSERT INTO job_analytics._stg_world_countries (country_name, country_code, geom)
SELECT
    feature->'properties'->>'name' AS country_name,
    feature->>'id' AS country_code,
    ST_SetSRID(
        ST_Multi(
            ST_CollectionExtract(
                ST_Force2D(ST_MakeValid(ST_GeomFromGeoJSON(feature->>'geometry'))), 
                3
            )
        ), 
        4326
    ) AS geom
FROM (
    SELECT jsonb_array_elements(data->'features') AS feature
    FROM (
        SELECT pg_read_file('/docker-entrypoint-initdb.d/data/job_analytics/countries.geo.json')::jsonb AS data
    ) f
) sub;


-- 4th step
INSERT INTO job_analytics.country (country_name, country_code, geom)
SELECT country_name, country_code, geom
FROM job_analytics._stg_world_countries;
