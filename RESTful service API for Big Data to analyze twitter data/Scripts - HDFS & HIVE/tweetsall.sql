add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;
select user.screen_name, count(*) as n, max(user.statuses_count), max(user.followers_count), max(user.friends_count) from tweets GROUP BY user.screen_name ORDER BY n DESC LIMIT 20;
