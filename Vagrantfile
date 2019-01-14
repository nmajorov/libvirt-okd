# -*- mode: ruby -*-
# vi: set ft=ruby :

#define how many nodes in OpenShift cluster
MASTERS=1
INFRAS=1
APPS=3


LABEL_PREFIX="okd-"

MEMORY=2048

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

   # Private network using virtual network switching
  config.vm.define :bastion do |bastion|
    bastion.vm.box = "centos/7"
    bastion.vm.hostname="bastion"
   # bastion.vm.network :private_network, 
    #:ip => "10.20.30.40",
    
    #:libvirt__network_name => "okd"

    #:libvirt__domain_name => "niko.io"
    #bastion.vm.network :private_network,
    #        :ip => "192.168.122.100",
    #        :libvirt__network_name => "default"  # leave it
    
    config.vm.provider :libvirt do |libvirt|
        libvirt.memory = 2048
        libvirt.cpus = 2
        libvirt.cpu_mode = 'host-passthrough'
        libvirt.management_network_name="okd"
    end

    #set private key 
    config.vm.provision "shell" do |s|  
      my_key_file = File.readlines(Dir.pwd + "/id_key.pub").first.strip     
      s.inline = "echo  #{my_key_file} >> /home/vagrant/.ssh/authorized_keys"    
         
    end

   end


    # masters configration
    (0..MASTERS - 1).each do |i|
        config.vm.define "#{LABEL_PREFIX}master#{i}" do |master|
          master.vm.hostname = "#{LABEL_PREFIX}master#{i}"
          master.vm.box = "centos/7"
          #if ASSIGN_STATIC_IP
            #master.vm.network :private_network,
            #  ip: "#{PUBLIC_SUBNET}.3#{i}"
          #end
          # Virtualbox
          #mgr.vm.provider :virtualbox do |vb|
          #  vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
          #end
    
       
          
          # Libvirt
          master.vm.provider :libvirt do |lv|
            if MASTERS == 1
              lv.memory = 3 * MEMORY
            else
              lv.memory = MEMORY
            end 
            #lv.random_hostname = true
            lv.cpus = 2
            lv.management_network_name="okd"
      
          end

        end

        #set private key 
        config.vm.provision "shell" do |s|  
          my_key_file = File.readlines(Dir.pwd + "/id_key.pub").first.strip     
          s.inline = "echo  #{my_key_file} >> /home/vagrant/.ssh/authorized_keys"    
            
         end

      end


    # infra nodes configration
    (0..INFRAS - 1).each do |i|
      config.vm.define "#{LABEL_PREFIX}infra#{i}" do |infra|
        infra.vm.hostname = "#{LABEL_PREFIX}infra#{i}"
        infra.vm.box = "centos/7"
        #if ASSIGN_STATIC_IP
          #master.vm.network :private_network,
          #  ip: "#{PUBLIC_SUBNET}.3#{i}"
        #end
        # Virtualbox
        #mgr.vm.provider :virtualbox do |vb|
        #  vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
        #end
  
     
        
        # Libvirt
        infra.vm.provider :libvirt do |lv|
          if INFRAS == 1
            lv.memory = 2 * MEMORY
          else
            lv.memory = MEMORY
          end 
          #lv.random_hostname = true
          lv.cpus = 2
          lv.management_network_name="okd"
    
        end

      end

      #set private key 
      config.vm.provision "shell" do |s|  
        my_key_file = File.readlines(Dir.pwd + "/id_key.pub").first.strip     
        s.inline = "echo  #{my_key_file} >> /home/vagrant/.ssh/authorized_keys"    
          
       end

    end



     # app nodes configration
     (0..APPS - 1).each do |i|
      config.vm.define "#{LABEL_PREFIX}app#{i}" do |app|
        app.vm.hostname = "#{LABEL_PREFIX}app#{i}"
        app.vm.box = "centos/7"
        #if ASSIGN_STATIC_IP
          #master.vm.network :private_network,
          #  ip: "#{PUBLIC_SUBNET}.3#{i}"
        #end
        # Virtualbox
        #mgr.vm.provider :virtualbox do |vb|
        #  vb.customize ['modifyvm', :id, '--memory', "#{MEMORY}"]
        #end
  
     
        
        # Libvirt
        app.vm.provider :libvirt do |lv|
          lv.memory = MEMORY*2 
          #lv.random_hostname = true
          lv.cpus = 2
          lv.management_network_name="okd"
          lv.storage :file, :size => '20G', :device => "vdb"

          lv.storage :file, :size => '20G', :device => "vdc"

          lv.storage :file, :size => '20G', :device => "vdd"
        end

      end

      #set private key 
      config.vm.provision "shell" do |s|  
        my_key_file = File.readlines(Dir.pwd + "/id_key.pub").first.strip     
        s.inline = "echo  #{my_key_file} >> /home/vagrant/.ssh/authorized_keys"    
          
       end

    end


   
 

end
