----veiwing viewership table
SELECT
  *
FROM
  "BRIGHTV"."PUBLIC"."VIEWERSHIP"
LIMIT
  10;

  ----veiwing userprofile table
  SELECT
  *
FROM
  BRIGHTV.PUBLIC.USERPROFILES
LIMIT
  10;


----correcting recorddate2 to correcting timestamp
SELECT
    recorddate2,
    TO_TIMESTAMP_NTZ(recorddate2, 'YYYY/MM/DD HH24:MI') AS corrected_recorddate
FROM "BRIGHTV"."PUBLIC"."VIEWERSHIP";

--------- joining 2 tables using FULL OUTER JOIN and correcting TIMESTAMP on recorddate2 column
------cannot use LEFT JOIN - result will only be from LEFT TABLE, cannot use INNER JOIN as result will be of common column ONLY
---CREATE TEMP TABLE brightviewerprofile AS

SELECT
    A.userid,
    B.name,
    B.surname,
    B.email,
    B.gender,
    B.race,
    B.age,
    CASE
        WHEN B.age = 0 THEN 'NOT SPECIFIED'
        WHEN B.age BETWEEN 1 AND 11 THEN 'KIDS'
        WHEN B.age BETWEEN 12 AND 19 THEN 'TEENAGER'
        WHEN B.age BETWEEN 20 AND 35 THEN 'YOUNG'
        WHEN B.age BETWEEN 36 AND 50 THEN 'ADULTS'
        WHEN B.age BETWEEN 51 AND 64 THEN 'MATURED AGE'
        ELSE 'SENIORS'
    END AS age_groups,
    B.province,
    B.social_media_handle,
    A.channel2,
    A.duration2,
    A.recorddate2,
    
    TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI') AS corrected_recorddate,
    TO_DATE(TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI')) AS record_date,
    TO_TIME(TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI')) AS record_time,
    DAYNAME(TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI')) AS day_name,
    CASE
        WHEN TO_TIME(TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN TO_TIME(TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN TO_TIME(TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        WHEN TO_TIME(TO_TIMESTAMP_NTZ(A.recorddate2, 'YYYY/MM/DD HH24:MI')) BETWEEN '00:00:00' AND '05:59:59' THEN 'Night'
    END AS time_groups
FROM BRIGHTV.PUBLIC.VIEWERSHIP AS A
FULL OUTER JOIN BRIGHTV.PUBLIC.USERPROFILES AS B
    ON A.userid = B.userid
WHERE 
      A.userid IS NOT NULL
  AND B.name IS NOT NULL
  AND B.surname IS NOT NULL
  AND B.email IS NOT NULL
  AND B.gender IS NOT NULL
  AND B.race IS NOT NULL
  AND B.age IS NOT NULL
  AND B.province IS NOT NULL
  AND B.social_media_handle IS NOT NULL
  AND A.channel2 IS NOT NULL
  AND A.duration2 IS NOT NULL
  AND A.recorddate2 IS NOT NULL;
