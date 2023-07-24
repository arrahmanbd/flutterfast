#!/bin/bash
#================================#
#   FlutterFAST by @arrahman      #
#   https://arrahmanbd.github.io #
#================================#

# Banner
printf "\e[1;34m

   ╭━━━┳╮╱╱╱╭╮╱╭╮╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮
   ┃╭━━┫┃╱╱╭╯╰┳╯╰╮╱╱╱╱┃╭━━╯╱╱╱╱╭╯╰╮
   ┃╰━━┫┃╭╮┣╮╭┻╮╭╋━━┳━┫╰━━┳━━┳━┻╮╭╯
   ┃╭━━┫┃┃┃┃┃┃╱┃┃┃┃━┫╭┫╭━━┫╭╮┃━━┫┃
   ┃┃╱╱┃╰┫╰╯┃╰╮┃╰┫┃━┫┃┃┃╱╱┃╭╮┣━━┃╰╮
   ╰╯╱╱╰━┻━━┻━╯╰━┻━━┻╯╰╯╱╱╰╯╰┻━━┻━╯
                                                                    
\e[1;32m	-----by @AR Rahman-----\n\e[1;0m"
# Function to display help text
function show_help() {
  echo "Usage: ./flutterfast.sh "
  echo "Install Flutter Easily on Any Linux (Debian, Arch)"
  echo ""
  echo "Options:"
  echo "  --help    Display this help message and exit"
  echo "  --link    Displays required files download links and exit"
  echo "  --auto    Auto download & setup flutter & Android sdk"
}
function intro() {
printf "\n\e[1;33mUsage: \e[1;35m./flutterfast.sh \e[1;35m[OPTION] \n\n"
printf "\e[1;33mAuto Install:\n"
printf "\e[1;34m\tFlutter,Android SDK, Java JDK, Linux Tools\n"
printf "\e[1;34m\tSetup Environment Path\n\n"
printf "\e[1;33mManual Guide:\n"
printf "\e[1;35mYouTube: \e[1;34mhttps://www.youtube.com/watch?v=4Jx-5Zp28VQ\n\n";
printf "\e[1;33mOptions:\n"
printf "\e[1;35m  --help: \e[1;34mShow Help Texts\n";
printf "\e[1;35m  --auto: \e[1;34mAuto Download & Setup\n";
printf "\e[1;35m  --link: \e[1;34mShow Download Links\n\n";
}
#Show Download LInk
function link(){
printf "\e[1;33mDownload Links:\n"
printf "\e[1;35mFlutter Linux: \e[1;34mhttps://docs.flutter.dev/get-started/install/linux\n\n";
printf "\e[1;35mAndroid SDK: \e[1;34mhttps://drive.google.com/file/d/1QhSBbGOIicV4QNit7Umb4k03cm-VyQGD/view?usp=drive_link\n";
}
# Function to prompt user for file selection using file manager
function select_file() {
  local file=$(zenity --file-selection --title="Select .tar.xz File" --file-filter="*.tar.xz" --separator="|" 2>/dev/null)
  echo "$file"
}

# Function to extract the file with progress indicator
function extract_file() {
  local file=$1
  echo "Extracting $file..."
  tar -xf "$file" -C ~/Android --checkpoint=.100
  echo "Extraction completed."
}

# Function to display the animation
function show_animation() {
  local pid=$1
  local delay=0.1
  local spin='-\|/'
  local count=0

  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spin#?}
    printf " [%c] %3d%%" "$spin" "$count"
    local spin=$temp${spin%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    ((count++))
    if [ $count -eq 101 ]; then
      count=0
    fi
  done
  printf "    \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
}


# Function to set the path variable in the .bashrc file
function set_path_variable() {
  # Path to be set in a bashrc
  path_value="
# Flutter Setup By AR Rahman
export PATH=\"\$PATH:\$HOME/Android/flutter/bin\"
export ANDROID_HOME=\"\$HOME/Android/Sdk\"
export ANDROID_TOOLS=\"\$HOME/Android/Sdk/cmdline-tools/latest\"
export ANDROID_PLATFORM_TOOLS=\"\$HOME/Android/Sdk/platform-tools\"
PATH=\"\$PATH:\$ANDROID_HOME:\$ANDROID_TOOLS:\$ANDROID_PLATFORM_TOOLS\"
# Chrome Setup
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
"

  echo "Do you want to set the path variable in .bashrc? [y/n]"
  read choice

  if [[ $choice == "y" || $choice == "Y" ]]; then
  
    echo "$path_value" >> ~/.bashrc
    echo
    echo "Path variable set in .bashrc!"
    success
  fi
}


# Function to set the path variable in the .bashrc file
function select_distro() {
  # Prompt user with options
echo "Now Please select your preferred Linux distribution:"
echo "1. Arch"
echo "2. Debian"

# Read user's choice
read choice

# Perform actions based on user's choice
case $choice in
  1)
    echo "You selected Arch. Performing Arch-specific actions..."
    # Actions specific to Arch Linux
    install_java_arch
    ;;
  2)
    echo "You selected Debian. Performing Debian-specific actions..."
    # Actions specific to Debian-based distributions
    install_java_debian
    ;;
  *)
    echo "Invalid choice. Exiting..."
    exit 1
    ;;
esac
}
# Function to install Java OpenJDK 17
function install_java_debian() {
  echo "Do you want to install Java OpenJDK 17 on Debian? [y/n]"
  read choice

  if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Installing Java OpenJDK 17..."
    sudo apt-get update >/dev/null 2>&1
    sudo apt-get install -y openjdk-17-jdk >/dev/null 2>&1 &
    local pid=$!
    show_animation $pid
    wait $pid
    echo "Java OpenJDK 17 installed!"
    install_linuxSDK_on_debian
  fi
}
# Function to install Java OpenJDK 17
function install_java_arch() {
  echo "Do you want to install Java OpenJDK 17 on Arch? [y/n]"
  read choice

  if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Installing Java OpenJDK 17..."
    sudo apt-get update >/dev/null 2>&1
    sudo apt-get install -y openjdk-17-jdk >/dev/null 2>&1 &
    local pid=$!
    show_animation $pid
    wait $pid
    echo "Java OpenJDK 17 installed!"
    install_linuxSDK_on_arch
  fi
}
# Function to install CMake and Ninja on Arch Linux
function install_linuxSDK_on_arch() {
  echo "Installing CMake and Ninja Etc. on Arch Linux..."
  sudo pacman -Syu --noconfirm cmake ninja >/dev/null 2>&1 &
  local pid=$!
  show_animation $pid
  wait $pid
  echo "CMake and Ninja installed!"
}

# Function to install CMake and Ninja on Debian-based distributions
function install_linuxSDK_on_debian() {
  echo "Installing CMake and Ninja Linux Toolchain on Debian..."
  sudo apt update >/dev/null 2>&1
  sudo apt install -y cmake ninja-build adb clang libgtk-3-dev git >/dev/null 2>&1 &
  local pid=$!
  show_animation $pid
  wait $pid
  echo "CMake and Ninja installed!"
}
# Function to prompt user to select the Flutter file using the file manager
function select_flutter_file() {
 # Prompt user for file selection
  echo "Do you want to select a Flutter*.tar.xz file? [y/n]"
  read choice

  if [[ $choice == "y" || $choice == "Y" ]]; then
    # Open file manager for file selection
    file=$(select_file)
    
    if [[ -z $file ]]; then
      echo "No file selected. Exiting..."
      exit 1
    fi

    # Extract the file with progress indicator
    extract_file "$file"
  else
    echo "Exiting..."
    exit 0
  fi
}
function select_sdk(){
# Prompt user for file selection
  echo "Do you want to select Sdk.tar.xz file? [y/n]"
  read choice

  if [[ $choice == "y" || $choice == "Y" ]]; then
    # Open file manager for file selection
    file=$(select_file)
    
    if [[ -z $file ]]; then
      echo "No file selected. Exiting..."
      exit 1
    fi

    # Extract the file with progress indicator
    extract_file "$file"
  else
    echo "Exiting..."
    exit 0
  fi

}
# Function to display clickable link
function display_link() {
  local url=$1
  local text=$2
  echo -e "\e]8;;${url}\e\\${text}\e]8;;\e\\"
}

#Start Setup
function start(){

# Create the extraction folder if it doesn't exist
mkdir -p "$HOME/Android"
# Prompt user to select the Flutter file again
select_flutter_file
# Prompt user to select the SDK file
select_sdk
# Prompt user to install Java OpenJDK 17
select_distro
# Prompt user to set path variable
set_path_variable
}
function auto(){
echo
echo
printf "\e[1;35mAuto Downloading Flutter:\n\n\n"
URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.2-stable.tar.xz"
DOWNLOAD_LOCATION="/tmp/flutter.tar.xz"
EXTRACTION_LOCATION="$HOME/Android"

# Function to display the loading animation
function show_loading_animation() {
    local -r chars="/-\|"
    while :; do
        for (( i=0; i<${#chars}; i++ )); do
            sleep 0.1
            echo -en "${chars:$i:1}" "\r"
        done
    done
}

# Create the extraction folder if it doesn't exist
mkdir -p "$EXTRACTION_LOCATION"

# Download the tar file with progress indicator
echo "Flutter Downloading..."
curl --progress-bar "$URL" --output "$DOWNLOAD_LOCATION" &

# Start the loading animation
show_loading_animation &

# Store the PID of the loading animation process
LOADING_ANIMATION_PID=$!

# Wait for the download to complete
wait

# Stop the loading animation process
kill "$LOADING_ANIMATION_PID"

# Extract the downloaded tar file
echo "Extracting..."
tar -xf "$DOWNLOAD_LOCATION" -C "$EXTRACTION_LOCATION"

# Cleanup: remove the downloaded tar file
rm "$DOWNLOAD_LOCATION"

echo "Flutter Setup complete."
# Prompt user to select the SDK file
select_sdk
# Prompt user to install Java OpenJDK 17
select_distro
# Prompt user to set path variable
set_path_variable
}
#On Success
function success() {
    # Print final message in orange color
    printf "\e[1;33mManually Install: \e[1;34mVisual Studio Code\e[1;33m & \e[1;34mGoogle Chrome\n"
    echo -e "\n\e[33mYour workstation is ready for Flutter development! Reboot and Enjoy!!!\e[0m"
    printf "\e[1;34mHappy Coding\n\n"
}


# Display Flutter text and additional information
if [[ $1 == "--help" ]]; then
  show_help
  exit 0
fi
if [[ $1 == "--link" ]]; then
 link
  exit 0
fi
if [[ $1 == "--auto" ]]; then
 auto
 exit 0
fi
echo 
echo
# Display Flutter text and additional information
echo -e "\e[1mFlutterFast Easy Installer\e[0m"
echo "Install Flutter Easily on Any Linux (Debian, Arch)"
intro
echo -e "\e[1m==============================================\e[0m"
#start the setup function
start

