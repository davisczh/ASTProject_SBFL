import pandas as pd
import os
def read_eval(BUG_REPO, bug_report_path):

    ranking = pd.read_csv(bug_report_path, delimiter=';')
    buggy_line = 0

    f = open(os.path.join('/', 'workdir', BUG_REPO, 'faults', 'failing_tests'))

    line = f.readlines()
    line = line[2]
    x = line.split(':')[-1]
    buggy_line = x.split(')')[0]

    # print(buggy_line)
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

    return buggy_rank, buggy_sus




for BUG_REPO in ['Lang-5b', 'Lang-6b', 'Lang-7b']:

    BUG_REPORT_PATH = os.path.join('/', 'workdir', BUG_REPO, 'sfl', 'txt', 'ochiai.ranking.csv')
    BUG_ID = 5
    no_of_splits = 3




    accuracies = {}
    rank, sus= read_eval(BUG_REPO,BUG_REPORT_PATH)
    accuracies[0] = sus
    total_split_sus = 0
    # Post split Lang-5b
    for i in range(1, no_of_splits+1):
        path = os.path.join('/', 'workdir', BUG_REPO, f'report_part{i}', 'sfl', 'txt', 'ochiai.ranking.csv')
        rank, sus= read_eval(BUG_REPO,path)
        accuracies[i] = sus
        total_split_sus += sus

    print(accuracies)
    average_split_sus = total_split_sus / no_of_splits

    print('Original sus:', accuracies[0])
    print('Average split sus:', average_split_sus)

    if average_split_sus > accuracies[0]:
        print('Splitting finds buggy line more suspicious')
    else:
        print('Splitting does not find buggy line more suspicious')
