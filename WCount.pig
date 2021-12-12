data = LOAD '/home/pavan-linux/WordCount/HadoopInfo' as (line);
words = FOREACH data GENERATE FLATTEN(TOKENIZE(line)) as word;
grp = GROUP words by word;
wordcounts = FOREACH grp GENERATE COUNT(words), group;
dump wordcounts;
