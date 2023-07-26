# railroad

Welcome to Railroad. A repository with Ansible playbooks and roles to configure a Ubuntu 20.04 server with a Rails 7 environment (Rbenv, Nginx, LetsEncrypt/TLS, Unicorn, and Postgres).

## Usage Notes
### Idempotency

The `build.yml` playbook, as currently set up, is not idempotent. The most effective way to utilize this playbook is through tag slicing. For instance, to update the nginx config for the Rails app, run `ansible-playbook -i inventory/production playbooks/build.yml -v --diff --tags=nginx-site-config`.

To achieve idempotency, you can move the destructive roles into a separate playbook. The prime candidates for this move would be the `nginx-reverse-proxy` and `nginx-certbot` roles. Further implementing logic to determine when to reload a service, rather than restarting it, could also improve idempotency.

### Deployment
#### Preparing SSH-Agent
Ensure ssh-agent is operational by running:
```
pkill ssh-agent && eval `ssh-agent` && ssh-add ~/.ssh/id_rsa.
```

Update your `.ssh/config` to enable *KeyForwarding* to your host. See [GitHub's SSH agent forwarding guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/using-ssh-agent-forwarding).

#### Running Ansible
After configuring the project, run the `ansible-playbook` command to apply the roles and confgs to the production server.

```sh
ansible-playbook -i inventory/production playbooks/build.yml -v --diff
```

## Installation and Configuration
### Installing Ansible
1. Create a local Python virtual environment with `make venv`.
1. Activate the environment using `source venv/bin/activate`.
1. Install Ansible and its dependencies with `make install`.

### Handling Secrets with Ansible Vault
This project uses [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html) to store secrets and keys.

1. With the virtual environment active, `run ENV=production make ansible_vaults` to set up the Ansible Vault password and create empty vault files.
1. Generate a secret key with `bin/rails secret` from a Rails app root directory. Assign this to `v_secret_key_base` in your vault.
1. Generate a random password for PostgreSQL database access and assign to `v_app_db_user_password`.

#### Certbot Variables Configuration
1. Replace `1.1.1.1` in `inventory/production` with your server's IP.
1. Set `server_name` to your domain in `inventory/group_vars/production/vars.yml`. Ensure DNS entry matches IP above.
1. Assign `admin_email` to your email where LetsEncrypt will send expiry notifications.

#### SSH Keys Configuration
1. Update `ssh_key` for rails user in `inventory/group_vars/production/vars.yml` with your public SSH key.
1. Replace _shey_ with your preferred login username and update the `ssh_key`.

### Caution
1. Always protect your host with a firewall.
1. The method for handling secrets is best suited for a one or two-person team.
1. The `build.yml` playbook is not idempotent.
