# 🎬 Netflix Data Analysis Project Using SQL

![](https://github.com/Rajkumarthombare/Netflix_SQL_Project/blob/main/netflix%20logo.png)

 Overview
📌 Project Summary

This project focuses on analyzing the Netflix dataset to uncover content trends, distribution patterns, and business insights. Using SQL and data visualization tools, the analysis explores how Netflix’s content library has evolved over time and identifies key factors such as genre popularity, country contributions, and content growth trends.

🎯 Objective

The main objective of this project is to:

Analyze the distribution of Movies and TV Shows
Identify top contributing countries, actors, and directors
Understand content trends over time (yearly & monthly)
Evaluate content characteristics like duration and ratings
Provide actionable insights for content strategy and decision-making

#DATA SET :
![MOVIES DATASET](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

#SCHEMA:
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix(
show_id	VARCHAR(10),
type	VARCHAR(10),
title	VARCHAR(150),
director VARCHAR(220),
castS	 VARCHAR(1000),
country	 VARCHAR(150),
date_added	DATE,
release_year	VARCHAR(6),
rating	VARCHAR(10),
duration	VARCHAR(15),
listed_in	VARCHAR(85),
description VARCHAR(300)
);

SELECT * FROM netflix;

COPY netflix(show_id,type,title,director,castS,country,date_added,release_year,rating,duration,listed_in,description)
FROM 'E:/SQL/netflix_sql_project-main/netflix_titles.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM netflix;

--NETFLIX_SQL_PROJECT WITH 20 QUESTIONS AND ANSWERS.

--1.What is the total number of Movies and TV Shows available on Netflix?

SELECT type, COUNT(*) AS total_count
FROM netflix_titles
GROUP BY type;

--2.Which countries contribute the highest number of titles on Netflix?

SELECT country, COUNT(*) AS total
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total DESC
LIMIT 10;


--3.What is the most common content rating on Netflix?*

SELECT rating, COUNT(*) AS total
FROM netflix_titles
GROUP BY rating
ORDER BY total DESC
LIMIT 1;


--4.How has the number of content releases changed over the years?

SELECT release_year, COUNT(*) AS total
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;



--5.What percentage of Netflix content is Movies vs TV Shows?

SELECT 
    type,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles) AS percentage
FROM netflix_titles
GROUP BY type;


--6.Which directors have produced the highest number of titles on Netflix?

SELECT director, COUNT(*) AS total
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total DESC
LIMIT 10;


--7.Which movie has the longest duration on Netflix?

SELECT title, duration
FROM netflix_titles
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;


--8.How is content addition distributed across different months?

SELECT 
    EXTRACT(MONTH FROM TO_DATE(date_added, 'Month DD, YYYY')) AS month,
    COUNT(*) AS total
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY month
ORDER BY month;


--9.Which actors appear most frequently in Netflix content?

SELECT actor, COUNT(*) AS total
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(cast, ', ')) AS actor
    FROM netflix_titles
) t
GROUP BY actor
ORDER BY total DESC
LIMIT 1;


--10.What are the most common genres available on Netflix?

SELECT listed_in, COUNT(*) AS total
FROM netflix_titles
GROUP BY listed_in
ORDER BY total DESC
LIMIT 5;



--11.What is the average duration of movies on Netflix?

SELECT AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)) AS avg_duration
FROM netflix_titles
WHERE type = 'Movie';


--12.Which year had the highest number of content releases?

SELECT release_year, COUNT(*) AS total
FROM netflix_titles
GROUP BY release_year
ORDER BY total DESC
LIMIT 1;


--13.Which country produces movies with the highest average duration?

SELECT country, AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)) AS avg_duration
FROM netflix_titles
WHERE type = 'Movie' AND country IS NOT NULL
GROUP BY country
ORDER BY avg_duration DESC
LIMIT 1;


--14.How has Netflix content grown year-over-year?

SELECT release_year,
       COUNT(*) AS total,
       COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY release_year) AS growth
FROM netflix_titles
GROUP BY release_year;


--15.How do countries rank based on the total number of titles available?

SELECT country,
       COUNT(*) AS total,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country;


--16.What is the cumulative growth of content over the years?

SELECT release_year,
       COUNT(*) AS yearly_total,
       SUM(COUNT(*)) OVER (ORDER BY release_year) AS cumulative_total
FROM netflix_titles
GROUP BY release_year;


--17.Which genres are most popular in each year?

SELECT release_year, listed_in, total
FROM (
    SELECT release_year, listed_in, COUNT(*) AS total,
           RANK() OVER (PARTITION BY release_year ORDER BY COUNT(*) DESC) AS rnk
    FROM netflix_titles
    GROUP BY release_year, listed_in
) t
WHERE rnk = 1;



--18.Which directors have the highest average movie duration?

SELECT director,
       AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)) AS avg_duration
FROM netflix_titles
WHERE type = 'Movie' AND director IS NOT NULL
GROUP BY director
ORDER BY avg_duration DESC
LIMIT 1;


--19.Who are the most popular actors in each country?

SELECT country, actor, total
FROM (
    SELECT country,
           UNNEST(STRING_TO_ARRAY(cast, ', ')) AS actor,
           COUNT(*) AS total,
           RANK() OVER (PARTITION BY country ORDER BY COUNT(*) DESC) AS rnk
    FROM netflix_titles
    WHERE country IS NOT NULL
    GROUP BY country, actor
) t
WHERE rnk = 1;



--20.What is the gap between a title’s release year and the year it was added to Netflix?

SELECT 
    release_year,
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS added_year,
    COUNT(*) AS total
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY release_year, added_year
ORDER BY release_year;

📌 Conclusion

The analysis of the Netflix dataset provides valuable insights into the platform’s content strategy, growth patterns, and global distribution. It is evident that Netflix has significantly expanded its content library over the years, with a strong focus on both Movies and TV Shows to cater to diverse audience preferences.

The study highlights that a few countries dominate content production, indicating regional strengths in the entertainment industry. Additionally, certain genres and ratings consistently appear more frequently, suggesting Netflix’s focus on specific audience segments and viewing trends.

From a temporal perspective, content additions have increased steadily, with noticeable peaks in recent years, reflecting Netflix’s aggressive expansion strategy. Monthly trends also reveal patterns in content release scheduling, which may align with audience engagement cycles.

Insights into actors, directors, and content duration further emphasize how Netflix balances quantity with content diversity and quality. The gap between release year and platform addition also indicates strategic content acquisition and distribution decisions.
