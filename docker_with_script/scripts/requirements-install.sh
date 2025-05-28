#!/bin/bash

detect_distro(){
	if [ -f /etc/os-release ]
	then
		. /etc/os-release
		DISTRO=$ID
	elif [ -f /etc/lsb-release ]
	then
		. /etc/lsb-release
		DISTRO=$DISTRIB_ID
	else
		echo -e "\n\nWarning! Could not detect distro. Install the packages manually and run the program again with the option '--no-detect-distro'"
		exit 1
	fi
}


# Some of the following functions are not used by the build process of the container. Container is based on latest Ubuntu LTS.

install_debian_pkg(){
	sudo apt update
	sudo apt install -y clang-15 clang-format-15 libc++-15-dev cmake libssl-dev libc++abi-15-dev wget curl jq xz-utils
}

install_ubuntu_pkg(){
	sudo apt update
	sudo apt install -y clang clang-format libc++-dev cmake libssl-dev libc++abi-dev wget curl jq xz-utils
}

install_fedora_pkg(){
	sudo dnf install -y clang libcxx-devel cmake openssl-devel wget curl jq xz-utils
}

install_opensuse_pkg(){
	sudo zypper ref
	sudo zypper in -y clang cmake extra-cmake-modules openssl-devel wget curl jq xz-utils
}

install_error_handling(){
	if [ $? != 0 ]
	then
		echo -e "\nSomething went wrong. Review the output and check if the dependencies are satisfied. If not, try installing them manually"
		exit 1
	fi
}

detect_distro
echo -e "\n\nDetected distro:  $DISTRO.\n\n"

# Some of the following are not used by the docker build process but are here because the same code is used to build without a container
case $DISTRO in
	debian|Debian)
		install_debian_pkg
		install_error_handling
		;;
	ubuntu|Ubuntu)
		install_ubuntu_pkg
		install_error_handling
		;;
	fedora|Fedora)
		install_fedora_pkg
		install_error_handling
		;;
	opensuse-leap)
		install_opensuse_pkg
		install_error_handling
		;;
	--no-detect-distro)
		echo -e "\n\nNo packages will be installed. Make sure dependencies are satisfied"
		;;
	*)
		echo -e "\n\nCould not determine the OS or you're running a distro that is not supported by the script.
The distro supported for now are: Debian, Ubuntu, Fedora and openSUSE.
Visit the Azahar Github (https://github.com/azahar-emu/azahar and https://github.com/azahar-emu/azahar/wiki/Building-From-Source) to find information on how to compile it yourself. This is just a script to automate the process and it's in no way affiliated with the Azahar project.\n\nQuitting..."
		exit 1
		;;
esac
