import pandas as pd
import re
import os

# Change this to what is needed
project_names = ['Lang-5b', 'Lang-6b', 'Lang-7b']

def read_eval(bug_report_path, project_name):
    ranking = pd.read_csv(bug_report_path, delimiter=';')

    # 1. find position of the real bug is :D
    buggy_line = 0

    # Open and read the contents of a text file line by line
    f = open(os.path.join(current_dir, '..', 'workdir', project_name, 'faults', 'failing_tests'))
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

# Pre split of the library chosen
for project_name in project_names:
    BUG_REPORT_PATH = os.path.join(current_dir, '..', 'workdir', project_name, 'sfl', 'txt', 'ochiai.ranking.csv')
    accuracies = {}
    accuracy= read_eval(BUG_REPORT_PATH, project_name)
    accuracies[0] = accuracy

    # Post split
    no_of_splits = 3 # change this based on the amount of splits specified in run_withsplit.sh
    for i in range(1,no_of_splits+1):
        BUG_REPORT_PATH = os.path.join(current_dir, '..', 'workdir', project_name, f'report_part{i}', 'sfl', 'txt', 'ochiai.ranking.csv')
        accuracy= read_eval(BUG_REPORT_PATH, project_name)
        accuracies[i] = accuracy

    print(accuracies)

    original, splitted = compare_splits(accuracies, no_of_splits)


