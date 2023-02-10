# Energy Diary - Monitoring daily Energy Usage in CE Lab

Energy Diary can connect to your local MQTT server and collect your energy usage data. Compared to MQTT, Energy Diary will present everything in an easy-to-understand, attractive, and interactive form. 
The expected function of this smart energy app is to help the user track down their daily electricity and energy consumption. This application also has the potential to help users reduce their carbon footprint by connecting electricity and power usage data to mobile devices.


## Features

- A welcome user interface (an overview menu of the app)
- <img width="300" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/HomePage.png"><img width="300" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/HomeDraft.png">
  - A detail page for Peter, Prusa MMU2S Multi-Filament Printer 1
  - A detail page for Pertuina, Prusa MMU2S Single-Filament Printer 2
  - A detail page for Paul, Prusa MMU2S Single-Filament Printer 3
  - A detail page for Penelope, Prusa MMU2S Multi-Filament Printer 4
  - A detail page for Sally, Samsung Screen 1
  - A detail page for Sammy, Samsung Screen 2
  - A detail page for Sandy, the Soldering Station
  - <img width="300" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/DataDraft.png">
   - A "Power Consumption" section: showing information on "Active Power (the power which is consumed or utilized in an AC circuit)", "Reactive Power (the power associated with Inductors and Capacitors of the circuit)", and "Apparent Power (the combination of Active Power and Reactive Power)"
   - An "Energy Usage" section: showing information on "Total Energy Consumption", "Today's Energy Consumption", "Yesterday’s Energy Consumption", and "Change in Energy Consumption"
   - An "⚡️ Electricity" section: showing information on "Voltage" and "Current"
      
      
## Data Feed

- [Three GOSUND Smart Plugs](https://www.amazon.co.uk/Google-Control-Monitoring-Function-Required/dp/B0983HNB7M/ref=asc_df_B0983HNB7M/?tag=googshopuk-21&linkCode=df0&hvadid=535047026873&hvpos=&hvnetw=g&hvrand=7351062071157182144&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9044962&hvtargid=pla-1393506937628&psc=1&th=1&psc=1) are implemented around the CE Lab. They are responsible for collecting the energy data and publishing them to the CE MQTT Server. 

<img width="400" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/mqtt.png">

- Then, the CE MQTT Server provides the energy data directly to Energy Diary.

<img width="400" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/mqtt.png">


## Key Packages and Libraries Used
- [**firebase_auth 3.3.17**](https://pub.dev/packages/firebase_auth)  
Used for the purpose of authentication users, links with firebase within Google Cloud Platform

- [**hexcolor 3.0.1**](https://pub.dev/packages/hexcolor)  
Used in converting material colors to hex colors.

- [**mqtt_client 9.7.4**](https://pub.dev/packages/mqtt_client)  
  - [**mqtt_server_client**](https://github.com/shamblett/mqtt_client/blob/master/example/mqtt_server_client_autoreconnect.dart)  
  Used in connecting to the MQTT server and subscribing to the topics.

- [**material library**](https://api.flutter.dev/flutter/material/material-library.html)  Implementing Material Design to Flutter widgets.

- [**geocoding 2.0.4**](https://pub.dev/packages/geocoding)  
Geocoding is the computational process by which a physical address is converted into geographic coordinates. This package provides geocoding and reverse geocoding features. 


## Helpful Resources and Tutorials 

Below is a list of links to resources and tutorials that helped in the development of the app:
- https://www.engineeringtoolbox.com/kva-reactive-d_886.html
- https://fluttercentral.com/Articles/Post/1237/Waveclipper_using_ClipPath_in_Flutter


## Include A Section That Tells Developers How To Install The App

Include a section that gives instructions on how to install the app or run it in Flutter.  What versions of the plugins are you assuming?  Maybe define a licence


##  Contact Details

- <a href="www.linkedin.com/in/xiaochen-liu-60b056193"> <img width="50" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/download.png">

- Email: liuxiaochen11@gmail.com
