---
title: Home Lab VPN
date: 2024-11-17 10:29:07 +/-TTTT
categories: [Home Lab, VPN]
tags: [homelab, vpn, security, proxmox, wireguard]     # TAG names should always be lowercase
---

#### Introduction
{: data-toc-skip='' .mt-4 .mb-0 }

VPN (Virtual Private Network) is a service that creates a secure, end-to-end encrypted connection between the host and the internet. Using routing to send traffic to a remote server, this will use the remote server external IP address and encrypt the data being sent across the network. Using a VPN has many benefits that would reduce the risks to your privacy and security, this works by:

1. Encryption: typically, the traffic going through the VPN will be encrypted e.g. if an attacker intercepts the traffic, they shouldn’t be able to read the data.
2. IP Masking: this replaces your external IP address with the end service external IP address. This would hide would hide your actual IP address and geographic location.
3. Secure Tunnel: end-to-end encryption creates a secure tunnel that reduces the risks of exposing internet activities e.g. sensitive information. 

#### Goals
{: data-toc-skip='' .mt-4 .mb-0 }

Using my Dell Wyse (pvewyse1), I plan on setting up PIVPN which allows open-source protocol WireGuard or OpenVPN to run a secure tunnel to the system, I will be using WireGuard due to it being having better performance, modern cryptography and simpler to configure. I want to achieve the following with this solution:

1. I do a lot of travelling and found that it would be useful to connect back to my home lab to remotely access resources on the go.  
2. In situations where I do need to connect to public/unsecure WiFi networks I can use the VPN to encrypt my traffic to mitigate the risks of packet capturing.  

#### Setup
{: data-toc-skip='' .mt-4 .mb-0 }

On the host you want the VPN services to run on:
1. Install PiVPN: `sudo curl -L https://install.pivpn.io | bash`.
2. Follow the steps on screen: Choose between WireGuard or OpenVPN (I will be using WireGuard for the reasons mentioned above).
3. Set your static IP address or use Dynaminc DNS (DDNS).
4. Setup port forwarding for `51820 UDP` , this will need to be configured on your router or firewall.
5. Create a client .conf profile this be transferred to the client device you want to connect from: `pivpn -a {hostname}`.
6. Check the .conf file has been created: `cd /home/{username}/configs && ls -a`.
7. Use a file transfer solution e.g. WInSCP, to copy the .conf to the client device. 

On a Unix client device you want to connect to the VPN on:
1. Move the .conf file to: `/etc/wireguard/{hostname}.conf`
2. Start the VPN connection: `sudo wg-quick up {hostname}`
3. Check the status of the VPN connection: `sudo journalctl -u wg-quick@{hostname}`

> You can start the VPN automatically on boot using: `sudo systemctl enable wg-quick@{hostname}` then `sudo reboot`, after restarting the system the VPN will start on boot. To disconnect from the VPN use: `sudo wg-quick down {hostname}` 
{: .prompt-tip }

On a Windows client device you want to connect to the VPN on:
1. Install WireGuard [here](https://download.wireguard.com/windows-client/wireguard-installer.exe).
2. Click Add tunnel > Import tunnel from file > select the {hostname}.conf file. 
3. VPN functionality can be controlled by the UI. 

#### Outcome
{: data-toc-skip='' .mt-4 .mb-0 }

I have the client installed on my laptop and mobile with the VPN automatically tuned on it always me to easily access my home lab to work on projects remotely. The setup has been a simple process and has given me a lot of flexibility when working on the go and the privacy and security when working on unknown or unsecure networks. Also, it's very easy to scale up or down the amount of connections when required. In the future I will see if I can enhance the security harderning standards on the virtual machine that is running the VPN services, this would mitigate any potential risk of authorised access through the VPN.
The example below shows the VPN tunnel log between my laptop and the server with PiVPN installed, allowing me to connect to my proxmox console remotely.
![Desktop View](/assets/images/pages/home_lab_vpn/vpn_connection.png){: width="700" height="400" }

Useful links:
- [PiVPN](https://www.pivpn.io/).
- [WireGuard Quickstart](https://www.wireguard.com/quickstart/).