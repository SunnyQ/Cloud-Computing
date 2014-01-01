add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;
SELECT LOWER(hashtags.text), COUNT(*) AS total_count FROM tweets LATERAL VIEW EXPLODE(entities.hashtags) t1 AS hashtags GROUP BY LOWER(hashtags.text) ORDER BY total_count DESC LIMIT 15;
