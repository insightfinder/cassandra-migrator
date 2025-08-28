. ./setup.sh

for ((i=0; i<$CASSANDRA_TABLES_LENGTH; i++)); do
    TABLE_NAME=$($YQ_CMD eval ".cassandra.tables[$i]" "./config.yaml")
    echo "Processing table: $TABLE_NAME"

    # Create folders
    TABLE_FOLDER="$DATA_PATH/$TABLE_NAME"
    mkdir -p "$TABLE_FOLDER"

    eval "$DSBULK_CMD unload -h $CASSANDRA_HOST -port $CASSANDRA_PORT -k $CASSANDRA_KEYSPACE -t $TABLE_NAME -url $TABLE_FOLDER -header true -maxConcurrentQueries 10 -cl ONE --log.checkpoint.enabled false --connector.csv.maxCharsPerColumn -1"
done