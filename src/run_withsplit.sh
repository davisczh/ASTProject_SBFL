#!/bin/bash
source ./build.sh

# Define project specifics
PID="Lang"
BID="5"
work_dir="/workdir"

# Checkout the project
cd "$work_dir"
"$D4J_HOME/framework/bin/defects4j" checkout -p "$PID" -v "${BID}b" -w "$PID-${BID}b"

# Compile the project
cd "$work_dir/$PID-${BID}b"
"$D4J_HOME/framework/bin/defects4j" compile

# Collect metadata
test_classpath=$($D4J_HOME/framework/bin/defects4j export -p cp.test)
src_classes_dir=$($D4J_HOME/framework/bin/defects4j export -p dir.bin.classes)
src_classes_dir="$work_dir/$PID-${BID}b/$src_classes_dir"
test_classes_dir=$($D4J_HOME/framework/bin/defects4j export -p dir.bin.tests)
test_classes_dir="$work_dir/$PID-${BID}b/$test_classes_dir"
echo "$PID-${BID}b's classpath: $test_classpath"
echo "$PID-${BID}b's bin dir: $src_classes_dir"
echo "$PID-${BID}b's test bin dir: $test_classes_dir"

# Run GZoltar and generate fault localization report
cd "$work_dir/$PID-${BID}b"
unit_tests_file="$work_dir/$PID-${BID}b/unit_tests.txt"
relevant_tests="*"

# Generate list of all test methods
java -cp "$test_classpath:$test_classes_dir:$D4J_HOME/framework/projects/lib/junit-4.11.jar:$GZOLTAR_CLI_JAR" \
  com.gzoltar.cli.Main listTestMethods \
    "$test_classes_dir" \
    --outputFile "$unit_tests_file" \
    --includes "$relevant_tests"

head "$unit_tests_file"

loaded_classes_file="$D4J_HOME/framework/projects/$PID/loaded_classes/$BID.src"
normal_classes=$(cat "$loaded_classes_file" | sed 's/$/:/' | sed ':a;N;$!ba;s/\n//g')
inner_classes=$(cat "$loaded_classes_file" | sed 's/$/$*:/' | sed ':a;N;$!ba;s/\n//g')
classes_to_debug="$normal_classes$inner_classes"

ser_file="$work_dir/$PID-${BID}b/gzoltar.ser"

cd "$work_dir/$PID-${BID}b"


java -XX:MaxPermSize=4096M -javaagent:$GZOLTAR_AGENT_JAR=destfile=$ser_file,buildlocation=$src_classes_dir,includes=$classes_to_debug,excludes="",inclnolocationclasses=false,output="FILE" \
  -cp "$src_classes_dir:$D4J_HOME/framework/projects/lib/junit-4.11.jar:$test_classpath:$GZOLTAR_CLI_JAR" \
  com.gzoltar.cli.Main runTestMethods \
    --testMethods "$unit_tests_file" \
    --collectCoverage

cd "$work_dir/$PID-${BID}b"

java -cp "$src_classes_dir:$D4J_HOME/framework/projects/lib/junit-4.11.jar:$test_classpath:$GZOLTAR_CLI_JAR" \
    com.gzoltar.cli.Main faultLocalizationReport \
      --buildLocation "$src_classes_dir" \
      --granularity "line" \
      --inclPublicMethods \
      --inclStaticConstructors \
      --inclDeprecatedMethods \
      --dataFile "$ser_file" \
      --outputDirectory "$work_dir/$PID-${BID}b" \
      --family "sfl" \
      --formula "ochiai" \
      --metric "entropy" \
# Split the test suite into 3 parts using Python
python3 /src/split_tests.py "$work_dir/$PID-${BID}b/sfl/txt/tests.csv" $unit_tests_file 3

# Loop to handle each part for fault localization
for i in {1..3}
do
  part_file="$work_dir/$PID-${BID}b/unit_tests_$i.txt"
  ser_file="$work_dir/$PID-${BID}b/gzoltar_$i.ser"

  cd "$work_dir/$PID-${BID}b"

    # Run tests with GZoltar agent for this part
    # echo "java -XX:MaxPermSize=4096M -javaagent:$GZOLTAR_AGENT_JAR=destfile=$ser_file,buildlocation=$src_classes_dir,includes=$classes_to_debug,excludes="",inclnolocationclasses=false,output="FILE" \
    #   -cp "$src_classes_dir:$D4J_HOME/framework/projects/lib/junit-4.11.jar:$test_classpath:$GZOLTAR_CLI_JAR" \
    #   com.gzoltar.cli.Main runTestMethods \
    #     --testMethods "$part_file" \
    #     --collectCoverage"
    java -XX:MaxPermSize=4096M -javaagent:$GZOLTAR_AGENT_JAR=destfile=$ser_file,buildlocation=$src_classes_dir,includes=$classes_to_debug,excludes="",inclnolocationclasses=false,output="FILE" \
      -cp "$src_classes_dir:$D4J_HOME/framework/projects/lib/junit-4.11.jar:$test_classpath:$GZOLTAR_CLI_JAR" \
      com.gzoltar.cli.Main runTestMethods \
        --testMethods "$part_file" \
        --collectCoverage
    cd "$work_dir/$PID-${BID}b"

    # # Generate SBFL report for this part
    # echo "    java -verbose:class -cp "$src_classes_dir:$D4J_HOME/framework/projects/lib/junit-4.11.jar:$test_classpath:$GZOLTAR_CLI_JAR" \
    #   com.gzoltar.cli.Main faultLocalizationReport \
    #     --buildLocation "$src_classes_dir" \
    #     --granularity "line" \
    #     --inclPublicMethods \
    #     --inclStaticConstructors \
    #     --inclDeprecatedMethods \
    #     --dataFile "$ser_file" \
    #     --outputDirectory "$work_dir/$PID-${BID}b/report_part$i" \
    #     --family "sfl" \
    #     --formula "ochiai" \
    #     --metric "entropy" \
    #     --formatter "txt""
    java -cp "$src_classes_dir:$D4J_HOME/framework/projects/lib/junit-4.11.jar:$test_classpath:$GZOLTAR_CLI_JAR" \
      com.gzoltar.cli.Main faultLocalizationReport \
        --buildLocation "$src_classes_dir" \
        --granularity "line" \
        --inclPublicMethods \
        --inclStaticConstructors \
        --inclDeprecatedMethods \
        --dataFile "$ser_file" \
        --outputDirectory "$work_dir/$PID-${BID}b/report_part$i" \
        --family "sfl" \
        --formula "ochiai" \
        --metric "entropy" \
        --formatter "txt"

done
