#!/bin/bash

# Input en output bestandsnamen
input_file="nuclei.txt"
output_file="nuclei1.html"

# HTML-header
echo "<html><head><title>Scanning Results</title></head><body style='font-family: Arial, sans-serif;'><h1>Scanning Resultaten</h1><table border='1' style='width: 100%; border-collapse: collapse;'><thead><tr style='background-color: #f2f2f2;'><th style='padding: 10px; text-align: left;'>Wat</th><th style='padding: 10px; text-align: left;'>Protocol</th><th style='padding: 10px; text-align: left;'>URL</th></tr></thead><tbody>" > "$output_file"

# Lees het input bestand regel voor regel
while IFS= read -r line; do
  # Zoek naar lijnen met [info]
  if [[ $line == *"[info]"* ]]; then
    # Verwijder [info] en eventuele leidende en volgende spaties
    info_text=$(echo "$line" | sed 's/\[info\]//;s/^[[:space:]]*//;s/[[:space:]]*$//')
    # Splits de info_text op in drie delen: Wat, Protocol en URL
    IFS=' ' read -r wat protocol url <<< "$info_text"
    # Voeg de informatie toe aan de HTML-tabel
    echo "<tr><td style='padding: 5px;'>$wat</td><td style='padding: 5px;'>$protocol</td><td style='padding: 5px;'><a href='$url' target='_blank'>$url</a></td></tr>" >> "$output_file"
  fi
done < "$input_file"

# HTML-footer
echo "</tbody></table></body></html>" >> "$output_file"

echo "HTML-bestand is aangemaakt als $output_file"
