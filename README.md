# Dev Certificate Helper

Simple script that creates a development certificate for local web development testing using HTTPS.

## How to use:

`./generate-development-certificate.sh`

Options:

`-f --filename [string]` -- [string] will be the filename for the generated .pem and .key files

`-d --directory [string]` -- [string] will be the directory where the generated files will be stored. Directory wil be created if it does not exist.

`-c --current` -- If set, the files will be stored in the current working directory

`-s --skip` -- If set, the certificate will not be stored in the local user certificate authority

`-h --help` -- Print the help text

Example:

`./generate-development-certificate.sh --filename cert --directory certificates` -> Will generate cert.pem and cert.key in the certificates directory. The certificates directory will be created if it does not exist.
