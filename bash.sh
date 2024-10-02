#Run playbook for cor
ansible-playbook playbooks/deploy_xbcor.yml --tags monitoring --limit 'xb-xbid-$1-cor*'
if [ $? -ne 0 ]; then
  echo "deploy_xbcor.yml failed."
  exit 1
fi

#Run aybook for deploy_xbcmi
ansible-playbook playbooks/deploy_xbcmi.yml --tags monitoring --limit 'xb-xbid-$1-cmi*'
if [ $? -ne 0 ]; then
  echo "deploy_xbcmi.yml failed."
  exit 1
fi

# Run playbook for deploy_xbcmm
ansible-playbook playbooks/deploy_xbcmm.yml --tags monitoring --limit 'xb-xbid-$1-cmm*'
if [ $? -ne 0 ]; then
  echo "deploy_xbcmm.yml failed."
  exit 1
fi

# Run playbook for deploy_xbenq
ansible-playbook playbooks/deploy_xbenq.yml --tags monitoring --limit 'xb-xbid-$1-sob*'
if [ $? -ne 0 ]; then
  echo "deploy_xbenq.yml failed."
  exit 1
fi



# Run playbook for deploy_xbsmc
ansible-playbook playbooks/deploy_xbsmc.yml --tags monitoring --limit 'xb-xbid-$1-smc*'
if [ $? -ne 0 ]; then
  echo "deploy_xbsmc.yml failed."
  exit 1
fi


# Run playbook for deploy_xbsloth
ansible-playbook playbooks/deploy_xbsloth.yml --tags monitoring --limit 'xb-xbid-$1-sloth-timescale*' -e 'app_version=1'
if [ $? -ne 0 ]; then
  echo "deploy_xbsloth.yml failed."
  exit 1
fi

echo "All playbooks executed successfully."