# project details
PID="Lang"
BID="5"
work_dir="/workdir"

# Checkout the project
cd "$work_dir"
"$D4J_HOME/framework/bin/defects4j" checkout -p "$PID" -v "${BID}b" -w "$PID-${BID}b"

# Compile the project
cd "$work_dir/$PID-${BID}b"
"$D4J_HOME/framework/bin/defects4j" compile

# Test the project
"$D4J_HOME/framework/bin/defects4j" test