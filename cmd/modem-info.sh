#!/bin/bash
#---------------------------------------
#  MODEM TOOLS
#--------------
#--Modem Info--
#---------------------------------------
# Refresh Data Script by MrAsxNet
# (c) 2023 MrAsxNet
#---------------------------------------
# Membaca config
INSDIR="/root/Huawei-Modem"
getIP=$(sed -n '1p' "$INSDIR"/config)
getUsrMdm=$(sed -n '2p' "$INSDIR"/config)
getUsrPswd=$(sed -n '3p' "$INSDIR"/config)
ipmodem=$(route -n|awk '{print $2}'|grep 192.168|head -n1)

# Menjalankan file Python dan menangkap output JSON
output=$( (cd $INSDIR/modem && ./modem info & pid=$!; (sleep 5; kill $pid) & wait $pid) 2>/dev/null )

# Mengganti semua kutip satu dengan kutip dua dalam output
output=${output//\'/\"}

# Menghapus tanda kutip dua, tanda kurung kurawal, mengganti koma dengan enter, menghapus tanda kurung siku, memberikan satu spasi pada setiap baris, dan menambahkan satu tab sebelum setiap titik dua
formatted_output=$(echo "$output" | sed -e 's/[{}]*//g; s/Operator/ Operator/g; s/Device/ Device/g; s/Imei/IMEI/g; s/Imsi/IMSI/g; s/Iccid/ICC-ID/g; s/Msisdn/MSISDN/g; s/Mac/MAC/g; s/Version/ Version/g; s/Address/ Address /g; s/Product/Product /g; s/supportmode/Support Mode/g; s/workmode/Work Mode/g; s/WanIP/WAN IP/g; s/"//g; s/,/\n/g')


# Cek apakah output tidak kosong
if [ ! -z "$output" ]; then
### script asli
# Menampilkan notifikasi error jika ada kata "error" dalam output
if echo "$formatted_output" | grep -q "error"; then
  echo " Terjadi error dalam menjalankan script."
else
  # Menampilkan output yang telah diformat
  echo "$formatted_output"
fi
###
else
  echo " Tidak ada respon. Coba periksa modem."
fi
