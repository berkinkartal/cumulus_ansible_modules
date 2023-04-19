#! /bin/bash

NO_ARGS=0
E_OPTERROR=85
topo_folder=""
test_usecase=""
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
   echo "p     Run tests for use case 1|2|3"
   echo "C     Clean all switch configs"
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

Cleanup()
{
echo "Clean up all switch configs"
ansible-playbook -i inventories/backup/hosts cleanup/main.yaml
}

Topo_check()
{
#echo "Your topology argument:  $topology";
if [ $1 -eq "1" ] || [ $1 -eq "2" ] || [ $1 -eq "3" ]
then
        case "$1" in
                1) topo_folder="evpn_l2_dci_backups"
                        test_usecase=1
#                        echo "$topo_folder"
                        ;;
                2) topo_folder="evpn_l3_dci_backups"
                        test_usecase=2
#                        echo "$topo_folder"
                        ;;
                3) topo_folder="evpn_l3_dci_route-leaking"
                        test_usecase=3
#                        echo "$topo_folder"
                        ;;
        esac
else
        echo "Invalid topology"
fi
return 0
}


Run_tests()
{
#echo "Your topology argument:  $topology";
if [ $test_usecase -eq "1" ] || [ $test_usecase -eq "2" ] || [ $test_usecase -eq "3" ]
then
        case "$test_usecase" in
                1) echo "Running tests for evpn_l2_dci_backups"
                        # ping from server01 to server03
                        ansible server01 -a 'ping -I 192.168.1.10 -c 4 192.168.1.110'
                        # Display ARP table on server01
                        ansible server01 -a 'arp -an'
                        # ping from server02 to server04
                        ansible server02 -a 'ping -I 192.168.2.10 -c 4 192.168.2.110'
                        # Display ARP table on server02
                        ansible server02 -a 'arp -an'

                        ;;
                2) echo "Running tests for evpn_l3_dci_backups"
                        # ping from server01 to server03
                        ansible server01 -a 'ping -I 192.168.1.10 -c 4 192.168.10.110'
                        # Display ARP table on server01
                        ansible server01 -a 'arp -an'
                        # ping from server02 to server04
                        ansible server02 -a 'ping -I 192.168.2.10 -c 4 192.168.20.110'
                        # Display ARP table on server02
                        ansible server02 -a 'arp -an'
                        ;;
                3) echo "Running tests for evpn_l3_dci_route-leaking"
                        # ping from server01 to server03
                        ansible server01 -a 'ping -I 192.168.1.10 -c 4 192.168.10.110'
                        # Display routing table on leaf01 for vrf RED
                        ansible leaf01 -a 'net show route vrf RED'
                        # ping from server02 to server04
                        ansible server02 -a 'ping -I 192.168.2.10 -c 4 192.168.20.110'
                        # Display ARP table on server02
                        # ansible server02 -a 'arp -an'
                        # ping from server01 to server02
                        ansible server01 -a 'ping -I 192.168.1.10 -c 4 192.168.2.10'
                        # Display routing table on leaf03 for vrf RED
                        ansible leaf03 -a 'net show route vrf RED'
                        # ping from server02 to server03
                        ansible server02 -a 'ping -I 192.168.2.10 -c 4 192.168.10.110'
                        # Display ARP table on server02
                        # ansible server02 -a 'arp -an'
                        ;;
        esac
else
        echo "Invalid Test topology"
fi
return 0
}

if [ $# -eq "$NO_ARGS" ]    # Script invoked with no command-line args?
then
  echo "Usage: `basename $0` options (-h|t|v|r|R|S|C|p|b)"
	Help
	exit $E_OPTERROR          # Exit and explain usage.
                            # Usage: scriptname -options
                            # Note: dash (-) necessary
fi  


while getopts "t:vrRSCpbh" flag
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
                p) Run_tests
                        ;;
                C) Cleanup
                        ;;
		*) echo "Unimplemented option chosen."
			Help
			exit;;
	esac
done


exit 0
