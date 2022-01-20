--Extracting required columns from the given logfile
data = load '/home/pavan-linux/CPU-Logs/CpuLogData2019-09-16.csv' using PigStorage(',');
data16= foreach data generate $39 as boot:chararray,$40 as mail:chararray,$41 as keyboard:float;

--Getting out Unique Users
grpd16 = group data16 by mail;
unique = foreach grpd16 generate group;
store unique into '/home/pavan-linux/CPU-Logs/output/Unique16';

--Getting Categorised data for every day
count = foreach grpd16 generate group,COUNT(data16);
idel = filter data16 by keyboard == 0;
grpdidel = group idel by mail;
countidel = foreach grpdidel generate group,COUNT(idel);
full_join = join count by $0 FULL OUTER, countidel by $0;
out = foreach full_join generate $0,($1-$3);
full_join2 = join full_join by $0 FULL OUTER, out by $0;
detailed16 = foreach full_join2 generate $0 as mail:chararray,$1*5 as total:float,$3*5 as idel:float,$5*5 as working:float;

--Getting Average Data for that Days
avg_total = foreach detailed16 generate $0 as mail,total/60 as avg;
avg_idel = foreach detailed16 generate $0 as mail,idel/60 as avg;
avg_working = foreach detailed16 generate $0 as mail,working/60 as avg;

--Main Output(Lowest hours,Highest hours,ideal hour user) 
A = ORDER avg_working BY avg ASC; --for lowest we setting order as ascending order
B = ORDER avg_working BY avg DESC; --for highest we setting order as descending order
C = ORDER avg_idel BY avg DESC;
low_working = LIMIT A 1; -- getting only one user from the users list using limit
high_working = LIMIT B 1;
high_idel = LIMIT C 1;
store low_working into '/home/pavan-linux/CPU-Logs/output/low_working';
store high_working into '/home/pavan-linux/CPU-Logs/output/high_working';
store high_idel into '/home/pavan-linux/CPU-Logs/output/high_idel';

