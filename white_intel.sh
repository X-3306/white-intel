#!/bin/bash

# Function to display logo
display_logo() {
echo "
       .---.
       |---|
       |---|
       |---|
   .---^ - ^---.
   :___________:
      |  |//|
      |  |//|
      |  |//|
      |  |//|
      |  |//|
      |  |//|
      |  |.-|
      |.-'**|
       \***/
        \*/
         V
 Biały Wywiad v1.0"
}

# unkcja wyświetlająca pomoc
display_help() {
echo "Użycie: ./white_intel.sh [opcje] [domena]"
echo
echo "Opcje:"
echo " -h, --help Wyświetla pomoc"
echo " -d, --dns Sprawdź rekordy DNS"
echo " -w, --whois Pobierz informacje Whois"
echo " -i, --ip Sprawdź adres IP"
echo " -s, --subdomains Szukaj poddomen"
echo
echo "Przykład:"
echo " ./white_intel.sh -d -w example.com"
echo
}

# Sprawdź, czy podano argumenty
if [ $# -eq 0 ]; then
display_logo
display_help
exit 1
fi

#Zainicjuj opcje
GET_DNS=false
GET_WHOIS=false
GET_IP=false
GET_SUBDOMAINS=false

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
-i|--ip)
GET_IP=true
shift
;;
-s|--subdomains)
GET_SUBDOMAINS=true
shift
;;
*)
DOMAIN="$1"
shift
;;
esac
done

#Wyświetl logo
display_logo

#Sprawdź, czy podano domenę
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

if $GET_IP; then
echo "Sprawdzanie adresu IP:"
dig +short "$DOMAIN"
echo
fi

if $GET_SUBDOMAINS; then
echo "Szukanie poddomen:"
subdomains=$(curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' | sed 's/*.//g' | sort -u | grep -v "$DOMAIN")
for sub in $subdomains
do
echo "$sub"
done
fi

exit 0
