\c salary_prediction;

COPY job_analytics._stg_salary_prediction
FROM '/salary_data/salary_prediction_denormalized.csv'
CSV HEADER
NULL 'NULL';

