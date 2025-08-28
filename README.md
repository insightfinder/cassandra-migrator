# Cassandra Migrator

A simple tool for exporting and importing data from Apache Cassandra databases using DataStax Bulk Loader (dsbulk).

## Overview

This tool provides an easy way to:
- Export data from Cassandra tables to CSV files
- Import data from CSV files back to Cassandra tables
- Automatically handle tool dependencies (yq and dsbulk)
- Support multiple tables through configuration

## Prerequisites

- Java (required for dsbulk)
- Bash shell
- Internet connection (for downloading dependencies)

## Setup

1. Clone or download this project
2. Configure your connection details in `config.yaml`
3. Run the export or import scripts

The setup script will automatically download required tools if they're not already installed:
- **yq**: YAML processor for reading configuration
- **dsbulk**: DataStax Bulk Loader for data operations

## Configuration

Edit the `config.yaml` file to match your Cassandra setup:

```yaml
dsbulk:
  url: https://github.com/datastax/dsbulk/releases/download/1.11.0/dsbulk-1.11.0.jar

cassandra:
  host: localhost
  port: 9042
  keyspace: your_keyspace
  username: cassandra
  password: cassandra
  tables:
    - table1
    - table2
    - table3

data:
  path: ./data
```

### Configuration Options

- **dsbulk.url**: URL to download dsbulk JAR file
- **cassandra.host**: Cassandra host address
- **cassandra.port**: Cassandra port (default: 9042)
- **cassandra.keyspace**: Target keyspace name
- **cassandra.username**: Authentication username
- **cassandra.password**: Authentication password
- **cassandra.tables**: List of tables to export/import
- **data.path**: Local directory for storing exported data

## Usage

### Exporting Data

Export all configured tables to CSV files:

```bash
./export.sh
```

This will:
- Create a folder for each table under the configured data path
- Export each table's data to CSV format with headers
- Use consistency level ONE for better performance

### Importing Data

Import data from CSV files back to Cassandra:

```bash
./import.sh
```

**Important**: Make sure the target tables exist in Cassandra before importing. The tool will prompt you to confirm this before proceeding.

## Data Structure

Exported data is organized as follows:
```
data/
├── table1/
│   └── part-00001.csv
├── table2/
│   └── part-00001.csv
└── table3/
    └── part-00001.csv
```

Each table gets its own directory containing CSV files with the exported data.

## Features

- **Automatic dependency management**: Downloads yq and dsbulk if not available
- **Configurable concurrency**: Uses 10 concurrent queries by default
- **Header support**: CSV files include column headers
- **Unlimited column size**: No character limits on CSV columns
- **Checkpoint disabled**: Faster operations without checkpoint logging

## Troubleshooting

### Java Not Found
Make sure Java is installed and available in your PATH:
```bash
java -version
```

### Connection Issues
- Verify Cassandra is running and accessible
- Check host, port, and authentication credentials
- Ensure the keyspace exists

### Table Not Found
- Confirm table names in config.yaml match exactly (case-sensitive)
- Verify tables exist in the specified keyspace

### Permission Issues
- Ensure the user has read permissions for export operations
- Ensure the user has write permissions for import operations

## Performance Tuning

You can modify the dsbulk parameters in the scripts for better performance:
- Adjust `-maxConcurrentQueries` (default: 10)
- Change consistency level with `-cl` (default: ONE)
- Modify other dsbulk options as needed

## Dependencies

This tool automatically manages the following dependencies:
- [yq](https://github.com/mikefarah/yq) - YAML processor
- [dsbulk](https://github.com/datastax/dsbulk) - DataStax Bulk Loader

Dependencies are downloaded to the `./tools/` directory and reused for subsequent runs.
