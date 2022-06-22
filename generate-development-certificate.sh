#!/bin/bash
export MSYS_NO_PATHCONV=1 

useCurrentDirectory=false
skipCAImport=false
dir=$(pwd)

print_help () {
    echo "Description: "
    echo "  This is a simple script that creates a development certificate for local web development testing using HTTPS.\n\n"
    echo
    printf "Options\n"
    printf "%-30s ==> %-30s\n" "-f --filename [string]" "[string] will be the filename for the generated .pem and .key files."
    printf "%-30s ==> %-30s\n" "-d --directory [string]" "[string] will be the directory where the generated files will be stored. Directory wil be created if it does not exist. Cannot be used if --current is set."
    printf "%-30s ==> %-30s\n" "-c --current" "If set, the files will be stored in the current working directory. Cannot be used if --directory is set."
    printf "%-30s ==> %-30s\n" "-s --skip" "If set, the certificate will not be stored in the local user certificate authority."
    printf "%-30s ==> %-30s\n" "-h --help" "Print this exact help text."

}

for arg in "$@"; do
  shift
  case "$arg" in
    '--filename')   set -- "$@" '-f'   ;;
    '--directory') set -- "$@" '-d'   ;;
    '--current')   set -- "$@" '-c'   ;;
    '--skip')     set -- "$@" '-s'   ;;
    '--help')     set -- "$@" '-h'   ;;
    *)          set -- "$@" "$arg" ;;
  esac
done

while getopts ":f:d:csh" option; do
   case $option in
        f) # Filename Input
           filename=$OPTARG;;
        d) # Directory Input
            directory=$OPTARG;;
        c) #Store in current directory
            useCurrentDirectory=true;;
        s) # Skip adding to root certs
            skipCAImport=true;;
        h) # Print Help
            print_help;;
        \?) # Invalid option
            echo "Error: Invalid option ${OPTART}"
            print_help;;
        : ) echo "Error: Option ${OPTARG} requires an argument." >&2
            print_help;;
   esac
done

if $useCurrentDirectory && ! [[ -z "${directory// }" ]];
then
    echo "Error: Cannot use directory name option with current directory flag!"
    print_help
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
    certutil.exe -addstore -user -f root ./${filename}.pem || (printf "\n\nCertUtil failed to add the certificate to the store. Check out the error above, it might have some useful information. \n\n" && exit 1)
fi

exit 0