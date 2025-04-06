#!/bin/bash

PORT=9000
DIRECTORY=$(pwd) # Current directory where the files are being served
IPADD=$(hostname -I | grep -E '^192.168' | cut -d ' ' -f 1)

while [[ $# -gt 0 ]]; do
  case $1 in
    -p)
      PORT="$2"
      shift 2  # Skip past the -p and its value
      ;;
    -d)
      DIRECTORY="$2"
      shift 2  # Skip past the -d and its value
      ;;
    -q)
      q="$2"  # Correct the shift to get the value of -q
      shift 2  # Skip past the -q and its value
      ;;
    *)
      echo "Usage: $0 [-p <port>] [-d <directory>] [-q <generate_qr then provide 'y'>]"
      exit 1
      ;;
  esac
done

LINK="http://${IPADD}:${PORT}"

echo "Starting Server with Address: ${LINK} for directory ${DIRECTORY}"


if [ "$q" = 'y' ]; then

  python3 - <<EOF
try:
  import qrcode
  from rich.console import Console
  from rich.text import Text
except ImportError:
  print("Unable to generate QR please install dependencies ... [qrcode, rich]")
  exit()

CHARACTER = chr(9608)   # █ Character ASCII Value

qr = qrcode.QRCode(
    version=1, error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=1, border=2,
)

qr.add_data("${LINK}")
qr.make(fit=True)
qr_image = qr.get_matrix()
qr_string = ""

console = Console()

for row in qr_image:
    for col in row:
        if col:
            qr_string += CHARACTER
        else:
            qr_string += " "
    qr_string += "\n"

qr_text = Text(qr_string, style="bold red on white")
console.print(qr_text)

EOF

fi

echo -e "\033[31;4mStarted Server at ${LINK}\033[0m"
# echo -e "\Started Server at ${LINK}"
python3 -m http.server $PORT -d $DIRECTORY


echo "Killing Server...."
