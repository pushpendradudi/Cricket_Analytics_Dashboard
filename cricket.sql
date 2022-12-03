create database cricekt;
use cricket ;
/* uploaded dataset of three tables as batsman_data , bowler_data , match_result in different tables on snowflake*/

select * from batsman_data;
/* dropping irrelevant columns from batsman_data table and removing null values from batsman_score column */
alter table batsman_data  drop col1;
alter table batsman_data drop strike_rate;
delete from batsman_data where BATSMAN_SCORE in ('DNB','TDNB','sub','absent');

/* writing cte(common table expression) to add new columns and to correct the format of existing columns */

with batsman_new as (select * ,case
when BATSMAN_SCORE like '%*' then 'Not Out'
When BATSMAN_SCORE not like '%*' then 'Out'
end as Out_or_NotOut,
substr(opposition_team,3,length(opposition_team)) as team_OPPOSITION,
case 
when length(year(match_date))=1 then concat(200 , year(match_date))
when length(year(match_date))=2 and year(match_date)!=99 then concat(20 , year(match_date))
when year(match_date) =99 then concat(19 , year(match_date)) 
end as match_year from batsman_data)
select * from batsman_new ;
describe table batsman_data;



select * from bowler_data;
/* dropping irrelevant columns from bowler_data table and removing null values from bowler_data column */

alter table bowler_data drop col2;
delete from bowler_data where overs like '-' ;
alter table bowler_data drop average,strike_rate,economy;

/* writing cte(common table expression) to add new columns and to correct the format of existing columns */
WITH bowler_new as (select * ,substr(opposition,3,length(opposition)) as OPPOSITION_TEAM ,
SUBSTR(MATCH_DATE,-4,LENGTH(MATCH_DATE)) as year  from bowler_data) 
select * from bowler_new;


select * from match_result;

/* dropping irrelevant columns from bowler_data table and removing null values from match_result column */
alter table match_result drop col3 , br;
delete from match_result where result not in ('won','lost','n/r','tied');

/* writing cte(common table expression) to add new columns and to correct the format of existing columns */
select * , SUBSTR(start_date,-4,LENGTH(start_DATE)) as match_year,
substr(opposition_team,3,length(opposition_team)) as team_OPPOSITION
from match_result;