#!/bin/bash
export MSYS_NO_PATHCONV=1 

useCurrentDirectory=false
skipCAImport=false
dir=$(pwd)

for arg in "$@"; do
  shift
  case "$arg" in
    '--filename')   set -- "$@" '-f'   ;;
    '--directory') set -- "$@" '-d'   ;;
    '--current')   set -- "$@" '-c'   ;;
    '--skip')     set -- "$@" '-s'   ;;
    *)          set -- "$@" "$arg" ;;
  esac
done

while getopts ":f:d:cs" option; do
   case $option in
        f) # Filename Input
           filename=$OPTARG;;
        d) # Directory Input
            directory=$OPTARG;;
        c) #Store in current directory
            useCurrentDirectory=true;;
        s) # Skip adding to root certs
            skipCAImport=true;;
        \?) # Invalid option
            echo "Error: Invalid option ${OPTART}"
            exit 1;;
        : ) echo "Error: Option ${OPTARG} requires an argument." >&2
            exit 1;;
   esac
done

if $useCurrentDirectory && ! [[ -z "${directory// }" ]];
then
    echo "Error: Cannot use directory name option with current directory flag!"
    exit 1
fi

if [[ -z "${filename// }" ]]
then
    read -p 'Enter certificate & key filename [dev]: ' filename
    filename=${filename:-dev}
fi

if ! $useCurrentDirectory ;
    then
        # Get directory info if it was not provided as an option
        if [[ -z "${directory// }" ]];
            then
            echo "Where do you want to save the certificate?"

            printf "\n\nLeave blank for current directory\n\n"

            echo "Options: "
            echo "1) ./certificates"
            echo "2) ./certs"
            printf  "\n...or enter a folder name. It will be created if it does not exist.\n\n"
            
            read -p "Directory: " directory

            case $directory in
                1) # Filename Input
                directory="certificates";;
                2) # Directory Input
                directory="certs";;
                "") #Store in current directory
                directory="";;
            esac
            fi
fi

echo "Certificate will be saved in: $dir/$directory"

if ! [[ -z "${directory// }" ]]
    then
        echo "Creating ${directory} directory if it does not exist..."
        mkdir -p "${directory}"
        cd "${directory}"
    fi

echo "Generating certificates..."

openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout ./${filename}.key -out ./${filename}.pem -subj '/CN=localhost/OU=MyDivision/O=MyCompany/L=SomeCity/ST=SomeState/C=US' -addext 'subjectAltName=DNS:localhost,IP:127.0.0.1'

if $skipCAImport;
then
    echo "Skipping import into local Certificate Authority"
else
    certutil.exe -addstore -user -f root ./${filename}.pem 
fi