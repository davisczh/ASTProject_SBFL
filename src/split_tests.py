import sys
import random

def extract_failing_test(csv_file):
    with open(csv_file, 'r') as file:
        lines = file.readlines()
    for line in lines:
        if "FAIL" in line:
            # Assuming the format is name,outcome,runtime,stacktrace
            return line.split(',')[0].strip()  # Extract the test name
    return None

def split_tests(test_file, parts, failing_test_name):
    with open(test_file, 'r') as file:
        lines = file.readlines()

    # If a failing test is identified, find and separate its line from the main list
    failing_test_line = None
    for line in lines:
        if failing_test_name in line:
            failing_test_line = line
            lines.remove(line)
            break

    # Shuffle the remaining test lines randomly
    random.shuffle(lines)

    # Compute part sizes excluding the failing test line
    total = len(lines)
    part_size = total // parts

    for i in range(parts):
        start = i * part_size
        end = start + part_size if i < parts - 1 else total

        part_lines = lines[start:end]
        # Include the failing test in each part
        if failing_test_line:
            part_lines.append(failing_test_line)

        with open(f"{test_file.split('.')[0]}_{i+1}.txt", 'w') as part_file:
            part_file.writelines(part_lines)

if __name__ == "__main__":
    csv_file_path = sys.argv[1]
    test_file_path = sys.argv[2]
    parts = int(sys.argv[3])

    # Extract failing test name from the CSV
    failing_test_name = extract_failing_test(csv_file_path)
    if failing_test_name:
        split_tests(test_file_path, parts, failing_test_name)
    else:
        print("No failing test found in CSV.")
