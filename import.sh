. ./setup.sh

echo "Please remember to create the tables before importing data using this tool!"
read -p "Press enter to continue"

for ((i=0; i<$CASSANDRA_TABLES_LENGTH; i++)); do
    TABLE_NAME=$($YQ_CMD eval ".cassandra.tables[$i]" "./config.yaml")
    echo "Processing table: $TABLE_NAME"

    # Define table folder path
    TABLE_FOLDER="$DATA_PATH/$TABLE_NAME"

    eval "$DSBULK_CMD load -h $CASSANDRA_HOST -port $CASSANDRA_PORT -u ${CASSANDRA_USERNAME} -p ${CASSANDRA_PASSWORD} -k $CASSANDRA_KEYSPACE -t $TABLE_NAME -url $TABLE_FOLDER -header true -maxConcurrentQueries 10 -cl ONE --log.checkpoint.enabled false --connector.csv.maxCharsPerColumn -1"
done
