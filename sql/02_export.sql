    COPY (SELECT * FROM cohort_long)
    TO 'output/cohort_long.csv' (HEADER, DELIMITER ',');
