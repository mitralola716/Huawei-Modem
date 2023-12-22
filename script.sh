#!/bin/bash
# HUAWEI MODEM TOOLS
# Created by MrAsxNet

clear
# Membaca config
INSDIR="/root/Huawei-Modem"
getIP=$(sed -n '1p' "$INSDIR"/config)
getUsrMdm=$(sed -n '2p' "$INSDIR"/config)
getUsrPswd=$(sed -n '3p' "$INSDIR"/config)
ipmodem=$(ip route | grep default | awk '{print $3}')
ipmanual=$(sed -n '4p' "$INSDIR"/config)


# Menjeda script
function pause(){
   read -p "$*"
}

# Timer
function timer() {
echo -n " $timer_lang "

for i in {5..1}; do
    echo -n "$i.. "
    sleep 1
    echo -ne "\b\b\b\b"
done
}


# Mendeteksi ip modem otomatis 
function detect_modem_ip {
    # coba mendapatkan alamat IP modem secara otomatis
    local ip="$(ip route | grep default | awk '{print $3}')"

    # jika tidak dapat mendeteksi alamat IP modem, minta masukan manual
    if [[ -z "$ip" ]]; then
		clear
		echo -e " ========================================"
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ========================================"
		echo " ----------------------------------------"		
        echo " Tidak dapat mendeteksi alamat IP modem secara otomatis."
        read -p "Silakan masukkan alamat IP modem secara manual: " ip
		if ! [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
			clear
			echo -e " ========================================"
			echo -e "           MODEM TOOLS            "
			echo -e "         $created MrAsxNet        "
			echo -e " ========================================"
			echo " ----------------------------------------"	          
			echo " Alamat IP modem belum dimasukkan." 
			echo " ----------------------------------------"	
			sleep 5
			clear
			echo -e " ========================================"
			echo -e "           MODEM TOOLS            "
			echo -e "         $created MrAsxNet        "
			echo -e " ========================================"
			echo " ----------------------------------------"	
			echo " $exit_msg.."
			echo " ----------------------------------------"	
            exit 1
        fi
    fi

    echo "$ip"
}



echo " ====================================="
echo "           MODEM TOOLS            "
echo "        Created by MrAsxNet        "
echo " ====================================="
echo " ==    Select language:             =="
echo " ==    1. English                   =="
echo " ==    2. Bahasa Indonesia          =="
echo " ==    3. Exiting Script..          =="
echo " ====================================="

# Meminta input dari pengguna
read -p " Choice [1-3]: " lang_choice

# Mengecek pilihan bahasa yang dipilih
if [ "$lang_choice" == 1 ]
then
    ip1="192.168.8.1"
    ip2="192.168.9.1"
    auto_detect="Auto Detection"
    ip_manual_prompt="Enter manual IP address:"
    ip_prompt="Select IP address :"
    exit_msg="Exiting script.."
    invalid_choice_msg="Invalid choice"
    created="Created by"
    option="Choice"
	invalid_choice="Invalid option"
	try_again="please try again"
    choice_opt="Enter your choice"
    running="Running script"
    reboot_modem="Reboot Modem"
    refresh="Refresh Data (IP On/Off)"
	reboot-adb="Reboot using ADB"
    modem_info="Modem Info"
	error_ip_manual="Please enter valid IP"
	quit="Quit"
	to_menu="Press [ENTER] to back menu"
	stuck="If stuck, press CTRL + C"
	sms="Send a SMS"
	timer_lang="Please wait"
elif [ "$lang_choice" == 2 ]
then
    ip1="192.168.8.1"
    ip2="192.168.9.1"
    auto_detect="Deteksi Otomatis"
    ip_manual_prompt="Masukkan alamat IP manual:"
    ip_prompt="Pilih alamat IP :"
    exit_msg="Keluar.."
    invalid_choice_msg="Masukkan Salah"
	try_again="coba lagi"
    created="Dibuat oleh"
    option="Pilihan"
	invalid_choice="Pilihan tidak valid"	
    choice_opt="Masukkan Pilihanmu"
    running="Menjalankan perintah"
    reboot_modem="Nyalakan Ulang Modem"
    refresh="Refresh Data (IP On/Off)"
	reboot-adb="Reboot menggunakan ADB"
    modem_info="Info Modem"
	error_ip_manual="IP yang Anda masukkan tidak valid"
	quit="Keluar"
	to_menu="Tekan [ENTER] untuk kembali ke menu"
	stuck="Jika bengong, tekan CTRL + C"
	sms="Kirim SMS"
	timer_lang="Mohon tunggu"
elif [ "$lang_choice" == 3 ]
then
    echo " Exiting Script.."  
    exit 0
else
    echo " Invalid choice"
    exit 1
fi

clear

# Menampilkan pilihan IP modem yang tersedia
echo " ====================================="
echo "           MODEM TOOLS            "
echo "         $created MrAsxNet        "
echo " ====================================="
echo " $ip_prompt"
echo " 1. $auto_detect"
#echo " 2. $ip1"
#echo " 3. $ip2"
echo " 2. $ip_manual_prompt"
echo " 3. $exit_msg"
echo " ====================================="

# Meminta input dari pengguna
read -p " $choice_opt [1-3]: " ip_option

# Mengecek pilihan yang dipilih
if [ "$ip_option" == 1 ]
then
    detect_modem_ip
	#ip=$(ip route | grep default | awk '{print $3}')
#elif [ "$ip_option" == 2 ]
#then
#    ip="192.168.8.1"
#elif [ "$ip_option" == 3 ]
#then
#    ip="192.168.9.1"
elif [ "$ip_option" == 2 ]
then
    read -p " $ip_manual_prompt " ip
	if ! [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
		echo " $error_ip_manual...."
		exit 1
	fi
# Menuliskan alamat IP manual pada baris keempat pada config	
sed -i '4s/.*/'"$ip"'/' config
#echo $ip | 	
elif [ "$ip_option" == 3 ]
then
    echo " $exit_msg"
    exit 0
else
    echo "$invalid_choice_msg"
    exit 1
fi



clear

# Menu modem tools
echo -e " ====================================="
echo -e "           MODEM TOOLS            "
echo -e "         $created MrAsxNet        "
echo -e " ====================================="
echo "  $choice_opt :"
echo "  1. $reboot_modem"
echo "  2. $refresh"
echo "  3. Modem Info"
echo "  4. Device Info"
echo "  5. Reboot (ADB)"
echo "  6. Lock Cell-ID (E3372)"
echo "  7. Unlock Cell-ID (E3372)"
echo "  8. IP Hunter"
echo "  9. $sms"
echo "  10. $quit"
echo -e " ====================================="
read -p "  $choice_opt [1-7]: " menu_option

case $menu_option in
    1)
		clear
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $running $reboot_modem..."
		echo " ----------------------------------------"	
		timer
		clear
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " $running $reboot_modem..."
		echo " ----------------------------------------"		    
		bash $INSDIR/cmd/reboot.sh
		echo " ----------------------------------------"		
		#echo " $running $reboot_modem succes.."
		echo " ========================================="
		echo " $to_menu"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm
        ;;
    2)
		clear
		echo -e " ========================================"
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ========================================"
		echo " ----------------------------------------"
		echo " $running $refresh"
		timer
		clear
		echo -e " ========================================"
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ========================================"
		echo " ----------------------------------------"
		echo " $stuck"	
		echo " ----------------------------------------"
        echo " $running $refresh..."
		echo " ----------------------------------------"		
        bash $INSDIR/cmd/refresh-data.sh
		echo " ----------------------------------------"
		echo " ========================================"
		echo " $to_menu"
		echo " ========================================"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm
        ;;
    3)
		clear
		echo -e " ====================================="
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ====================================="
		echo " ----------------------------------------"		
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " $running Modem Info..."
		echo " -----------------------------------------"	
        cd $INSDIR/modem && ./modem info 
		echo " ----------------------------------------"
		echo " ========================================"
		echo " $to_menu"
		echo " ========================================"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm		
        ;;
    4)  #menampilkan banner
		clear
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " $running Device Info..."
		echo " ----------------------------------------"	
		timer
		clear
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " $running Device Info..."
		echo " ----------------------------------------"		
        bash $INSDIR/cmd/device-info.sh
		echo " ----------------------------------------"
		echo " ========================================"
		echo " $to_menu"
		echo " ========================================"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm		
        ;;
    5)
		clear
		echo -e " ========================================"
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ========================================"
		echo " ----------------------------------------"
		echo " $running $reboot-adb using ADB"
		echo " ----------------------------------------"		
		timer
		clear		
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " $running Reboot using ADB..."
		echo " ----------------------------------------"	
        cd $INSDIR/modem && ./modem reboot-adb
		echo " ----------------------------------------"
		echo " ========================================"
		echo " $to_menu"
		echo " ========================================"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm			
        ;;
    6)
		clear	
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " Running script Lock Cell-ID..."
		echo " ----------------------------------------"	
        cd $INSDIR/modem && ./modem lock
		echo " ----------------------------------------"
		echo " ========================================"
		echo " $to_menu"
		echo " ========================================"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm			
        ;;
    7)
		clear
		echo -e " ========================================"
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ========================================"
		echo " ----------------------------------------"
		echo " $running script Unlock Cell-ID..."
		timer
		clear		
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " $running script Unlock Cell-ID..."
		echo " ----------------------------------------"	
        cd $INSDIR/modem && ./modem unlock
		echo " ----------------------------------------"
		echo " ========================================"
		echo " $to_menu"
		echo " ========================================"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm			
        ;;
    8)
		clear
		echo -e " ========================================"
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ========================================"
		echo " ----------------------------------------"
		echo " $running IP Hunter"
		timer
		clear		
		echo " ========================================"
		echo "           MODEM TOOLS            "
		echo "         $created MrAsxNet        "
		echo " ========================================"
		echo " $stuck"
		echo " ----------------------------------------"	
		echo " $running IP Hunter..."
		echo " ----------------------------------------"	
        cd $INSDIR/modem && ./modem iphunter
		echo " ----------------------------------------"
		echo " ========================================"
		echo " $to_menu"
		echo " ========================================"
		# ...
		# memanggil jeda
		pause
		#
		# ...kembali ke menu utama
		bash mdm			
        ;;																
    9)
		echo " ----------------------------------------"
		echo " Silahkan masukan tujuan:..."
        read -p " Nomor Tujuan : " nomor
		if [ -z "$nomor" ]; then
			echo " Masukkan salah...."
			exit 1
		fi
		echo "Silahkan isi pesan (Tanpa Spasi):..."
        read -p "Pesan Kamu : " pesan
		if [ -z "$pesan" ]; then
			echo " $invalid_choice_msg...."
			exit 1
		fi
		echo "Oke, pesan dengan isi '$pesan' akan segera di kirim ke $nomor."
		sleep 5
		echo "____________________"
		echo " Please wait.."
		python $INSDIR/commands/send_sms.py --username $getUsrMdm --password $getUsrPswd http://$ip $nomor "$pesan"
        ;;
    10)
        echo "$exit_msg"
        exit 0
        ;;
    *)
        clear
		echo -e " ====================================="
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ====================================="	
		echo -e "  $invalid_choice, $try_again. "
		echo -e " ====================================="		
		sleep 5
		clear
		echo -e " ====================================="
		echo -e "           MODEM TOOLS            "
		echo -e "         $created MrAsxNet        "
		echo -e " ====================================="
		echo -e " $exit_msg "
		echo -e " ====================================="		
		sleep 3
        exit 1
		clear
        ;;
esac


