#!/bin/bash
echo "remove space in files..."

for file in *" "*; do
    [ -f "$file" ] || continue
    novo=$(echo "$file" | sed -e 's/ /_/g')
    mv -v "$file" "$novo"
done

echo "ready, space substitutle for _"

# how to run
# chmod +x remove_space_in_name_images.sh
# ./remove_space_in_name_images.sh