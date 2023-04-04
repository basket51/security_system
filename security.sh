#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Ctrl+C
trap ctrl_c INT

function ctrl_c(){
	echo -e "${redColour}[!] Saliendo...${endColour}"
	exit 1
}

function helpPanel(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Uso: ./security.sh -u <username> -p <password>${endColour}\n"
	echo -e "${purpleColour}u) ${endColour}${yellowColour}Introduce tu username${endColour}"
	echo -e "${purpleColour}p) ${endColour}${yellowColour}Introduce una password${endColour}"
	echo -e "${purpleColour}h) ${endColour}${yellowColour}Mostrar este panel de ayuda${endColour}\n"
}
function security(){
  echo -e "\n${blueColour}[*]${grayColour} Activando firewall...\n"
  sleep 1
  ufw enable
  echo -e "\n${blueColour}[*]${grayColour} Configurando las reglas del firewall para bloquear el trafico http https\n"
  sleep 1
  ufw deny http # Si quieres activarlo pon allow en vez de deny
  ufw deny https # Si quieres actiarlo pon allow en vez de deny
  echo -e "\n${blueColour}[*]${grayColour} Configurando las reglas para bloquear el trafico ssh\n"
  sleep 1
  ufw deny ssh
  echo -e "\n${blueColour}[*]${grayColour} Verificando las reglas de firewall ...\n"
  sleep 1
  ufw status verbose
  # Si quieres eliminar una regla de firewall pon ufw delete <nombre de la regla>
  clear
  echo -e "\n${blueColour}[*]${grayColour} Instalando el antivirus clamav\n"
  sleep 1
  apt install clamav 2>/dev/null
  echo -e "${blueColour}[*]${grayColour} Actualizando las definiciones de virus de ClamAV"
  sleep 1
  freshclam
  echo -e "${blueColour}[*]${grayColour} Escaneando el sistema operativo"
  clamscan -r /root/ -i --log=/var/log/clamav/scan.log

}

# Main function
if [ $(id -u) == "0" ]; then
	declare -i parameter_counter=0; while getopts "h:" arg; do
	      case $arg in
    		h) helpPanel;;
	      esac
	done

	if [ $parameter_counter -ne 0 ]; then
		helpPanel
	else
		security
	fi
else
	echo -e "${redColour}[!]${endColour}${grayColour}NO tienes suficientes privilegios${endColour}"
fi

