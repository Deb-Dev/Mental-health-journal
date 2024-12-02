#!/bin/bash

# Name of the output file
output_file="combined_swift_code.txt"

# Empty the output file if it already exists
> "$output_file"

# Loop through all .swift files in the current directory
for file in *.swift; do
    if [ -f "$file" ]; then
        echo "Processing $file"
        echo "----- Start of $file -----" >> "$output_file"
        cat "$file" >> "$output_file"
        echo -e "\n----- End of $file -----\n" >> "$output_file"
    fi
done

echo "All Swift code has been copied to $output_file"