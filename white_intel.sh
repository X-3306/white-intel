#!/bin/bash

# Funkcja wyświetlająca logo
display_logo() {
  echo " __        __            _"
  echo " \ \      / /__  __ _ __| |_"
  echo "  \ \ /\ / / _ \/ _\` |/ _\` |"
  echo "   \ V  V /  __/ (_| | (_| |"
  echo "    \_/\_/ \___|\__,_|\__,_|"
  echo "     Biały Wywiad v1.0"
}

# Funkcja wyświetlająca pomoc
display_help() {
  echo "Użycie: ./white_intel.sh [opcje] [domena]"
  echo
  echo "Opcje:"
  echo "  -h, --help    Wyświetla pomoc"
  echo "  -d, --dns     Sprawdź rekordy DNS"
  echo "  -w, --whois   Pobierz informacje Whois"
  echo
  echo "Przykład:"
  echo "  ./white_intel.sh -d -w example.com"
}

# Sprawdź, czy podano argumenty
if [ $# -eq 0 ]; then
  display_logo
  display_help
  exit 1
fi

# Zainicjuj opcje
GET_DNS=false
GET_WHOIS=false

# Przetwarzaj argumenty
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      display_help
      exit 0
      ;;
    -d|--dns)
      GET_DNS=true
      shift
      ;;
    -w|--whois)
      GET_WHOIS=true
      shift
      ;;
    *)
      DOMAIN="$1"
      shift
      ;;
  esac
done

# Wyświetl logo
display_logo

# Sprawdź, czy podano domenę
if [ -z "$DOMAIN" ]; then
  echo "Błąd: Nie podano domeny"
  exit 1
fi

# Wykonaj zapytania
if $GET_DNS; then
  echo "Sprawdzanie rekordów DNS:"
  dig +short A "$DOMAIN"
  echo
fi

if $GET_WHOIS; then
  echo "Pobieranie informacji Whois:"
  whois "$DOMAIN"
  echo
fi

exit 0
