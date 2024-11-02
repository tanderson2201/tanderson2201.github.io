---
title: Vehicle API Hacking
date: 2024-10-08 20:35:42 +/-TTTT
categories: [Security, API, Vehicles]
tags: [security, api, vehicles, kia, hijack, hack]     # TAG names should always be lowercase
image:
  path: /assets/images/pages/vehicle_api_hacking/icon_api_vehicles.png
  alt: Is your vehicle hackable?
---

####  Vehicle Hacking
{: data-toc-skip='' .mt-4 }

Vehicle manufactures innovations to keep up with technology trends, may be its biggest downfall. Vehicle technologies have developed rapidly, and now a lot of mass-produced vehicles come with remote lock/unlock, engine stop/start and autonomous-low speed driving. The actions are typically controlled by a smartphone application that communicates with the manufactures back-end server and to the vehicle - this would verify the users account, subscriptions and actions. If the verification is successful, it will then communicate with the vehicle typically using HTTP-based API to execute actions on the vehicle. Like with all technology that is open to the internet, it allows attacks to find creative ways to be able to find flaws and take advantage of.

![Desktop View](/assets/images/pages/vehicle_api_hacking/vehicle_api_hacking_diagram.png){: width="700" height="400" }

####  Potential risks with using API
{: data-toc-skip='' .mt-4 }

- Injection attacks are possible if the inputs are not properly validated, attackers can send malicious data through the API to manipulate the back-end server.
- Data exposure from APIs as they can expose data between services which can then be intercepted if there is not proper encryption, this could allow for sessions to be stolen. 
- Unauthorised access can give bad actors access to the vehicle, personal information and card details.

####  Kia’s Incident
{: data-toc-skip='' .mt-4 }

Kia’s HTTP-based APIs flaws was recently exposed by Sam Curry. There was a number of vulnerabilities in their APIs (now have been patched) that affects the dealer portal using the VIN number which can be obtained with the license plate. These vulnerabilities would allow the attack to completely take over the car owners account, in summary the information can be manipulated to demote the car owner and promote the attacker using the API. This would give the attacker full control over the vehicle without the actual owner not having any knowledge of the attack. The most concerning part is this vulnerability effected a number of vehicles Kia’s manufactured after 2014. Further details can be found on Sam Curry’s blog [here.](https://samcurry.net/hacking-kia)

This attack on the vulnerability was then enhanced when the remote API used to take advantage was implemented into a friendly application (proof of concept). Only requiring registration plate of a vehicle to take full control of the vehicle and breach the privacy of the owner. 

The problem with Kia’s API it allows for high level of control to the vehicle and user information that can be retrieved on the dealer backend. In the wrong hands the attacker cloud steals the vehicle and commit numerous crimes using it. The video below shows just how effective the application was: 

{% include embed/youtube.html id='jMHFCpQdZyg' %}

####  Conclusion
{: data-toc-skip='' .mt-4 }
When manufactures push out new technologies they should have the safety, privacy and security in mind first. However, it seems in this case they are not taking that logical approach. As this technology becomes more frequent across manufactures, I expect we will see more of these vulnerabilities appearing which could be potentially spotted using pen-testing techniques or minimising what data can be controlled over the internet.