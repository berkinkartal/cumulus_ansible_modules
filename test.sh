#! /bin/bash

NO_ARGS=0
E_OPTERROR=85
topo_folder=""

Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-h|t|V]"
   echo "options:"
   echo "h     Print this Help."
   echo "t     Select topology | 1 : Layer2 stretch | 2 : Layer3 VRF stretch | 3 : Layer3 VRF stretch with route leaking"
   echo "r     Restore selected topology"
   echo "b     Backup for selected topology"
   echo "v     Print software version and exit."
   echo
}

Restore()
{
echo "Restore function for $topo_folder"
}

Backup()
{
echo "Backup function for $topo_folder"
ansible-playbook -i inventories/backup/hosts --extra-vars my_variable=$topo_folder backup.yml
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
  echo "Usage: `basename $0` options (-h|t|v|r|b)"
	Help
	exit $E_OPTERROR          # Exit and explain usage.
                            # Usage: scriptname -options
                            # Note: dash (-) necessary
fi  


while getopts "t:vrbh" flag
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
		b) Backup
			;;
		*) echo "Unimplemented option chosen."
			Help
			exit;;
	esac
done

#echo "Your topology argument:  $topology";
#if [ $topology -eq "1" ] || [ $topology -eq "2" ] || [ $topology -eq "3" ]
#then
#	case "$topology" in
#		1) topo_folder="evpn_l2_dci_backups"
#			echo "$topo_folder"
#			;;
#		2) topo_folder="evpn_l3_dci_backups"
#			echo "$topo_folder"	
#			;;
#		3) topo_folder="evpn_l3_dci_route-leaking"
#			echo "$topo_folder"	
#			;;
#	esac
#else
#	echo "Invalid topology"
#fi

exit 0
