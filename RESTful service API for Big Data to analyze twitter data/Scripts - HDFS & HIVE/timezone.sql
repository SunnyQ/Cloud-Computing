add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;
SELECT user.time_zone, COUNT(*) AS total_count FROM tweets WHERE user.time_zone IS NOT NULL GROUP BY user.time_zone ORDER BY total_count DESC LIMIT 50;
