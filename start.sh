#!/bin/sh

# Check if the .env file exists.
if [ -f .env ]; then
  # Read each line, filter out comments (#) and empty lines, and export it.
  # The `xargs` command handles potential spaces in values.
  export $(grep -v '^#' .env | xargs)
else
  echo "Error: .env file not found."
  exit 1
fi

# Run your Dart Frog development server
dart_frog dev