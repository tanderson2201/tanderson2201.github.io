---
title: Home Lab Backups
date: 2024-10-03 5:16:52 +/-TTTT
categories: [Home Lab, Backups]
tags: [homelab, backups, security, proxmox, qnap]     # TAG names should always be lowercase
---

####  Introduction
{: data-toc-skip='Introduction' .mt-4 .mb-0 }

Backups are a necessary part of all environments as a resort to recover data that is lost, corrupted or stolen. There is a dependence on backups to be available when required for instance after incident recovery e.g. ransomware. The value of data should correspond to the level of protection, for my instances I will be backing up my home lab instances and my pictures from my phone so I am using QNAP NAS with 16TB of storage, for business cases backing critical infrastructure would involve multiple backup copies, formats and locations.


####  Goals
{: data-toc-skip='Goals' .mt-4 .mb-0 }

Best practice is to follow 3-2-1 backup rule: three copies of data, two different media and one copy immutable (off-site with limited access), this gives increased redundancy and security. However, in my case I will not be going to this extreme. The NAS will be attached the home lab in a RAID5 configuration, this provides a respectable amount of space and 1 disk can fail without data being lost.

Monitoring is a key part of keeping the integrity and availability of backups, without this how do you know the success of your backups? Or drive health? Alerts. Proxmox allows notifications for backups jobs and disk health monitoring using SMTP, This allows to monitor the system on the go and not have to worry if back ups are successful.

####  Setup
{: data-toc-skip='Setup' .mt-4 .mb-0 }

1. Attach storage media.
![Desktop View](/assets/images/pages/home_lab_backups/setup_backup_1.png){: width="700" height="400" }
2. Create backup job, selected endpoints and email.
![Desktop View](/assets/images/pages/home_lab_backups/setup_backup_2.png){: width="700" height="400" }
3. Set the retention for backups, in the case I am keeping 3 weekly and 1 monthly backup.
![Desktop View](/assets/images/pages/home_lab_backups/setup_backup_3.png){: width="700" height="400" }
4. Add the identifier to the note template.
![Desktop View](/assets/images/pages/home_lab_backups/setup_backup_4.png){: width="700" height="400" }
5. Save backup configuration.
![Desktop View](/assets/images/pages/home_lab_backups/setup_backup_5.png){: width="700" height="400" }

####  Outcome
{: data-toc-skip='Outcome' .mt-4 .mb-0 }

- Weekly scheduled backups of all hosts.
- Alerts and monitoring of backups, letting me know the status of backups and drive health.
- Instant backup recovery allowing to restore a host directly from the NAS.

Useful links:
- [Backup and Restore - Proxmox VE ](https://pve.proxmox.com/wiki/Backup_and_Restore).
- [Disk Health Monitoring - Proxmox VE](https://pve.proxmox.com/mediawiki/index.php?title=Disk_Health_Monitoring&action=edit).
- [Notifications - Proxmox VE](https://pve.proxmox.com/wiki/Notifications#:~:text=Backup%20jobs%20have%20a%20configurable).