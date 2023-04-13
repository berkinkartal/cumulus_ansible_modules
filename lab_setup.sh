#! /bin/bash

NO_ARGS=0
E_OPTERROR=85
topo_folder=""
ref_backup_dir="backups/"
custom_backup_dir="backups2/"

Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-h|t|V]"
   echo "options:"
   echo "h     Print this Help."
   echo "t     Select topology | 1 : Layer2 stretch | 2 : Layer3 VRF stretch | 3 : Layer3 VRF stretch with route leaking"
   echo "r     Restore custom config from saved use case 1|2|3"
   echo "R     Restore selected use case 1|2|3 from Reference topology"
   echo "b     Backup custom config into use case 1|2|3"
   echo "v     Print software version and exit."
   echo
}

Restore()
{
echo "Restore custom config from $custom_backup_dir$topo_folder"
ansible-playbook -i inventories/backup/hosts --extra-vars my_variable=$custom_backup_dir$topo_folder restore.yml
}

Restore_reference()
{
echo "Restore reference config from $ref_backup_dir$topo_folder"
ansible-playbook -i inventories/backup/hosts --extra-vars my_variable=$ref_backup_dir$topo_folder restore.yml
}

Backup()
{
echo "Backup function for $custom_backup_dir$topo_folder"
ansible-playbook -i inventories/backup/hosts --extra-vars my_variable=$custom_backup_dir$topo_folder backup.yml
}

Save_reference()
{
echo "Save config function for reference config $ref_backup_dir$topo_folder"
ansible-playbook -i inventories/backup/hosts --extra-vars my_variable=$ref_backup_dir$topo_folder backup.yml
}

Topo_check()
{
#echo "Your topology argument:  $topology";
if [ $1 -eq "1" ] || [ $1 -eq "2" ] || [ $1 -eq "3" ]
then
        case "$1" in
                1) topo_folder="evpn_l2_dci_backups"
#                        echo "$topo_folder"
                        ;;
                2) topo_folder="evpn_l3_dci_backups"
#                        echo "$topo_folder"
                        ;;
                3) topo_folder="evpn_l3_dci_route-leaking"
#                        echo "$topo_folder"
                        ;;
        esac
else
        echo "Invalid topology"
fi
return 0
}

if [ $# -eq "$NO_ARGS" ]    # Script invoked with no command-line args?
then
  echo "Usage: `basename $0` options (-h|t|v|r|R|S|b)"
	Help
	exit $E_OPTERROR          # Exit and explain usage.
                            # Usage: scriptname -options
                            # Note: dash (-) necessary
fi  


while getopts "t:vrRbh" flag
do
	case "${flag}" in
		t) Topo_check ${OPTARG};;
		v) echo "version 1.0"
			exit;;
		h) # display Help
			Help
			exit;;
		r) Restore
			;;
		R) Restore_reference
			;;
		b) Backup
			;;
                S) Save_reference
                        ;;
		*) echo "Unimplemented option chosen."
			Help
			exit;;
	esac
done


exit 0
