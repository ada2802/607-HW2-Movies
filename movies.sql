/*
  movies.sql 
  
  Three main tasks are as following:
  *Import raw data to DB from the external CSV files - movieddata, audiances and rating
  *Generate a new table movieRecommend which contain all data from the CSV files
  *Export the full data set - movieRecommend as CSV file to the external folder 
*/

/*Import Data*/
/*Delete duplicated tables which have same names as those need be created*/
DROP TABLE IF EXISTS moviedata;
DROP TABLE IF EXISTS audiances;
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS movieRecommend;

/*Create tables in MySQL DB to store original movie raw data from three external CSV files*/
/*Create a moviedata table for movie data*/
CREATE TABLE moviedata 
(
  movId int(25) NOT NULL,
  titles varchar(300) NOT NULL,
  release_date date,
  movType varchar(200) NOT NULL,
  languages varchar(100) NOT NULL,
  length time,
  
  PRIMARY KEY(movId)
);

SELECT * FROM moviedata;

LOAD DATA LOCAL INFILE 'D:/CUNY_SPS_DA/607_Data_Aq/movies/movieData.csv' 
INTO TABLE moviedata
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/*Create a audiances table for audiance data*/
CREATE TABLE audiances 
(
  audId int(25) NOT NULL,
  audName varchar(300) NOT NULL,
  gender varchar(15) NOT NULL,
  age int(25) NOT NULL,
  
  PRIMARY KEY(audId)
);

SELECT * FROM audiances;

LOAD DATA LOCAL INFILE 'D:/CUNY_SPS_DA/607_Data_Aq/movies/audiances.csv' 
INTO TABLE audiances
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/*Create a rating table for scores and connection between moviedata 
and audiances tables by two keys - movId and audId */
CREATE TABLE rating 
(
  no int(25) NOT NULL,
  audId int(25) NOT NULL,
  movId int(25) NOT NULL,
  rate int(25) NOT NULL,
  
  PRIMARY KEY(no)
);

SELECT * FROM rating;

LOAD DATA LOCAL INFILE 'D:/CUNY_SPS_DA/607_Data_Aq/movies/rating.csv' 
INTO TABLE rating
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(no,audId, movId,@rate)
SET
rate = nullif(@rate,-1);

/*Generate a new table movieRecommend which contain all data*/ 
CREATE TABLE movieRecommend 
/*(
  no int(25) NOT NULL,
  movId int(25) NOT NULL,
  titles varchar(300) NOT NULL,
  rate int(25) NOT NULL, 
  release_date date,
  movType varchar(200) NOT NULL,
  languages varchar(100) NOT NULL,
  length time,
  audId int(25) NOT NULL,
  audName varchar(300) NOT NULL,
  gender varchar(15) NOT NULL,
  age int(25) NOT NULL
) */AS
SELECT r.no, r.movId, m.titles, r.rate, m.release_date, m.movType, m.languages,m.length,r.audId,a.audName, a.gender, a.age
FROM rating r
INNER JOIN (moviedata m, audiances a)
ON (r.movId = m.movId AND r.audId = a.audId);


/*Export the full data set - movieRecommend as CSV file*/
/*Show all hided file  */
SHOW VARIABLES LIKE 'secure_file_priv';
 
/*Export movieRecommend table and store at C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads  */
SELECT *
INTO outfile'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\movieRecommend.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
FROM movieRecommend;

/*Check the output file - movieRecommend */ 
SHOW CREATE TABLE `movieRecommend`;

SELECT COUNT(*) FROM movieRecommend;

