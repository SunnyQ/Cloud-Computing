add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/00'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062700');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/01'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062701');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/02'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062702');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/03'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062703');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/04'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062704');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/05'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062705');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/06'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062706');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/07'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062707');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/08'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062708');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/09'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062709');
LOAD DATA INPATH '/user/flume/tweets/2013/06/27/10'
INTO TABLE `default.tweets`
PARTITION (datehour='2013062710');
