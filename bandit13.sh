#!/bin/bash 

function crtl_c() {
	echo -e "\n\n [-] Finalización forzada del programa . . .\n"
	exit 1	
}

trap crtl_c INT; 
nombre_archivo=""

while getopts ":f:" opt; do 
	case $opt in 
		f)
			echo -e "\n[-] El archivo para trabajar es: $OPTARG\n" >&2
			nombre_archivo=$OPTARG 
		;;
		\?)
			echo -e "\n[-] Opción inválido: -$OPTARG" >&2
			exit 1
		;;
		:) 
			echo -e "\n[-] Opción -$OPTARG requiere un argumento." >&2
			exit 1
		;;
	esac
done

# Chequeamos que el archivo realmente existe
test -f "$nombre_archivo"
if [ "$(echo $?)" == "1" ]; then 
	echo -e "\n[!] Este archivo $nombre_archivo NO existe\n"
	exit 1
fi

# echo -e "\n[+] NOMBRE DE ARCHIVO: $nombre_archivo\n\n"
dataConvert="dataConvert"
cat $nombre_archivo | xxd -r | tee $dataConvert &>/dev/null
7z x $dataConvert &>/dev/null

while [ $dataConvert ]; do 
	echo -e "Data a descomprimir $dataConvert \n"
	dataConvert=$(7z l $dataConvert 2>/dev/null | tail -n 3 | head -n 1 | awk 'NF{print $NF}')
	7z x $dataConvert &>/dev/null
	
	file $dataConvert | grep text
	if [ "$(echo $?)" == "0" ]; then
		echo -e "\n\n[+] El programa ha finalizado correctamente - $(cat $dataConvert)\n"
		rm data*
		exit 0
	fi
done