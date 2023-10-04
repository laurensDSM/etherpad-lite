#!/bin/bash

# Bestandsnaam voor de HTML-uitvoer
output_file="nuclei.html"

# Begin van HTML
echo "<html>"
echo "<head>"
echo "<title>Scan Resultaten</title>"
echo "</head>"
echo "<body>"
echo "<h1>Scan Resultaten</h1>"

# Lees de gegevens uit nuclei.txt en genereer HTML
while IFS= read -r line
do
  echo "<div>"
  echo "<strong>$line</strong>"
  echo "</div>"
done < "nuclei.txt"

# Einde van HTML
echo "</body>"
echo "</html>"

# Uitvoer naar HTML-bestand
# Verwijder het bestand als het al bestaat om het opnieuw te genereren
rm -f "$output_file"
while IFS= read -r line
do
  echo "$line" >> "$output_file"
done <<< "$html_output"

echo "HTML-uitvoer is opgeslagen in $output_file"
