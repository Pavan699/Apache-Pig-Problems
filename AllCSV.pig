--Extracting required columns from the given logfile
data = load '/home/pavan-linux/CPU-Logs/CpuLogData2019-09-16.csv' using PigStorage(',');
data16= foreach data generate $39 as boot:chararray,$40 as mail:chararray,$41 as keyboard:int;

data = load '/home/pavan-linux/CPU-Logs/CpuLogData2019-09-17.csv' using PigStorage(',');
data17= foreach data generate $39 as boot:chararray,$40 as mail:chararray,$41 as keyboard:int;

data = load '/home/pavan-linux/CPU-Logs/CpuLogData2019-09-18.csv' using PigStorage(',');
data18= foreach data generate $39 as boot:chararray,$40 as mail:chararray,$41 as keyboard:int;

data = load '/home/pavan-linux/CPU-Logs/CpuLogData2019-09-19.csv' using PigStorage(',');
data19= foreach data generate $39 as boot:chararray,$40 as mail:chararray,$41 as keyboard:int;

data = load '/home/pavan-linux/CPU-Logs/CpuLogData2019-09-20.csv' using PigStorage(',');
data20= foreach data generate $39 as boot:chararray,$40 as mail:chararray,$41 as keyboard:int;

data = load '/home/pavan-linux/CPU-Logs/CpuLogData2019-09-21.csv' using PigStorage(',');
data21= foreach data generate $39 as boot:chararray,$40 as mail:chararray,$41 as keyboard:int;


--Getting out Unique Users
grpd16 = group data16 by mail;
unique = foreach grpd16 generate group;
store unique into 'Unique16';

grpd17 = group data17 by mail;
unique = foreach grpd17 generate group;
store unique into 'Unique17';

grpd18 = group data18 by mail;
unique = foreach grpd18 generate group;
store unique into 'Unique18';

grpd19 = group data19 by mail;
unique = foreach grpd19 generate group;
store unique into 'Unique19';

grpd20 = group data20 by mail;
unique = foreach grpd20 generate group;
store unique into 'Unique20';

grpd21 = group data21 by mail;
unique = foreach grpd21 generate group;
store unique into 'Unique21';


--Getting Categorized data for every day
count = foreach grpd16 generate group,COUNT(data16);
idel = filter data16 by keyboard == 0;
grpdidel = group idel by mail;
countidel = foreach grpdidel generate group,COUNT(idel);
full_join = join count by $0 FULL OUTER, countidel by $0;
out = foreach full_join generate $0,($1-$3);
full_join2 = join full_join by $0 FULL OUTER, out by $0;
detailed16 = foreach full_join2 generate $0,$1*5,$3*5,$5*5;

count = foreach grpd17 generate group,COUNT(data17);
idel = filter data17 by keyboard == 0;
grpdidel = group idel by mail;
countidel = foreach grpdidel generate group,COUNT(idel);
full_join = join count by $0 FULL OUTER, countidel by $0;
out = foreach full_join generate $0,($1-$3);
full_join2 = join full_join by $0 FULL OUTER, out by $0;
detailed17 = foreach full_join2 generate $0,$1*5,$3*5,$5*5;

count = foreach grpd18 generate group,COUNT(data18);
idel = filter data18 by keyboard == 0;
grpdidel = group idel by mail;
countidel = foreach grpdidel generate group,COUNT(idel);
full_join = join count by $0 FULL OUTER, countidel by $0;
out = foreach full_join generate $0,($1-$3);
full_join2 = join full_join by $0 FULL OUTER, out by $0;
detailed18 = foreach full_join2 generate $0,$1*5,$3*5,$5*5;

count = foreach grpd19 generate group,COUNT(data19);
idel = filter data19 by keyboard == 0;
grpdidel = group idel by mail;
countidel = foreach grpdidel generate group,COUNT(idel);
full_join = join count by $0 FULL OUTER, countidel by $0;
out = foreach full_join generate $0,($1-$3);
full_join2 = join full_join by $0 FULL OUTER, out by $0;
detailed19 = foreach full_join2 generate $0,$1*5,$3*5,$5*5;

count = foreach grpd20 generate group,COUNT(data20);
idel = filter data20 by keyboard == 0;
grpdidel = group idel by mail;
countidel = foreach grpdidel generate group,COUNT(idel);
full_join = join count by $0 FULL OUTER, countidel by $0;
out = foreach full_join generate $0,($1-$3);
full_join2 = join full_join by $0 FULL OUTER, out by $0;
detailed20 = foreach full_join2 generate $0,$1*5,$3*5,$5*5;

count = foreach grpd21 generate group,COUNT(data21);
idel = filter data21 by keyboard == 0;
grpdidel = group idel by mail;
countidel = foreach grpdidel generate group,COUNT(idel);
full_join = join count by $0 FULL OUTER, countidel by $0;
out = foreach full_join generate $0,($1-$3);
full_join2 = join full_join by $0 FULL OUTER, out by $0;
detailed21 = foreach full_join2 generate $0,$1*5,$3*5,$5*5;


--Getting Average Data for Six Days

data_all = UNION detailed16, detailed17, detailed18, detailed19, detailed20, detailed21;
A = group data_all by $0;
B = foreach A generate group,COUNT(data_all);
J = join A by $0, B by $0;
C = foreach J generate A::group,SUM(data_all.$1),$3;
D = foreach J generate A::group,SUM(data_all.$2),$3;
E = foreach J generate A::group,SUM(data_all.$3),$3;
avg_total = foreach C generate $0 as mail,$1/$2/60 as avg;
avg_idel = foreach D generate $0 as mail,$1/$2/60 as avg;
avg_working = foreach E generate $0 as mail,$1/$2/60 as avg;

--Main Output 

A = ORDER avg_working BY avg ASC;
B = ORDER avg_working BY avg DESC;
C = ORDER avg_idel BY avg DESC;
low_working = LIMIT A 1;
high_working = LIMIT B 1;
high_idel = LIMIT C 1;
store low_working into '/home/pavan-linux/CPU-Logs/output/low_working';
store high_working into '/home/pavan-linux/CPU-Logs/output/high_working';
store high_idel into '/home/pavan-linux/CPU-Logs/output/high_idel';

