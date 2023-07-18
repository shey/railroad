# rails-ubuntu-ansible

Ansible Playbook+Roles Ansible Playbook + Roles to setup a Ubuntu 20.04 host for Rails 7(Rbenv, Niginx, Unicorn, Postgres)

## Getting Started
### Installing Ansible
1. Run `make venv`` to create a local python virtual env for ansible
1. With the environment activated, `source venv/bin/activate` run `make install` to install ansible and its dependencies.
1. Run `make password_file` to setup the encryption key for Ansible's vault files.
