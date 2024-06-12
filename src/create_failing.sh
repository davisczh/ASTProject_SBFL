#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Return the exit status of the last command in the pipe that failed

source ./build.sh

# Set the project ID and bug ID
PID="Lang"
BID="5"

# Set the working directory
work_dir="/workdir"

# Checkout the buggy version of the project
cd "$work_dir"
"$D4J_HOME/framework/bin/defects4j" checkout -p "$PID" -v "${BID}b" -w "$work_dir/$PID-${BID}b/faults"

# Compile the project
cd "$work_dir/$PID-${BID}b/faults"
"$D4J_HOME/framework/bin/defects4j" compile

# Run the tests and save the output
"$D4J_HOME/framework/bin/defects4j" test
