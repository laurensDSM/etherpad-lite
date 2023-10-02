#!/bin/bash

# Input JSON file
input_file="trufflehog_results.json"

# Output HTML file (changed to "trufflehog_results.html")
output_file="trufflehog_results.html"

# Check if the input JSON file exists
if [ ! -f "$input_file" ]; then
    echo "Input JSON file '$input_file' not found."
    exit 1
fi

# Initialize the HTML content with a table and set the title
html_content="<html><head><title>Trufflehog report</title></head><body><h1>Trufflehog Report</h1><table border='1'><tr>"

# Read the first line (JSON object) from the input file to extract column headers
if [ -n "$(cat "$input_file")" ]; then
    first_line=$(head -n 1 "$input_file")
    column_headers=$(jq -r 'keys_unsorted[]' <<< "$first_line")

    # Create table headers from the column headers
    for header in $column_headers; do
        html_content+="<th>$header</th>"
    done

    html_content+="</tr>"
fi

# Read each line (JSON object) from the input file and convert it to an HTML table row
while IFS= read -r json_object; do
    table_row="<tr>"
    for key in $column_headers; do
        value=$(jq -r ".$key" <<< "$json_object")
        table_row+="<td>$value</td>"
    done
    table_row+="</tr>"
    html_content+="$table_row"
done < "$input_file"

# Close the HTML table and body
html_content+="</table></body></html>"

# Save the final HTML content to the output file ("trufflehog_results.html")
echo "$html_content" > "$output_file"

echo "Conversion completed. HTML table file saved as '$output_file'."