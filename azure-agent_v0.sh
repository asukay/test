#!/bin/bash

agent_folder="/data/dq/ms-agent"
if ! [ -d $agent_folder ];then
   mkdir $agent_folder -p
fi

chown ubuntu:ubuntu $agent_folder

config_serverurl="$1"
config_pat_token="$2"
config_agentname="$3"

if [ -z "${config_serverurl}" ];then
   echo "serverurl unset"
   exit 1
fi

if [ -z "${config_pat_token}" ];then
   echo "pat token unset"
   exit 1
fi

if [ -z "${config_agentname}" ];then
   echo "agent name unset"
   exit 1
fi

cd $agent_folder
wget https://vstsagentpackage.azureedge.net/agent/2.185.1/vsts-agent-linux-arm64-2.185.1.tar.gz
tar zxvf vsts-agent-linux-arm64-2.185.1.tar.gz

chmod +x $agent_folder -R

./bin/installdependencies.sh

apt upgrade -y

./config.sh --unattended --url $config_serverurl --auth pat --token $config_pat_token --pool "TeamBreak-DonutQuizz" --agent "$config_agentname" --acceptTeeEula 

chmod +x $agent_folder -R

./svc.sh install 


