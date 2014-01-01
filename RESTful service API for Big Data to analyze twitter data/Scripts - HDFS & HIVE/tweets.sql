add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;
select user.screen_name, count(*) as total from tweets GROUP BY user.screen_name ORDER BY total DESC LIMIT 8;
