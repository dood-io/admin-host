# -*- mode: ruby -*-
# vi: set ft=ruby :

##################################################################################################
#  box settings
##################################################################################################

$server_cpus              = File.readlines("vagrantconf/CPU_CORES").first.strip        # cores
$server_memory            = File.readlines("vagrantconf/RAM_MB").first.strip           # mb
$os_image                 = File.readlines("vagrantconf/OS").first.strip               # os box name
$domain                   = File.readlines("vagrantconf/DOMAIN").first.strip           # tld name
$vm_list_prefix           = File.readlines("vagrantconf/VM_LIST_PREFIX").first.strip   # box prefix name for virtualization software
$ip_address               = File.readlines("vagrantconf/IP_ADDR").first.strip          # static private ip address
$ansible_roles_local_dir  = File.readlines("vagrantconf/ROLES_PATH").first.strip       # mounted directory for external roles
$hostname                 = File.readlines("vagrantconf/HOSTNAME").first               # set a static hostname (optional)




##################################################################################################
#  hostname
##################################################################################################

# https://github.com/thepug/vagrant-dev-box/blob/master/Vagrantfile
# https://github.com/joemaller/vagrant-dev-box/blob/master/Vagrantfile

# if no hostname set, use the sanitized name of the Vagrantfile's current directory
if $hostname.to_s.strip.length == 0
    $hostname = File.basename(File.dirname(File.expand_path(__FILE__))).downcase.gsub(/[^a-z0-9]+/,'-').gsub(/^-+|-+$/,'')
else
    $hostname = $hostname.strip
end

# use "vagrant" if that fails
$hostname = "vagrant" if $hostname.empty?

# add a domain to the hostname
$hostname = $hostname.gsub(/(#{$domain})*$/, '') + $domain




##################################################################################################
#  hostname
##################################################################################################

# https://github.com/thepug/vagrant-dev-box/blob/master/Vagrantfile
# https://github.com/joemaller/vagrant-dev-box/blob/master/Vagrantfile

# if no hostname set, use the sanitized name of the Vagrantfile's current directory
$hostname ||= File.basename(File.dirname(File.expand_path(__FILE__))).downcase.gsub(/[^a-z0-9]+/,'-').gsub(/^-+|-+$/,'')
# use "vagrant" if that fails
$hostname = "vagrant" if $hostname.empty?
# add a domain to the hostname
$hostname = $hostname.gsub(/(#{$domain})*$/, '') + $domain




##################################################################################################
#  preferred network interface
##################################################################################################

# http://stackoverflow.com/a/17729961/503463
# pref_interface is an array of adapters in preferred order
# vm_interfaces is a list of available interfaces
# we reduce pref_interface against vm_interfaces and go with the first remaining network
# if no networks match, fallback to the first listed result
pref_interface = [
    'en0: Ethernet', 'en1: Ethernet', 'en2: Ethernet', 'en3: Ethernet', 'en4: Ethernet', 'en5: Ethernet', 'en6: Ethernet',
    'en0: Display Ethernet', 'en1: Display Ethernet', 'en2: Display Ethernet', 'en3: Display Ethernet', 'en4: Display Ethernet', 'en5: Display Ethernet', 'en6: Display Ethernet',
    'en0: USB Ethernet', 'en1: USB Ethernet', 'en2: USB Ethernet', 'en3: USB Ethernet', 'en4: USB Ethernet', 'en5: USB Ethernet', 'en6: USB Ethernet',
    'en0: Wi-Fi (AirPort)', 'en1: Wi-Fi (AirPort)', 'en2: Wi-Fi (AirPort)', 'en3: Wi-Fi (AirPort)', 'en4: Wi-Fi (AirPort)', 'en5: Wi-Fi (AirPort)', 'en6: Wi-Fi (AirPort)'
]
vm_interfaces = %x( VBoxManage list bridgedifs | grep ^Name ).gsub(/Name:\s+/, '').split("\n")
pref_interface = vm_interfaces.map {|n| n if pref_interface.include?(n)}.compact
$network_interface = pref_interface[0] || false

if $network_interface
    puts ""
    puts "******************************************************************************"
    puts "*  public_network will be bridged to   ==>  #{$network_interface}"
    puts "*                          cpu cores   ==>  #{$server_cpus}"
    puts "*                           ram (mb)   ==>  #{$server_memory}"
    puts "*                           hostname   ==>  #{$hostname}"
    puts "*                            ip addr   ==>  #{$ip_address}"
    puts "*                                 os   ==>  #{$os_image}"
    puts "******************************************************************************"
    puts ""
end




##################################################################################################
#  main
##################################################################################################

Vagrant.configure("2") do |config|

  # ---------------------------------------------------------
  #  hostname
  # ---------------------------------------------------------

  config.vm.hostname = $hostname

  if Vagrant.has_plugin? 'vagrant-hostsupdater'
    config.hostsupdater.remove_on_suspend = true
#    config.hostsupdater.aliases = [$hostname + $domain]
  end


  # ---------------------------------------------------------
  #  network
  # ---------------------------------------------------------

  # Specifying :bridge with our preferred network lets Vagrant skip
  # "What interface should the network bridge to?" when spinning up the VM
  config.vm.network "public_network", :bridge => $network_interface
  config.vm.network "private_network", ip: $ip_address

  config.ssh.forward_agent = true



  # ---------------------------------------------------------
  #  synced folders
  # ---------------------------------------------------------

  if File.directory?(File.expand_path($ansible_roles_local_dir))
    config.vm.synced_folder $ansible_roles_local_dir, "/ansible-roles"
  end



  # ---------------------------------------------------------
  #  virtualbox
  # ---------------------------------------------------------

  config.vm.provider :virtualbox do |vb|
    config.vm.box = $os_image

    # v.gui = true  # for debugging
    vb.name = $vm_list_prefix + $hostname
    vb.memory = $server_memory
    vb.cpus = $server_cpus

    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # make NAT engine use host's resolver mechanisms to handle DNS requests
#    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 5000]
  end



  # ---------------------------------------------------------
  #  ssh keys
  # ---------------------------------------------------------

  authorized_keys = [
    "#{Dir.home}/.ssh/id_rsa.pub",
    "#{Dir.home}/.ssh/id_dsa.pub",
  ]

  for key_file in authorized_keys
    begin
      ssh_public_key = File.readlines(key_file).first.strip

      config.vm.provision "shell" do |s|
        s.inline = <<-SHELL
          (sudo test -f /home/vagrant/.ssh/authorized_keys \
            && sudo grep "#{ssh_public_key}" /home/vagrant/.ssh/authorized_keys >/dev/null) \
            || (echo "#{ssh_public_key}" | sudo tee -a /home/vagrant/.ssh/authorized_keys)
        SHELL

      end
    rescue
      # ignore, key file doesn't exist
    end
  end



  # ---------------------------------------------------------
  #  provisioning
  # ---------------------------------------------------------

  config.vm.provision "shell", path: "vagrantconf/script_ansible.sh"
  config.vm.provision "shell", path: "vagrantconf/script_provision.sh"

  # vagrant ansible docs: https://www.vagrantup.com/docs/provisioning/ansible_common.html
  # provision with ansible_local - https://www.vagrantup.com/docs/provisioning/ansible_local.html
  config.vm.provision "ansible_local" do |ansible|
    ansible.provisioning_path     = "/vagrant/provisioning"
    ansible.inventory_path        = "/etc/ansible/hosts"

    ansible.install               = true
    ansible.install_mode          = :pip

    ansible.playbook              = "provision.yml"
    ansible.verbose               = "v"
    ansible.limit                 = "admin-host"
#    ansible.tags                  = []
#    ansible.skip_tags             = []

#    ansible.vault_password_file   = ".vault.pass"

    # NOTE: comment this "ansible.galaxy_command" line to force all roles to be force downloaded
    ansible.galaxy_command        = "ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path}"
    ansible.galaxy_role_file      = "galaxy-requirements.yml"
    ansible.galaxy_roles_path     = "/opt/ansible/roles"
  end

end
