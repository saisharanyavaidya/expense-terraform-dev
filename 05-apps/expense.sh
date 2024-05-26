#!/bin/bash
##--------Below code calls ansible-expense-roles folder and executes backend and frontend projects in Ansible server which means it connects to backend and frontend ec2 instances and will setup expense project
# user data will get sudo access
dnf install ansible -y
cd /tmp
git clone https://github.com/saisharanyavaidya/ansible-expense-roles.git
cd ansible-expense-roles
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend