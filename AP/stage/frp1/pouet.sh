#!/bin/bash

ROUGE='\033[0;31m'
ORANGE='\e[38;5;208m'
JAUNE='\e[33m'
VERT='\033[0;32m'
BLEU='\033[0;34m'
NC='\033[0m' 

echo "


                     %%%%                              %%%%%   %%%%%=                               
                    .%%%%                             #%%%%*   %%%%%                                
                    #%%%%                             %%%%%.  .%%%%@                                
  :%%%%%%%%%%#   :%%%%%%%%%%%     .%%%%%%%%%@        .%%%%%   @%%%%:    +%%%%%%%%#      @@@@@. +%%%%
 %%%%%%@%@%%%%%# :%%%%%%%%%%%   .%%%%%%%%%%%%%%.     +%%%%#   %%%%%   %%%%%%%%%%%%%%    @%%%%.%%%%%%
%%%%%      +%%%%.   %%%%%      %%%%%%      %%%%%#    %%%%%   .%%%%@  %%%%%-    .%%%%%   @%%%%%%@==#%
%%%%%%-             %%%%%     .%%%%@        @%%%%    %%%%%   %%%%%=             %%%%%-  @%%%%%      
 @%%%%%%%%%%%%#     %%%%%     %%%%%%%%%%%%%%%%%%%#  #%%%%*   %%%%%      =@%%%%%%%%%%%-  @%%%%.      
    *%%%%%%%%%%%-   %%%%%     %%%%%%%%%%%%%%%%%%%#  %%%%%   .%%%%@   #%%%%%%%%%+%%%%%-  @%%%%.      
@@@@%      .%%%%@   %%%%%      %%%%%               .%%%%%   @%%%%-  %%%%%-      %%%%%-  @%%%%.      
#%%%%+     *%%%%%   #%%%%%*.:: -%%%%%%    .@%%%%@  +%%%%#   %%%%%   @%%%%.     @%%%%%-  @%%%%.      
 +%%%%%%%%%%%%%%     @%%%%%%%:   @%%%%%%%%%%%%%-   %%%%%   .%%%%@   :%%%%%%%%%%%%%%%%-  @%%%%.      
    #@%%%%%%#          -%%%%#      .%%%%%%%@*      %%%%%   %%%%%=     +%%%%%%%. %%%%%-  @%%%%.      
    "

ping_test() {
    echo -e "--------------------------- Ping test ------------------------------"
    if ping -c 1 "8.8.8.8" > /dev/null 2>&1; then
        echo -e "${VERT}successful ping.${NC}"
    else
        echo -e "${ROUGE}ping failure.${NC}"
    fi
}

dns_test() {
    echo -e "--------------------------- Test DNS ------------------------------"
    result=$(dig +short google.com)

    if [ -n "$result" ]; then
        echo -e "${VERT}DNS test successful.${NC}"
    else
        echo -e "${ROUGE}DNS test failure.${NC}"
    fi
}

signal_quality() {
    echo -e "------------------------- Signal Quality ---------------------------"

echo -n "Choose a modem (1/2): "
read -r modem

MODEM1="/sys/devices/platform/soc/11200000.usb/usb1/1-1/1-1.1"
MODEM2="/sys/devices/platform/soc/11200000.usb/usb1/1-1/1-1.2"

if [[ "$modem" == "1" ]]; then 
    response=$(mmcli -m "$MODEM1" --command 'AT+QENG="servingcell"' 2>&1)
    if echo "$response" | grep -q "couldn't find modem"; then
        echo -e "${ROUGE}Modem 1 not found${NC}"
        exit 1
    fi
    echo -e "${BLEU}Modem 1 is used${NC}"
    operator_response=$(mmcli -m "$MODEM1" --command 'AT+COPS?' 2>&1)
elif [[ "$modem" == "2" ]]; then
    response=$(mmcli -m "$MODEM2" --command 'AT+QENG="servingcell"' 2>&1)
    if echo "$response" | grep -q "couldn't find modem"; then
        echo -e "${ROUGE}Modem 2 not found${NC}"
        exit 1
    fi
    echo -e "${BLEU}Modem 2 is used${NC}"
    operator_response=$(mmcli -m "$MODEM2" --command 'AT+COPS?' 2>&1)
else
    echo "Invalid choice"
    exit 1
fi

# Extraction opérateur
operator=$(echo "$operator_response" | sed -n 's/.*"\(.*\)".*/\1/p')
echo -e "${BLEU}Operator:${NC} $operator${NC}"

# Extraction et affichage des valeurs
rsrp=$(echo "$response" | awk -F',' '{print $14}' | tr -d '[:space:]')
rsrq=$(echo "$response" | awk -F',' '{print $15}' | tr -d '[:space:]')
rssi=$(echo "$response" | awk -F',' '{print $16}' | tr -d '[:space:]')
sinr=$(echo "$response" | awk -F',' '{print $18}' | tr -d '[:space:]')

    if (( rsrp >= -90 )); then
            echo -e "${VERT}RSRP: Excellent${NC}"
    elif (( rsrp >= -105 && rsrp < -90 )); then
        echo -e "${JAUNE}RSRP: Good${NC}"
    elif (( rsrp >= -115 && rsrp < -105 )); then
        echo -e "${ORANGE}RSRP: Fair${NC}"
    else
        echo -e "${ROUGE}RSRP: Poor${NC}"
    fi

    if (( rsrq >= -10 )); then
        echo -e "${VERT}RSRQ: Excellent${NC}"
    elif (( rsrq >= -15 && rsrq < -10 )); then
        echo -e "${JAUNE}RSRQ: Good${NC}"
    elif (( rsrq >= -20 && rsrq < -15 )); then
        echo -e "${ORANGE}RSRQ: Fair${NC}"
    else
        echo -e "${ROUGE}RSRQ: Poor${NC}"
    fi

    if (( rssi >= -70 )); then
        echo -e "${VERT}RSSI: Excellent${NC}"
    elif (( rssi >= -85 && rssi < -70 )); then
        echo -e "${JAUNE}RSSI: Good${NC}"
    elif (( rssi >= -100 && rssi < -85 )); then
         echo -e "${ORANGE}RSSI: Fair${NC}"
    else
        echo -e "${ROUGE}RSSI: Poor${NC}"
    fi


    if (( sinr >= 20 )); then
        echo -e "${VERT}SINR: Excellent${NC}"
    elif (( sinr >= 13 && sinr < 20 )); then
        echo -e "${JAUNE}SINR: Good${NC}"
    elif (( sinr > 0 && sinr < 13 )); then
        echo -e "${ORANGE}SINR: Fair${NC}"
    elif (( sinr == 0 )); then
        echo -e "${ROUGE}SINR: Poor${NC}"
    else
        echo -e "${ROUGE}SINR: Null${NC}"
    fi
}
#--------------- MAIN CODE -------------------
case "$1" in
    ping)
        ping_test
        ;;
    dns)
        dns_test
        ;;
    signal)
        signal_quality
        ;;
    ""|all)
        ping_test
        dns_test
        signal_quality
        ;;

esac
