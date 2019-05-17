#### Yelp dataset mining with Hive
Mined 4million Yelp review to find coolest restaurants for recommendation  

#### Data
[Yelp challenge round9 dataset](https://www.yelp.com/dataset/challenge) 

convert to csv 
```sh
python json_to_csv_converter.py yelp_academic_dataset_reviews.json

```
put to hdfs
```sh
hdfs dfs -mkdir -p /user/xxx/hive/yelp/review
hdfs dfs -copyFromLocal yelp_academic_dataset_review.csv /user/xxx/hive/yelp/review/
```
 
work in hive
```sql
USE yingc_db;

drop table yelp_review;

CREATE TABLE IF NOT EXISTS yelp_review(
        type STRING,
        rev_date date,
        useful INT,
        stars INT,
        review_id BIGINT,
        user_id BIGINT,
        business_id BIGINT,
        text STRING,
        cool INT,
        funny INT
        )
COMMENT 'This is the yelp review data'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/xxx/hive/yelp/review/' OVERWRITE INTO TABLE yelp_review;

SELECT * FROM yelp_review LIMIT 100;
```

business
```sql

drop table yelp_business;

CREATE TABLE IF NOT EXISTS yelp_business(
        attribute STRING,
        business_id bigint,
        longitude string,
        hours string,
        address string,
        latitude string,
        city string,
        stars int,
        name string,
        type string,
        review_count int,
        categories string,
        postal_code int,
        state string,
        neighborhood string,
        is_open int
        )
COMMENT 'This is the yelp business data'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
ESCAPED BY '"'
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/xxx/hive/yelp/business' OVERWRITE INTO TABLE yelp_business;
```

top 10 
```sql
SELECT name, review_count, address, state
FROM yelp_business
ORDER BY review_count DESC
LIMIT 10;
```

funniest resturant
```sql
insert overwrite local directory 'funniest'
    ROW FORMAT DELIMITED 
    FIELDS TERMINATED BY ',' 
    
SELECT r.business_id, name, SUM(coolest) AS coolest
FROM yelp_review r JOIN yelp_business b
ON (r.business_id = b.business_id)
WHERE categories LIKE '%Restaurants%'
GROUP BY r.business_id, name
ORDER BY coolest DESC
LIMIT 10;

SELECT r.business_id, name, SUM(funny) AS funny
FROM yelp_review r JOIN yelp_business b
ON (r.business_id = b.business_id)
WHERE categories LIKE '%Restaurants%'
GROUP BY r.business_id, name
ORDER BY funny DESC
LIMIT 10;
```

![img](yelp_hive.png)