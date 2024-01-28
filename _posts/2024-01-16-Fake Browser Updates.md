---
title: Fake Browser Updates
date: 2024-01-16 22:42:12 +/-TTTT
categories: [Security, AttackTypes, ClearFake]
tags: [chrome, browser, fake]     # TAG names should always be lowercase
image:
  path: /assets/images/pages/fake_browser_updates/icon_fake_browser_updates.png
  alt: Have you updated your browser recently?
---

####  Fake Browser Updates
{: data-toc-skip='AI Chatbots in Security' .mt-4 .mb-0 }
Known as DeepFake is a frequently used pop-up attack that appears on compromised sites, commonly WordPress sites that can be easily exploitable due to the site editor login page can be brute forced if left open and other CMS platforms. Allowing the attacker to edit the site and add the fake pop-up browser update. The pop-up will mimic a browser update and will even match the user's regional language. 

Upon downloading and running the supposed browser update, malware will be installed, this is commonly an infostealer such as Zgrat or Redline. This malware will try copying personal information e.g. usernames, emails, phone numbers, passwords, and send it to an IP address (normally to a Tor node). The attacker can then sell this data to the dark web or hold the information for ransom. 

####  Example
{: data-toc-skip='AI Chatbots in Security' .mt-4 .mb-0 }
Attacks are most common on Chrome as it is the most used browser with 65% user base. However, similar fake browser update appears on Edge, Firefox, Safari etc. Image below shows how this attack would look like for a chrome user. 

![Desktop View](/assets/images/pages/fake_browser_updates/fake_browser_update.png){: width="700" height="400" }
_Source: [Google Chrome Users Warned: Don’t Click To Update Browser On Websites (forbes.com)](https://www.forbes.com/sites/barrycollins/2023/10/19/google-chrome-users-warned-dont-click-to-update-browser-on-websites/)_

####  How to prevent fake browser updates
{: data-toc-skip='AI Chatbots in Security' .mt-4 .mb-0 }
- Follow an update guide from the browser provider, you will always update the browser in the setting.
  + Chrome can be updated following this guide: [Update Google Chrome - Computer - Google Chrome Help](https://support.google.com/chrome/answer/95414?hl=en&co=GENIE.Platform%3DDesktop)
- Use caution when accessing any sites, avoid clicking any pop ups and suspicious links. 
  + Check the URL of the site, it might be similar (look-a-like) webite.
- Always enable your anti-virus, it may block the malware from running.
