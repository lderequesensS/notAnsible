#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"
CYAN="\033[0;36m"
SEPARATOR="==*==*==*==*==*==*==*==*==*==*==*==*==*==*"

fails=0
list_fails=""

# echo -e "${SEPARATOR}"
# echo -e "${CYAN} STEP 1: Improving Dnf${NC}"
# echo -e "${SEPARATOR}"
# echo -e "${GREEN}Adding this options:${NC}"
# cat options_dnf | sudo tee -a /etc/dnf/dnf.conf 2>>errors
# if [[ $? -ne 0 ]]; then
# 	list_fails="${list_fails} * dnf config \n"
# 	fails=$((fails+1))
# fi

# echo -e "${SEPARATOR}"
# echo -e "${CYAN} STEP 2: Software ${NC}"
# echo -e "${SEPARATOR}"
# echo -e "${GREEN}Adding rpm fusion${NC}"
# sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y >/dev/null 2>>errors
# if [[ $? -ne 0 ]]; then
# 	list_fails="${list_fails} * rpm free \n"
# 	fails=$((fails+1))
# fi
# sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y >/dev/null 2>>errors
# if [[ $? -ne 0 ]]; then
# 	list_fails="${list_fails} * rpm non-free \n"
# 	fails=$((fails+1))
# fi
# echo -e "${GREEN}Dnf update${NC}"
# sudo dnf update -y >/dev/null 2>>errors
# sudo dnf install nano -y >/dev/null 2>>errors
# if [[ $? -ne 0 ]]; then
# 	list_fails="${list_fails} * dnf update \n"
# 	fails=$((fails+1))
# fi
# echo -e "${GREEN}Software installation${NC}"
# sudo dnf install $(cat software.txt) -y >/dev/null 2>>errors
# if [[ $? -ne 0 ]]; then
# 	list_fails="${list_fails} * software installation \n"
# 	fails=$((fails+1))
# fi

echo -e "${SEPARATOR}"
echo -e "${CYAN} STEP 3: SSH${NC}"
echo -e "${SEPARATOR}"


echo -e "${SEPARATOR}"
echo -e "${CYAN} STEP X: Cleaning${NC}"
echo -e "${SEPARATOR}"

echo -e "${GREEN} FINISHED!${NC}"

echo <<EOF "Things that still are manual:
  Download and change GTK theme
  Download and change QT theme
  Installing games"
EOF

if [[ $fails > 0 ]]; then
	echo -e "${RED} Steps that failed:${NC}"
	echo -e "${list_fails}"
	echo -e "${RED} Please check errors file for more info ${NC}"
fi
