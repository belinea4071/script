#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
function header_info {
clear
cat <<"EOF"
    *   *_          **  **______                ______  _ 
   / | / /__  *  *_/ /_/ ____/ /___  **  **____/ / __ \(_)
  /  |/ / * \| |/*/ **/ /   / / ** \/ / / / __  / /_/ / / 
 / /|  /  __/>  </ /_/ /___/ / /_/ / /_/ / /_/ / ____/ /  
/_/ |_/\___/_/|_|\__/\____/_/\____/\__,_/\__,_/_/   /_/   
                                                          
EOF
}
header_info
echo -e "Loading..."
APP="NextCloudPi"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function install_face_recognition() {
  msg_info "Installing Face Recognition dependencies"
  apt-get update &>/dev/null
  apt-get install -y python3-pip cmake build-essential python3-dev \
    libx11-dev libatlas-base-dev libgtk-3-dev libboost-python-dev &>/dev/null
  
  msg_info "Installing Face Recognition Python packages"
  pip3 install numpy dlib face_recognition &>/dev/null
  
  msg_info "Installing Nextcloud Face Recognition app"
  # Wechsel zum Nextcloud Apps Verzeichnis
  cd /var/www/nextcloud/apps/
  
  # Herunterladen und Installieren der Face Recognition App
  wget https://github.com/matiasdelellis/facerecognition/releases/latest/download/facerecognition.tar.gz &>/dev/null
  tar -xf facerecognition.tar.gz
  rm facerecognition.tar.gz
  
  # Setze korrekte Berechtigungen
  chown -R www-data:www-data facerecognition/
  
  # Aktiviere die App in Nextcloud
  sudo -u www-data php /var/www/nextcloud/occ app:enable facerecognition
  
  msg_ok "Face Recognition app installed successfully"
}

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /lib/systemd/system/nextcloud-domain.service ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
  msg_info "Updating ${APP} LXC"
  apt-get update &>/dev/null
  apt-get -y upgrade &>/dev/null
  msg_ok "Updated Successfully"
  exit
}

start
build_container
description

# Install Face Recognition nach der Basis-Installation
install_face_recognition

msg_ok "Completed Successfully!\n"
echo -e "${APP} Setup should be reachable by going to the following URL.
         ${BL}https://${IP}/${CL} \n"
echo -e "Face Recognition app has been installed and can be configured in the Nextcloud admin settings.\n"
