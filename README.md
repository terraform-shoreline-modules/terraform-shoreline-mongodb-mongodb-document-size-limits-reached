
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB document size limits reached.
---

This incident type relates to the situation where the limit of the document size in a MongoDB database has been exceeded. MongoDB is a type of NoSQL database that stores data in a document format, and each document has a defined size limit. When this limit is reached, it can cause issues with data storage and retrieval, potentially leading to system downtime or data loss.

### Parameters
```shell
export DATABASE_NAME="PLACEHOLDER"

export COLLECTION_NAME="PLACEHOLDER"

export MAX_SIZE="PLACEHOLDER"

export MONGODB_CONF_FILE="PLACEHOLDER"

export NEW_LIMIT="PLACEHOLDER"
```

## Debug

### 1. Check the current size of the MongoDB document
```shell
mongo ${DATABASE_NAME} --eval "db.${COLLECTION_NAME}.stats().size"
```

### 2. Check the maximum document size for the MongoDB version being used
```shell
mongo ${DATABASE_NAME} --eval "db.${COLLECTION_NAME}.getMongo().getDB('admin').runCommand({getParameter: 1, maxBsonObjectSize: 1})"
```

### 3. Check the size of the largest document in the MongoDB collection
```shell
mongo ${DATABASE_NAME} --eval "db.${COLLECTION_NAME}.find().sort({$natural:-1}).limit(1).explain().executionStats.allPlansExecution[0].winningPlan"
```

### 4. Check for any indexes that may be causing the document size limit to be reached
```shell
mongo ${DATABASE_NAME} --eval "db.${COLLECTION_NAME}.getIndexes()"
```

### 5. Check for any documents that may be exceeding the size limit
```shell
mongo ${DATABASE_NAME} --eval "db.${COLLECTION_NAME}.find({$where: 'Object.bsonsize(this) >= ${MAX_SIZE}'})"
```

### 6. Check for any MongoDB configuration settings that may be impacting the document size limit
```shell
cat /etc/mongod.conf
```

## Repair

### Increase the document size limit in MongoDB configuration.
```shell


#!/bin/bash



# Set the variables

DB_NAME=${DATABASE_NAME}

CONF_FILE=${MONGODB_CONF_FILE}

NEW_LIMIT=${NEW_LIMIT}



# Stop the MongoDB service

sudo service mongod stop



# Update the configuration file with the new limit

sudo sed -i "s/\(documentSizeLimitGB\s*=\s*\).*\$/\1$NEW_LIMIT/" $CONF_FILE



# Start the MongoDB service

sudo service mongod start


```