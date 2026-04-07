--NETFLIX_SQL_PROJECT WITH 20 QUESTIONS.

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

