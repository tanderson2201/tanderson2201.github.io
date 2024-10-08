---
title: Vehicle API Hacking
date: 2024-10-08 20:35:42 +/-TTTT
categories: [Security, API, Vehicles]
tags: [security, api, vehicles, kia, hijack, hack]     # TAG names should always be lowercase
image:
  path: /assets/images/pages/vehicle_api_hacking/icon_api_vehicles.png
  alt: More technologies is not always a good thing.
---

####  Vehicle Hacking
{: data-toc-skip='' .mt-4 }

Vehicle manufactures innovate to keep ahead of to try keep ahead of the technology trend maybe it’s biggest downfall. Technologies such as remote lock/unlock, engine stop/start and autonomous-low speed driving is becoming a more frequent accessory across manufactures. The actions are normally controller by smartphone application that communicated with the manufactures back-end server and to the vehicle. These applications require an internet connection so that it can communicate with manufactures back-end (this would verify the users account, subscriptions and actions) if the verification is successful it will then communicate with the vehicle typically using HTTP-based API to execute actions on the vehicle.

![Desktop View](/assets/images/pages/vehicle_api_hacking/manufactures_connections_transparent.png){: width="700" height="400" }

####  Potential risks with using API
{: data-toc-skip='' .mt-4 }

- Injection attacks are possible if the inputs are not properly validated, attackers can send malicious data through the API to manipulate the back-end server.
- Data exposure from APIs as they can expose data between services which can then be intercepted if there is not proper encryption, this could allow for sessions to be stolen. 
- Unauthorised access can give bad actors access to the vehicle, personal information and card details.

####  Kia’s cloud registered vehicles hacked
{: data-toc-skip='' .mt-4 }

Kia’s HTTP-based APIs was recently exposed when by Sam Curry, they was able to obtain a valid session which allowed them to query the back-end server for information on customers. This information can be manipulated to demote the car owner and promote the attacker using the API. This would give the attacker full control over the vehicle without the actual owner not having any knowledge of the attack. The most concerning part is this vulnerability effected a number of vehicles Kia’s manufactured after 2013, full details can be found [here.](https://samcurry.net/hacking-kia)

This attack on the vulnerability was then enhanced when the remote API used to take advantage was implemented into a friendly application and only required the registration plate of a vehicle to take full control of the vehicle. The problem with Kia’s API it allows for high level of control to the vehicle allowing the risk to be much higher. In the wrong hands the attacker cloud steal the vehicle and commit numerous crimes using it. The video below shows just how effective the application created by Sam Curry.

{% include embed/youtube.html id='jMHFCpQdZyg' %}

####  Conclusion
{: data-toc-skip='' .mt-4 }
When manufactures push out new technologies they should have the safety and security of people in mind first. However, it seems in this case they are not taking a logical approach considering the ease of a bad actor to gain access to a vehicle and the owners personal information. As these technology becomes more frequent due to it’s selling point to customers we will see more of these vulnerabilities appearing across other manufactures but hopefully the use query crafting tools to be able to discover these vulnerabilities before they go to productions.