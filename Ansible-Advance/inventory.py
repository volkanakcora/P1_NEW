#!/usr/bin/evn

import json

def get_inventory_data():
    return {
        "databases": {
            "hosts": ["db_server"],
            "vars": {
                "ansible_ssh_pass": "Passw0rd",
                "ansible_ssh_host": "192.168.1.1"
            }
        },
        "web": {
            "hosts": ["web_server"],
            "vars": {
                "ansible_ssh_pass": "Passw0rd",
                "ansible_ssh_host": "192.168.1.1"
            }
        }
    }

# Default main funtion

if __name__=="__main__":
    inventory_data = get_inventory_data()
    print(json.dumps(inventory_data))           #### ansible-playbook playbook.yaml -i inventory.py



## ./ inventory.py --list:
" shows json format"

## ./ inventory.py --host web
"returns web credentials"