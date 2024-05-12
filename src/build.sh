#!/bin/bash

# Define working directory
work_dir="/workdir"
mkdir -p "$work_dir"  # Ensure work_dir exists without removing existing content

# Set Java options
export _JAVA_OPTIONS="-Xmx6144M -XX:MaxHeapSize=4096M"
export MAVEN_OPTS="-Xmx1024M"
export ANT_OPTS="-Xmx6144M -XX:MaxHeapSize=4096M"

# Get GZoltar
cd "$work_dir"
if [ ! -d "$work_dir/gzoltar" ]; then
    git clone https://github.com/GZoltar/gzoltar.git
    cd "$work_dir/gzoltar"
    mvn clean package
    export GZOLTAR_AGENT_JAR="$work_dir/gzoltar/com.gzoltar.agent.rt/target/com.gzoltar.agent.rt-1.7.4-SNAPSHOT-all.jar"
    export GZOLTAR_CLI_JAR="$work_dir/gzoltar/com.gzoltar.cli/target/com.gzoltar.cli-1.7.4-SNAPSHOT-jar-with-dependencies.jar"
else
    echo "GZoltar already cloned and built."
    export GZOLTAR_AGENT_JAR="$work_dir/gzoltar/com.gzoltar.agent.rt/target/com.gzoltar.agent.rt-1.7.4-SNAPSHOT-all.jar"
    export GZOLTAR_CLI_JAR="$work_dir/gzoltar/com.gzoltar.cli/target/com.gzoltar.cli-1.7.4-SNAPSHOT-jar-with-dependencies.jar"
fi

# Get D4J
cd "$work_dir"
if [ ! -d "$work_dir/defects4j" ]; then
    git clone https://github.com/rjust/defects4j.git
    cd "$work_dir/defects4j"
    ./init.sh
     export D4J_HOME="$work_dir/defects4j"
else
    echo "Defects4J already cloned and initialized."
    export D4J_HOME="$work_dir/defects4j"
fi
cd "$work_dir/defects4j"
cpanm --installdeps .
export TZ='America/Los_Angeles'  # Required timezone for some D4J projects
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
