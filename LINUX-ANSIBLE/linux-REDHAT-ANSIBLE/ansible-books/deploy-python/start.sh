#!/bin/bash
ansible-playbook deploy_python_app.yml -e "ansible_sudo_pass=pass123"

