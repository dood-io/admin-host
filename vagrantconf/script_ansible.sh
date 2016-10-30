mkdir -p \
    /etc/ansible \
    /opt/ansible/roles \
    /var/log/ansible/hosts

chown -R vagrant:vagrant \
    /opt/ansible \
    /var/log/ansible/hosts

echo "localhost ansible_connection=local

[admin]
admin-host ansible_connection=local
" | tee /etc/ansible/hosts

cp /vagrant/provisioning/ansible.cfg /etc/ansible/ansible.cfg


# address ssl warnings due to letsencrypt certs:
#
#    ERROR! Unexpected Exception: Failed to validate the SSL certificate for galaxy.ansible.com.
#    Make sure your managed systems have a valid CA certificate installed.
#
apt-get install \
    -y -qq \
    python-pip

pip install \
    urllib3[secure]

