# digoc "Digital Ocean"

Running terraform requires...
1. a file `./personal-access-token-2021` used for API access that terraform exploits.
2. a file `./project_name.txt` used to reference the digital ocean project name.
3. a file `./.my_ssh_ip.txt` used to establish ip-white list for droplet networking.
4. running either `./runt.sh` *(short for run terraform)* or `./importt.sh` *(short for import terraform)*