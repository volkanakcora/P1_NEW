                          'Examining the Ansible Role Structure'

The following tree command displays the directory structure of the user.example role.

[user@host roles]$ tree user.example
user.example/
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml


                             'Defining Variables and Defaults'

  Role variables are defined by creating a vars/main.yml file with key: value pairs in the role directory hierarchy. They are referenced in the role YAML file like any other variable: {{ VAR_NAME }}. These variables have a high precedence and 
  can not be overridden by inventory variables. The intent of these variables is that they are used by the internal functioning of the role.

'Using Ansible Roles in a Playbook'

Using roles in a playbook is straightforward. The following example shows one way to call Ansible roles.

---
- hosts: remote.example.com
  roles:
    - role1
    - role2



When you use a roles section to import roles into a play, the roles will run first, before any tasks that you define for that play.


'The following example sets values for two role variables of role2, var1 and var2. Any defaults and vars variables are overridden when role2 is used.'

---
- hosts: remote.example.com
  roles:
    - role: role1
    - role: role2
      var1: val1
      var2: val2
Another equivalent YAML syntax which you might see in this case is:

---
- hosts: remote.example.com
  roles:
    - role: role1
    - { role: role2, var1: val1, var2: val2 }


                                    'Controlling Order of Execution'

    When a role is added to a play, role tasks are added to the beginning of the tasks list. If a second role is included in a play, its 
    tasks list is added after the first role.

Role handlers are added to plays in the same manner that role tasks are added to plays. Each play defines a handlers list. 
Role handlers are added to the handlers list first, followed by any handlers defined in the handlers section of the play.


'Plays also support a post_tasks keyword. These tasks execute after the plays normal tasks, and any handlers they notify, are run.'

The following play shows an example with pre_tasks, roles, tasks, post_tasks and handlers. It is unusual that a play would contain all of these sections.

- name: Play to illustrate order of execution
  hosts: remote.example.com
  pre_tasks:
    - debug:
        msg: 'pre-task'
      notify: my handler
  roles:
    - role1
  tasks:
    - debug:
        msg: 'first task'
      notify: my handler
  post_tasks:
    - debug:
        msg: 'post-task'
      notify: my handler
  handlers:
    - name: my handler
      debug:
        msg: Running my handler


 Roles can be added to a play using an ordinary task, not just by including them in the roles section of a play. Use the include_role module to dynamically include a role, and use the import_role module to statically import a role.

The following playbook demonstrates how a role can be included using a task with the include_role module.

- name: Execute a role as a task
  hosts: remote.example.com
  tasks:
    - name: A normal task
      debug:
        msg: 'first task'
    - name: A task to include role2 here
      include_role: role2