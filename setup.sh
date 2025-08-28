#!/bin/bash

export YQ_CMD=""
export DSBULK_CMD=""

# Check java installation
if ! command -v java &> /dev/null; then
    echo "Java could not be found. Please install Java and try again."
    exit 1
fi

# Check yq installation
if ! command -v yq &> /dev/null; then
    if [ ! -f "./tools/yq/yq" ]; then
        mkdir -p ./tools/yq
        curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o ./tools/yq/yq
        chmod +x ./tools/yq/yq
        echo "yq has been installed successfully!"
    fi
    YQ_CMD="./tools/yq/yq"
else
    YQ_CMD="yq"
fi


# Check dsbulk installation
if ! command -v dsbulk &> /dev/null; then

    if [ ! -f "./tools/dsbulk/dsbulk.jar" ]; then
        echo "dsbulk could not be found. Downloading."
        mkdir -p ./tools/dsbulk
        DSBULK_URL=$($YQ_CMD -r '.dsbulk.url' ./config.yaml)
        curl -L $DSBULK_URL -o ./tools/dsbulk/dsbulk.jar
        chmod +x ./tools/dsbulk/dsbulk.jar
        echo "dsbulk has been installed successfully!"
    fi
    
    DSBULK_CMD="java -jar ./tools/dsbulk/dsbulk.jar"
else
    DSBULK_CMD="dsbulk"
fi

# Get connection details from the config file
export CASSANDRA_HOST=$($YQ_CMD -r '.cassandra.host' ./config.yaml)
export CASSANDRA_PORT=$($YQ_CMD -r '.cassandra.port' ./config.yaml)
export CASSANDRA_KEYSPACE=$($YQ_CMD -r '.cassandra.keyspace' ./config.yaml)
export CASSANDRA_USERNAME=$($YQ_CMD -r '.cassandra.username' ./config.yaml)
export CASSANDRA_PASSWORD=$($YQ_CMD -r '.cassandra.password' ./config.yaml)
export CASSANDRA_TABLES_LENGTH=$($YQ_CMD -r '.cassandra.tables | length' ./config.yaml)

# Get data path
export DATA_PATH=$($YQ_CMD -r '.data.path' ./config.yaml)
if [ -z "$DATA_PATH" ]; then
    mkdir -p $DATA_PATH
    echo "Data path created at: $DATA_PATH"
fi