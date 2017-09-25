# Ansible

Create inventory file `~/kurasuta_hosts` with the following content for example (using only one server as both master 
and satellite):

    [masters]
    kurasuta-master

    [satellites]
    kurasuta-master

Where you should make sure that kurasuta-master is reachable through ssh (via `~/.ssh/config` for example).

Clone this repository to `~/kurasuta/` and execute the main file with:

    ansible-playbook --inventory-file=~/kurasuta_hosts ~/kurasuta/site.yml --extra-vars "ansible_sudo_pass=YOURPASSWORD"
