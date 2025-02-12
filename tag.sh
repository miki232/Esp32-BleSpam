#!/bin/bash

# Inizializza le variabili
version=""
declare -a tags=()

# Funzione di usage
usage() {
    echo "Usage: $0 -v VERSION -t TAG1 [TAG2 TAG3 ...]"
    echo "  -v VERSION    Specifica il numero di versione"
    echo "  -t TAG        Specifica uno o più tag da creare"
    exit 1
}

# Parsing degli argomenti
while getopts "v:t:" opt; do
    case $opt in
        v)
            version="$OPTARG"
            ;;
        t)
            # Divide la stringa del tag in un array usando lo spazio come delimitatore
            IFS=' ' read -ra tag_parts <<< "$OPTARG"
            tags+=("${tag_parts[@]}")
            # Cattura argomenti addizionali dopo -t
            while [[ $# -gt $OPTIND-1 ]]; do
                if [[ ${!OPTIND} == -* ]]; then
                    break
                fi
                tags+=("${!OPTIND}")
                ((OPTIND++))
            done
            ;;
        *)
            usage
            ;;
    esac
done

# Verifica che siano stati forniti sia versione che tag
if [ -z "$version" ] || [ ${#tags[@]} -eq 0 ]; then
    usage
fi

# Crea i tag
for tag in "${tags[@]}"; do
    tag_name="${tag}_${version}"
    echo "Creazione tag: $tag_name"
    git tag -a "$tag_name" -m "Tag creato automaticamente: $tag_name"
    git push origin "$tag_name"
done
