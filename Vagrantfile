# project settings
project_name = "wordpress"
project_hostname = "wordpress.dev"
project_aliases = "www.#{project_hostname}"
project_managed_aliases = ["www.#{project_hostname}"]
project_root = "/var/www/app"
project_public = "#{project_root}/public"

# server settings
server_box = "bento/ubuntu-16.04"
server_ip = "192.168.50.100"
server_cpus = "1"
server_memory = "1024"
server_swap = "2048"

# vagrant config
Vagrant.configure(2) do |config|

    # server operating system
    config.vm.box = server_box

    # hostmanager plugin
    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.ignore_private_ip = false
        config.hostmanager.include_offline = false
        config.hostmanager.aliases = project_managed_aliases
    end

    # server networking
    if Vagrant.has_plugin?("vagrant-auto_network")
        config.vm.network :private_network, :ip => "0.0.0.0", :auto_network => true
    else
        config.vm.network :private_network, ip: server_ip
    end

    # server hostname and sync
    config.vm.hostname = project_hostname
    config.vm.synced_folder ".", project_root, id: "core", create: true

    # virtualbox setup
    config.vm.provider :virtualbox do |vb|
        vb.name = project_name
        vb.customize ["modifyvm", :id, "--cpus", server_cpus]
        vb.customize ["modifyvm", :id, "--memory", server_memory]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    # provisioning
    config.vm.provision :shell,
        inline: "apt-get install -y python"
    config.vm.provision :ansible do |ansible|
        ansible.playbook = "etc/provision/playbook.yml"
        ansible.limit = "all"
        ansible.groups = {
            "application"          => ["default"],
            "development:children" => ["application"]
        }
        ansible.extra_vars = {
            project_name: project_name,
            project_hostname: project_hostname,
            project_aliases: project_aliases,
            project_root: project_root,
            project_public: project_public,
            server_swap: server_swap
        }
    end

end
