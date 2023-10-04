#!/bin/bash

# Open het uitvoerbestand voor HTML
echo "<html>" > nuclei2.html
echo "<head>" >> nuclei2.html
echo "<title>Nuclei JSON to HTML</title>" >> nuclei2.html
echo "</head>" >> nuclei2.html
echo "<body>" >> nuclei2.html
echo "<table border='1'>" >> nuclei2.html

# Verwijder eventuele lege regels in het bestand
grep -v '^$' nuclei_json.txt > temp.txt

# Lees het tijdelijke bestand regel voor regel
while IFS= read -r line
do
  # Decodeer de JSON-array en formatteer deze als HTML
  formatted_line=$(echo "$line" | jq -r '. | to_entries | map("<td>\(.value)</td>") | join("")')

  # Als de koppen nog niet zijn gemaakt, maak ze dan
  if [ -z "$header_created" ]; then
    header_line=$(echo "$line" | jq -r '. | to_entries | map("<th>\(.key)</th>") | join("")')
    echo "<tr>$header_line</tr>" >> nuclei2.html
    header_created=true
  fi

  # Maak een rij in de HTML-tabel voor de huidige JSON-array
  echo "<tr>$formatted_line</tr>" >> nuclei2.html
done < temp.txt

# Sluit de HTML-tabel en het HTML-bestand
echo "</table>" >> nuclei2.html
echo "</body>" >> nuclei2.html
echo "</html>" >> nuclei2.html

# Verwijder het tijdelijke bestand
rm temp.txt

# Melding dat het HTML-bestand is gegenereerd
echo "HTML-bestand 'nuclei2.html' is gegenereerd."
