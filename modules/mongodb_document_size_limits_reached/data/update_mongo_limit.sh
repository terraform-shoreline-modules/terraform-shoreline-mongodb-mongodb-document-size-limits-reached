

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