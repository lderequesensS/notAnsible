#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"
CYAN="\033[0;36m"
SEPARATOR="==*==*==*==*==*==*==*==*==*==*==*==*==*==*"

fails=0
list_fails=""

step(){
	echo -e "${GREEN}$1${NC}"
}

echo -e "${SEPARATOR}"
echo -e "${CYAN} STEP 1: Improving Dnf${NC}"
echo -e "${SEPARATOR}"

step "Adding this options:"
cat options_dnf | sudo tee -a /etc/dnf/dnf.conf 2>>errors
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * dnf config \n"
	fails=$((fails+1))
fi


echo -e "${SEPARATOR}"
echo -e "${CYAN} STEP 2: Software ${NC}"
echo -e "${SEPARATOR}"

step "Adding rpm fusion"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y >/dev/null 2>>errors
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * rpm free \n"
	fails=$((fails+1))
fi

sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y >/dev/null 2>>errors
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * rpm non-free \n"
	fails=$((fails+1))
fi

step "Dnf update"
sudo dnf update -y >/dev/null 2>>errors
sudo dnf install nano -y >/dev/null 2>>errors
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * dnf update \n"
	fails=$((fails+1))
fi

step "Software installation"
sudo dnf install $(cat software.txt) -y >/dev/null 2>>errors
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * software installation \n"
	fails=$((fails+1))
fi


echo -e "${SEPARATOR}"
echo -e "${CYAN} STEP 3: SSH${NC}"
echo -e "${SEPARATOR}"

mkdir .ssh 2>&1 >/dev/null #Just if .ssh don't exists
mv id_rsa* $HOME/.ssh/

step "Decrypting id_rsa"
ansible-vault decrypt $HOME/.ssh/id_rsa
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * id_rsa not decrypted \n"
	fails=$((fails+1))
fi

step "Decrypting id_rsa.pub"
ansible-vault decrypt $HOME/.ssh/id_rsa.pub
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * id_rsa.pub not decrypted \n"
	fails=$((fails+1))
fi


echo -e "${SEPARATOR}"
echo -e "${CYAN} STEP 4: Dotfiles${NC}"
echo -e "${SEPARATOR}"

step "Cloning .dotfiles"
git clone git@github.com:lderequesensS/.dotfiles.git .dotfiles >/dev/null 2>>errors
if [[ $? -ne 0 ]]; then
	list_fails="${list_fails} * .dotfiles not downloaded \n"
	fails=$((fails+1))
else
	step "Stowing the stow"
	cd .dotfiles
	stow */
	if [[ $? -ne 0 ]]; then
		list_fails="${list_fails} * Stowing just failed :O \n"
		fails=$((fails+1))
	fi
	cd ..
fi


echo -e "${SEPARATOR}"
echo -e "${CYAN} STEP 5: Cleaning${NC}"
echo -e "${SEPARATOR}"

step "Cleaning the mess..."
rm -f Dockerfile
rm -f software.txt
rm -f run_docker.sh
rm -f script.sh
rm -f README.md
rm -f options_dnf

echo -e <<EOF "${CYAN}${SEPARATOR}
${GREEN}Finished!${NC}
Things that still are manual:
  Download and change GTK theme
  Download and change QT theme
  Installing games
${CYAN}${SEPARATOR}${NC}"
EOF

if [[ $fails > 0 ]]; then
	echo -e ""
	echo -e "${RED} Steps that failed:${NC}"
	echo -e "${list_fails}"
	echo -e "${RED} Please check errors file for more info ${NC}"
fi
