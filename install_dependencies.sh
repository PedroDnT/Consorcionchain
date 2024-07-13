#!/bin/bash

# Install npm dependencies
npm run install-all

# Check if the installation was successful
if [ $? -eq 0 ]; then
    echo "All dependencies installed successfully!"
else
    echo "Error occurred during installation. Please check the output above for details."
    exit 1
fi
