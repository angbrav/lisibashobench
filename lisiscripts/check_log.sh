#!/bin/bash

nodes=(`cat ./lisiscripts/$1`)
    
command="cat ./li-si/rel/antidote/log/console.log"
node="${nodes[$2]}"

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -t ubuntu@$node -i ~/ec2-saturn ${command/localhost/$node} &
