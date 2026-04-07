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