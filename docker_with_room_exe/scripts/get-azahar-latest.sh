#!/bin/bash


#Import delle variabili necessaire
. /root/scripts/env_vars.conf

# if statement just to make sure that a path in which the archive has to be extracted is specified.
# It stops immediately the script execution to not waste time.
if [ -z "$source_file_dir" ]
then
        echo "No path has been specified. Please, specify the path where the source code has to be extracted by editing the 'env_vars.conf' file."
        exit 1
fi


# Info to build the repository URL. This make it modular so it can be adapted to other repository or if the repo will change name
REPO_OWNER="azahar-emu"
REPO_NAME="azahar"


# The following is needed to identify the tag of the release marked as "Latest" and then build URL to download the tarball.
# First, fetch the latest release tag
LATEST_RELEASE_TAG=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | grep -oP '"tag_name": "\K[^"]+')


# Second, build the URL to the page of the latest release. Here, we can find the ece for the different OS and the source code tarball
RELEASE_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/tags/$LATEST_RELEASE_TAG"


# Third, get all the URLS to download the files by doing a curl of the webpage of the release page
RELEASE_DETAILS=$(curl -s "$RELEASE_URL")


# Fourth, get only the URL to download the source code
FILE_URLS=$(echo "$RELEASE_DETAILS" | jq -r '.assets[] | select(.name | contains("unified-source") and endswith(".tar.xz")) | .browser_download_url')


# Download the file if the URL is found or give an error and exit
if [ -n "$FILE_URLS" ]
then
        echo "The URL to download the file is: $FILE_URLS"
#       wget "$FILE_URLS"
        wget -O azahar-unified-source.tar.xz "$FILE_URLS"
else
        echo "Could not find the file."
	exit 1
fi

# Prepare the environment to extract the files
mkdir -pv "$source_file_dir"

## It most likely downloaded even the .sha256 file but we dont need it. We are gonna remove it and rename the source code tarball
#SHA256_FILE=$(ls | grep .sha256$)
#SOURCE_CODE_TARBALL=$(ls | grep .tar.xz$)

#rm ${SHA256_FILE}
#mv ${SOURCE_CODE_TARBALL} azahar-unified-source.tar.xz

# Now that everything's ready, let's unpack the source code.
# I will include some checks to make sure that any error will be handled more elegantly but it's not strictly necessary.
if ! tar --strip-components=1 -xvf azahar-unified-source.tar.xz -C "$source_file_dir"
then
        echo -e "\n\nError during extraction. Check the output for any information about possible issues."
	exit 1
fi
