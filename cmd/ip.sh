#!/bin/bash

function detect_modem_ip {
    # coba mendapatkan alamat IP modem secara otomatis
    local modem_ip="$(ip route | grep default | awk '{print $3}')"

    # jika tidak dapat mendeteksi alamat IP modem, minta masukan manual
    if [[ -z "$modem_ip" ]]; then
        echo "Tidak dapat mendeteksi alamat IP modem secara otomatis."
        read -p "Silakan masukkan alamat IP modem secara manual: " modem_ip
        if [[ -z "$modem_ip" ]]; then
            echo "Alamat IP modem belum dimasukkan. Keluar dari program."
            exit 1
        fi
    fi

    echo "$modem_ip"
}

detect_modem_ip

