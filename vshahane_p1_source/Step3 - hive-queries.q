CREATE EXTERNAL TABLE IF NOT EXISTS wikidata (
article_name STRING,
time_series_yyyymmdd STRING,
time_series_page_views STRING,
sum_page_views INT,
popularity_trend INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
LOCATION 's3://vshahane/outputstep2/';

SELECT article_name, sum_page_views FROM wikidata ORDER BY sum_page_views DESC, article_name ASC LIMIT 100;

SELECT article_name, popularity_trend FROM wikidata ORDER BY popularity_trend DESC, article_name ASC LIMIT 100;

SELECT * FROM wikidata WHERE article_name LIKE "%entertainer%" ORDER BY sum_page_views DESC, article_name ASC;

SELECT * FROM wikidata WHERE article_name LIKE "%coin%" ORDER BY sum_page_views DESC, article_name ASC;

SELECT * FROM wikidata WHERE article_name LIKE "%square%" ORDER BY sum_page_views DESC, article_name ASC;

SELECT * FROM wikidata WHERE article_name LIKE "%michael%" ORDER BY sum_page_views DESC, article_name ASC;