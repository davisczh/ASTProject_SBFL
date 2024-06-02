import pandas as pd
import re

BUG_REPORT_PATH = '/home/angela/CS453/ASTProject_SBFL/workdir/Lang-5b/sfl/txt/ochiai.ranking.csv'
BUG_ID = 5

ranking = pd.read_csv(BUG_REPORT_PATH, delimiter=';')

# 1. find position of the real bug is :D
buggy_line = 0

# Open and read the contents of a text file line by line
f = open('/home/angela/CS453/ASTProject_SBFL/workdir/Lang-5b/failing_tests', 'r')
# search for buggy line
line = f.readlines()
line = line[2]
x = line.split(':')[-1]
buggy_line = x.split(')')[0]


rank = 1
previous = 0
for index, row in ranking.iterrows():
    line = row['name'].split(':')[1]
    ranking.at[index, 'name'] = line
    if rank == 1:
        if index == 0:
            previous = row['suspiciousness_value']

    if row['suspiciousness_value'] != previous:
        rank += 1
    ranking.at[index, 'rank'] = rank
    previous = row['suspiciousness_value']

print(ranking)

buggy_rank = float(ranking.loc[ranking['name'].str.contains(buggy_line), 'rank'].values[0])
buggy_sus = float(ranking.loc[ranking['name'].str.contains(buggy_line), 'suspiciousness_value'].values[0])
accuracy = buggy_sus/buggy_rank

print(accuracy)
