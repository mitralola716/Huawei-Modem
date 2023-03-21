#!/bin/bash
#---------------------------------------
# MODEM TOOLS
#---------------------------------------
# Refresh Data Script by MrAsxNet
# (c) 2023 MrAsxNet
#---------------------------------------
# Membaca config
INSDIR="/root/Huawei-Modem"
getIP=$(sed -n '1p' "$INSDIR"/config)
getUsrMdm=$(sed -n '2p' "$INSDIR"/config)
getUsrPswd=$(sed -n '3p' "$INSDIR"/config)
#ipmodem=$(route -n|awk '{print $2}'|grep 192.168|head -n1)
#ipmodem=$(bash "$INSDIR"/cmd/ip.sh)
ipmodem=$getIP
 
# Jalankan script python dan tangkap outputnya dengan waktu respon maksimum 5 detik
output=$( (python $INSDIR/commands/reconnect_dialup.py --username $getUsrMdm --password $getUsrPswd http://$ipmodem & pid=$!; (sleep 5; kill $pid) & wait $pid) 2>/dev/null )

# Cek apakah output tidak kosong
if [ ! -z "$output" ]; then
  # Cek apakah output mengandung kata "successfully"
  if echo "$output" | grep -q "Enabling"; then
    echo " Refresh Data Berhasil.."
  # Jika tidak, cek apakah output mengandung kata "error"
#  elif echo "$output" | grep -q "error"; then
    else
	echo " Refresh Data Error.."
  fi
else
  echo " Tidak ada respon. Coba periksa modem."
fi

# Menampilkan output dari hasil eksekusi script "output"
# echo "$output"

# Cek apakah output mengandung kata "Enabling"
#if echo "$output" | grep -q "Enabling"; then
#  echo " Refresh Data Berhasil.."
# Jika tidak, cek apakah output mengandung kata "error"
#elif echo "$output" | grep -q "error"; then
#  echo " Refresh Data Error.."
#fi