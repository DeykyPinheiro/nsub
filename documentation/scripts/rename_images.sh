#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGES_DIR="$ROOT_DIR/images"
DATE=$(date +"%Y_%m_%d")

# === Escolher categoria ===
echo "📁 Categorias disponíveis:"
mapfile -t categories < <(find "$ROOT_DIR" -maxdepth 1 -mindepth 1 -type d ! -name "images" ! -name "scripts" -exec basename {} \; | sort)
select category in "${categories[@]}"; do
  if [[ -n "${category:-}" ]]; then
    echo "👉 Categoria selecionada: $category"
    break
  fi
done

CATEGORY_DIR="$ROOT_DIR/$category"

# === Escolher arquivo .md ===
echo
echo "📄 Arquivos Markdown disponíveis:"
mapfile -t md_files < <(find "$CATEGORY_DIR" -maxdepth 1 -type f -name "*.md" -exec basename {} \; | sort)
select md_file in "${md_files[@]}"; do
  if [[ -n "${md_file:-}" ]]; then
    echo "👉 Arquivo selecionado: $md_file"
    break
  fi
done

MD_REF=$(basename "$md_file" .md)
# Remove o prefixo de data se houver (ex: 2025-11-05-)
MD_REF=$(echo "$MD_REF" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//')
MD_REF=$(echo "$MD_REF" | sed -E 's/[^a-zA-Z0-9_]/_/g') # segurança extra

echo
echo "📦 Preparando para renomear imagens..."
echo "Categoria: $category"
echo "Referência: $MD_REF"
echo "Data: $DATE"
echo

# === Determinar sequência inicial por categoria+md_ref+data ===
mapfile -t existing_files < <(ls "$IMAGES_DIR" 2>/dev/null || true)
max_num=0
for f in "${existing_files[@]}"; do
  if [[ $f =~ ^${category}_${MD_REF}_${DATE}_([0-9]{3})\.[^.]+$ ]]; then
    num=$((10#${BASH_REMATCH[1]}))
    (( num > max_num )) && max_num=$num
  fi
done
count=$((max_num + 1))

# === Processar imagens novas ===
shopt -s nullglob
for file in "$IMAGES_DIR"/*; do
  [ -f "$file" ] || continue

  filename=$(basename "$file")

  # Ignora arquivos que já seguem o padrão completo
  if [[ $filename =~ ^[a-zA-Z0-9_-]+_[a-zA-Z0-9_-]+_[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{3}\.[^.]+$ ]]; then
    echo "↪️  Ignorando (já padronizada): $filename"
    continue
  fi

  ext="${filename##*.}"
  clean_name=$(echo "$filename" | sed -e 's/ /_/g')

  new_name="${category}_${MD_REF}_${DATE}_$(printf "%03d" $count).${ext}"

  # Evita sobrescrever qualquer arquivo existente
  while [[ -f "$IMAGES_DIR/$new_name" ]]; do
    count=$((count + 1))
    new_name="${category}_${MD_REF}_${DATE}_$(printf "%03d" $count).${ext}"
  done

  echo "🖼️  Renomeando: $filename  →  $new_name"
  mv -v "$file" "$IMAGES_DIR/$new_name"
  count=$((count + 1))
done
shopt -u nullglob

echo
echo "✅ Renomeação concluída!"

# how to run
# chmod +x documentation/scripts/rename_images.sh
# ./documentation//scripts/rename_images.sh
