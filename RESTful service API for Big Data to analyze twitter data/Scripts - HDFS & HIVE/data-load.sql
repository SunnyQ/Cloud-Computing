add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;
LOAD DATA INPATH '/user/flume/tweets/2013/06/29/09' INTO TABLE `default.tweets` PARTITION (datehour='2013062909');
