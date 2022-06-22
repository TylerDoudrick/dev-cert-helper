# Dev Certificate Helper

Simple script that creates a development certificate for local web development testing using HTTPS.

I made this script to make it a little easier on myself whenever I need to generate a certificate instead of scouring Stack Overflow trying to find the exact command I used 6 months ago.

The generated certificate will have a subject of:

```
CN: localhost
OU: MyDivision
O: MyCompany
L: SomeCity
ST: SomeState
C: US
```

It will also add in a subject alt name of:

```
DNS: localhost
IP: 127.0.0.1
```

This configuration works well for me with the most recent security requirements for certificates when using Google Chrome and trying to store Cookies served from a server also running in the development environment. Don't use these anywhere other than local development :)

## How to use:

`./generate-development-certificate.sh`

Options:

`-f --filename [string]` -- [string] will be the filename for the generated .pem and .key files

`-d --directory [string]` -- [string] will be the directory where the generated files will be stored. Directory wil be created if it does not exist.

`-c --current` -- If set, the files will be stored in the current working directory

`-s --skip` -- If set, the certificate will not be stored in the local user certificate authority

`-h --help` -- Print the help text

### Example:

`./generate-development-certificate.sh --filename cert --directory certificates` -> Will generate cert.pem and cert.key in the ./certificates directory. The certificates directory will be created if it does not exist.
