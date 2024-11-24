---
title: LibreLink Tracker Project
date: 2024-11-24 17:08:02 +/-TTTT
categories: [Projects, LibreLink Tracker]
tags: [projects, librelink, tracker]     # TAG names should always be lowercase
---

#### LibreLink
{: data-toc-skip='' .mt-4 .mb-0 }

Abbott LibreLink is remote monitor application that communicates with Libre Freestyle monitors to allow for live tracking on blood glucose levels they can be viewed using their application on a smart phone. This technology is a massive improvement compared to the traditional finger prick monitoring devices; however, I do feel the software can be improved in multiple ways: 
- At the time of writing this there is not an option to have your glucose displayed on the lock screen of the smart phone, you have to go into the app each time to check current level. 
- The main menu graph used to give guidance of the direction glucose is heading shows the last 8 hours and not a shorter period of time e.g. 1 hour, the larger graph makes it more difficult to understand the current direction of glucose. 
- I am not able to read my glucose from an alternative device, I have to keep using my phone to see my glucose level. 

My goal is to create a simple but effective application that will resolve the issues above using the LibreLinkUp API Client. 

![Desktop View](/assets/images/pages/librelink_tracker_project/librelink_communication.png){: width="700" height="400" }

> All future updates to this project can be found [here.](https://github.com/tanderson2201/glucose_tracker)
{: .prompt-info }

#### Development 
{: data-toc-skip='' .mt-4 .mb-0 }

Using the Python and the API Client I was able to pull basic information that includes the glucose level and the timestamp set to repeat every two minutes (avoiding getting locked out from making too many requests).  This gives a very basic but useful direction on where the glucose is heading. Next, I played around with an interface so that I could add colour to the glucose level to make it distinctive and add a refresh button to force requests when required. 

![Desktop View](/assets/images/pages/librelink_tracker_project/librelink_v1.jpg){: width="700" height="400" }

![Desktop View](/assets/images/pages/librelink_tracker_project/librelink_v2.jpg){: width="700" height="400" }

#### Solution 
{: data-toc-skip='' .mt-4 .mb-0 }

The development led to the below solutions that work on Windows and Linux (works best on 1920 x1080 display), also meets the requirements I listed at the start if the project. It includes the following: 
- Automated glucose readings every two minutes.
- Trend giving the glucose direction: dropping fast, going low, stable, going high, increasing fast.
- Coloured glucose:
    - Green: 3.9 - 8,7 – Normal range. 
    - Orange: 3.4 - 3.9 or 8.7 - 9.2 – Slightly out of range.
    - Red: Else – Out of range. 
- Refresh button to force requests.
- Warning message when the connections is lost.

> This application can be run as .py or converted to an .exe file type.
{: .prompt-info }

![Desktop View](/assets/images/pages/librelink_tracker_project/librelink_v3.png){: width="700" height="400" }

#### Setup 
{: data-toc-skip='' .mt-4 .mb-0 }

- Connect LibreLink to LibreLinkUp app, this can be done [here.](https://www.librelinkup.com/articles/qsg)
- Get the LibreLinkUp `Patient ID` and `API Token`, this information can be gathered using [Postman application.](https://www.postman.com/)
- Enter the following details into Postman to get your `API Token`: 

| POST                                               | https://api.libreview.io/llu/auth/login              |
|:---------------------------------------------------|-----------------------------------------------------:|
| Authorization                                      | No Auth                                              |

| Headers  Key                                                | Value                                       |
|:---------------------------------------------------|-----------------------------------------------------:|
| Content-Type                                       | application/json                                     |
| Product                                            | llu.ios (or llu.andriod)                             |
| Version                                            | 4.2.1                                                |

| Body                                               | Raw                                                  |
|:---------------------------------------------------|-----------------------------------------------------:|
|{ 
| "email": "Your LibreLinkUp Username",
| "password": "Your LibreLinkUp Password"
|}                                                                                                          |

| Send                                               |                                                      |
|:---------------------------------------------------|-----------------------------------------------------:|
| authTicket": {                                                                                            |
|            "token": Make note of this API token.",                                                        |
|             "expires": 1745355110,                                                                        |
|             "duration": 15552000000                                                                       |

- Under `authTicket` you will see your API token, make a note of this.
- Enter the following details into Postman to get your `Patient ID`: 

| GET                                                | https://api.libreview.io/llu/connections             |
|:---------------------------------------------------|-----------------------------------------------------:|
| Authorization                                      | Bearer Token                                         |
| Token                                              | “Enter your API Token”                               |

| Headers Key                                        | Value                                                |
|:---------------------------------------------------|-----------------------------------------------------:|
| Content-Type                                       | application/json                                     |
| Product                                            | llu.ios (or llu.andriod)                             |
| Version                                            | 4.7                                                  |

| Send                                               |                                                      |
|:---------------------------------------------------|-----------------------------------------------------:|
|{                                                                                                          |
|    "status": 0,                                                                                           |
|    "data": [                                                                                              |
|        {                                                                                                  |
|            "id": "Your ID",                                                                               |
|            "patientId": " Make note of the Patient ID.",                                                  |
|            "country": "GB",                                                                               |
|            "status": 2,                                                                                   |
|            "firstName": "Tom",                                                                            |
|            "lastName": "Anderson",                                                                        |
|            "targetLow": 70,                                                                               |
|            "targetHigh": 157,                                                                             |

- Under `data` you will see your `PatientID`, make a note of this.
- Download or copy the script below, change the variables to match your `PatientID` and API `Token`:
> To run the script you will need to install modules `pip install requests` and `pip install tkinter`
{: .prompt-info }

```python
import requests
import tkinter as tk
from tkinter import messagebox, scrolledtext

# Function to fetch glucose data from the API
def get_glucose_data(patient_id, token):
    url = f"https://api.libreview.io/llu/connections/{patient_id}/graph"
    
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json',
        'product': 'llu.ios',
        'version': '4.7.0'
    }
    
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        return data
    else:
        print(f"Error: {response.status_code}")
        return None

# Function to extract glucose values
def get_glucose_value(data):
    if data:
        try:
            glucose_measurement = data['data']['connection']['glucoseMeasurement']
            glucose_value = glucose_measurement['Value']
            timestamp = glucose_measurement['Timestamp']
            trend_arrow = glucose_measurement['TrendArrow']
            return glucose_value, timestamp, trend_arrow
        except KeyError as e:
            print(f"KeyError: {e} - Check the API response structure.")
            return None, None, None
    return None, None, None

# Main function for managing data retrieval and GUI updates
class GlucoseTrackerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Glucose Tracker")
        self.root.geometry("400x400")  # Set a fixed size for the window
        self.root.resizable(False, False)  # Make the window non-resizable
        self.root.configure(bg="#2E2E2E")  # Dark gray background

        self.glucose_readings = []  # Store last readings
        self.patient_id = "{patient_id}"  # Replace with your actual patient ID
        self.token = "{token}"  # Replace with your actual access token

        # Create a ScrolledText widget for better formatting
        self.text_widget = scrolledtext.ScrolledText(root, width=50, height=20, bg="#1C1C1C", fg="white", wrap=tk.WORD)
        self.text_widget.pack(pady=5)

        self.update_button = tk.Button(root, text="Refresh Data", command=self.update_data, bg="#444", fg="white")
        self.update_button.pack(pady=5, anchor='e')

        self.root.after(0, self.update_data)  # Start data retrieval

    def update_data(self):
        data = get_glucose_data(self.patient_id, self.token)
        glucose_value, timestamp, trend_arrow = get_glucose_value(data)

        if glucose_value is not None:
            self.glucose_readings.append((glucose_value, timestamp, trend_arrow))
            if len(self.glucose_readings) > 20:
                self.glucose_readings.pop(0)  # Keep only the last readings

            self.display_glucose_readings()
        else:
            messagebox.showwarning("Warning", "Failed to retrieve glucose data.")

        # Repeat this function every 2 minutes
        self.root.after(120000, self.update_data)

    def display_glucose_readings(self):
        self.text_widget.delete(1.0, tk.END)  # Clear the current text widget

        # Display the readings in reverse order to show the most recent at the top
        for value, timestamp, trend_arrow in reversed(self.glucose_readings):
            color = self.get_color(value)
            trend_text = self.get_trend_text(trend_arrow)
            display_text = (
                f"Glucose Level: "
            )
            # Insert the glucose value with color formatting
            self.text_widget.insert(tk.END, display_text)
            self.text_widget.insert(tk.END, f"{value:.1f} mg/dL\n", "colored")  # Color only the glucose value
            self.text_widget.insert(tk.END, f"Trend: {trend_text}\n")
            self.text_widget.insert(tk.END, f"Timestamp: {timestamp}\n")
            self.text_widget.insert(tk.END, "-----------------------------------------------\n")

            # Tag the glucose value for coloring
            self.text_widget.tag_config("colored", foreground=color)

    def get_color(self, value):
        if 3.9 <= value <= 8.7:  # Normal range
            return "green"
        elif 3.4 <= value < 3.9 or 8.7 < value <= 9.2:  # Slightly out of range
            return "orange"
        else:  # Out of range
            return "red"

    def get_trend_text(self, trend_arrow):
        trend_map = {
            1: "Dropping Fast",
            2: "Going Low",
            3: "Stable",
            4: "Going High",
            5: "Increasing Fast"
        }
        return trend_map.get(trend_arrow, "Unknown")

# Running the application
if __name__ == "__main__":
    root = tk.Tk()
    app = GlucoseTrackerApp(root)
    root.mainloop()
```

#### Conclusion  
{: data-toc-skip='' .mt-4 .mb-0 }

Overall, I am happy with the end product and it gives the option of reading your glucose from an alternative device if you are experiencing the same problems I had. I will be continuing my work on this project to include features: 
- Data Visualization: visually represent glucose trends over time. This can provide insights into the user's glucose levels.
- Export Data Functionality: Add a feature to export the glucose readings to a CSV or text file for personal records. 
- Notification System: Implement a notification system to alert users when glucose levels fall outside a specified range. This can be done through message boxes or system notifications e.g. ntfy. 

Massive thanks to [Ronaldr1985](https://github.com/Ronaldr1985) for assisting with this application and for building a version that works directly on a Raspberry Pi Zero using an OLED Display Hat. More details about this project can be found on their github page.

![Desktop View](/assets/images/pages/about/current_project.png){: width="700" height="400" }