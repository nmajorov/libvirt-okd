#!/usr/bin/env ruby

# @author Nikolaj Majorov
# create Ansible inventory
# dynamically from vagrant file

# example of ssh-config
#Host jira-server
 # HostName 127.0.0.1
 # User vagrant
 # Port 2222
 # UserKnownHostsFile /dev/null
 # StrictHostKeyChecking no
 # PasswordAuthentication no
 # IdentityFile /home/nmajorov/workspace/ansible-jira/.vagrant/machines/jira-server/virtualbox/private_key
 # IdentitiesOnly yes
 # LogLevel FATAL

require 'json' 

cmd = `vagrant ssh-config`

inventory = Hash.new

inventory["hosts"]=[]


cmd.each_line do |line|
    if line.strip.start_with?("Host") && !line.strip.start_with?("HostName")
        #puts "find host #{line}"
        inventory["hosts"] << line.strip.slice(5..line.size)
    end 
   # puts "line: #{line}"
    if line.strip.start_with?("User") && !line.strip.start_with?("UserKnown")
        #puts "find User line #{line}"
        ansible_user = line.strip.slice("User ".size..line.size)
        if inventory.key?("vars")
             inventory["vars"]= inventory["vars"].merge({"ansible_ssh_user" => ansible_user}) 
        else
            ansible_user = line.strip.slice("User".size..line.size)
            inventory["vars"]={"ansible_ssh_user" => ansible_user.strip}
        end
    end 
    
    if line.strip.start_with?("Port")
        ansible_port = line.strip.slice("Port".size..line.size)
        if inventory.key?("vars")
            
            inventory["vars"] = inventory["vars"].merge({"ansible_port" => ansible_port.strip})

        else
             inventory["vars"]={"ansible_port" => ansible_port.strip}
        end
    end  

    # define  ansible_ssh_private_key_file  
    if line.strip.start_with?("IdentityFile")
        #a_ssh_key = line.strip.slice("IdentityFile".size..line.size).strip
        a_ssh_key= "./id_key"
        if inventory.key?("vars")
            inventory["vars"] = inventory["vars"].merge({"ansible_ssh_private_key_file" => a_ssh_key})
        else
            inventory["vars"]={"ansible_ssh_private_key_file" => a_ssh_key}
        end
        #inventory["vars"]= inventory["vars"].merge({"ansible_ssh_extra_args" =>" -o IdentitiesOnly=yes" })  
        inventory["vars"]= inventory["vars"].merge({"ansible_ssh_extra_args" =>"-o IdentitiesOnly=yes" })
    end
end

puts JSON.pretty_generate({"okd" => inventory})

