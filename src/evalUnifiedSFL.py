import pandas as pd
import re
import os

def read_eval(bug_report_path):

    ranking = pd.read_csv(bug_report_path, delimiter=';')

    # 1. find position of the real bug is :D
    buggy_line = 0

    # Open and read the contents of a text file line by line
    f = open(os.path.join(current_dir, '..', 'workdir', 'Lang-5b', 'faults', 'failing_tests'))
    # f = open('/home/angela/CS453/ASTProject_SBFL/workdir/Lang-5b/failing_tests', 'r')
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

    return accuracy

def compare_splits(accuracies, no_of_splits):
    original = accuracies[0]
    if no_of_splits == 3:
        # Take the last 3 splits and find their average
        total = 0
        for k,v in accuracies.items():
            if k == 0:
                continue
            else:
                total += v

    average = total / no_of_splits
    if original > average:
        print('Non-splitted is more accurate')
    else:
        print('Splitting is more accurate')

    print(original, average)
    return original, average

# Get the current working directory
current_dir = os.getcwd()

# Pre split Lang-5b
BUG_REPORT_PATH = os.path.join(current_dir, '..', 'workdir', 'Lang-5b', 'sfl', 'txt', 'ochiai.ranking.csv')
BUG_ID = 5
accuracies = {}
project_name = 'Lang-5b'

accuracy= read_eval(BUG_REPORT_PATH)
accuracies[0] = accuracy


# Post split Lang-5b
for i in range(1,4):
    BUG_REPORT_PATH = os.path.join(current_dir, '..', 'workdir', 'Lang-5b', f'report_part{i}', 'sfl', 'txt', 'ochiai.ranking.csv')
    accuracy= read_eval(BUG_REPORT_PATH)
    accuracies[i] = accuracy

print(accuracies)

original_lang5b, splitted_lang5b = compare_splits(accuracies, 3)


