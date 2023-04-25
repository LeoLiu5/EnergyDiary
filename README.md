# Energy Diary - Monitoring daily Energy Usage in CE Lab

In the CE lab located in UCL East, various electronic devices have been implemented for teaching and researching purposes. Energy Diary connects to the CE MQTT server and displays real-time energy usage data for these electronic devices, including two Samsung screens, four Prusa printers, and the soldering station. 

Instead of directly reading JSON formatted data strings from MQTT, Energy Diary presents energy data in an easy-to-understand, attractive, and interactive form.

The goal is to help the lab technician, staff, or students track daily electricity and energy consumption. This application also has the potential to help users reduce their carbon footprint by reminding them of their electricity and power consumption.


## Features

- When users open the App, they will be introduced to a login page: 
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/Login.png">

- If the user does not have an account, they need to click on "Register here" and create an account. Users can switch between the login and the sign-up page freely by clicking the "go back" button: 
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/Sign%20up.png">

- On the sign-up page, users can enter their email addresses and create a password for their accounts. If the email has been used before, a notification message will appear below to remind the user that the account has already been created: 
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/existing%20account.png">
  

- If the user forgets to enter a password or the password is too short, a notification message will appear below to ask the user to create a new password: 
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/no%20password.png">       <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/weak%20password.png">
 
- If the email address is invalid, a notification message will appear below to ask the user to enter a correct email address:
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/invalid%20eamil.png">
 


 
- After users signed up, they will be returned to the login page. Now users can log in to their just-created accounts. After clicking the "log in" button, users will be directed to the welcome page: 
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/Welcome%20page.png">
  
- Users can change the displaying pattern by clicking the icon at the top right corner: 
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/Change%20view.png">

- By clicking on one of the images, users will be directed to the corresponding electronic device's information page. However, users have to wait until the application connects to the CE MQTT server: 
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/Connecting%20to%20MQTT.png">
  

- After successfully connecting to the CE MQTT server, energy data for this electronic device will be displayed on its unique information page:  
  - <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/Information_page1.png">   <img width="200" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/Information_page2.png">

- Each information page contains:
   - A "Power Consumption" section: showing information on "Active Power (the power which is consumed or utilized in an AC circuit)", "Reactive Power (the power associated with Inductors and Capacitors of the circuit)", and "Apparent Power (the combination of Active Power and Reactive Power)"
   - An "Energy Usage" section: showing information on "Total Energy Consumption", "Today's Energy Consumption", "Yesterday’s Energy Consumption", and "Change in Energy Consumption"
   - An "⚡️ Electricity" section: showing information on "Voltage" and "Current"
   - A "⚡️ Graph" section: displaying daily energy usage on a line chart
   
- There is an information page for each of the following electronic devices from the CE lab:  
  - Peter, Prusa MMU2S Multi-Filament Printer 1
  - Pertuina, Prusa MMU2S Single-Filament Printer 2
  - Paul, Prusa MMU2S Single-Filament Printer 3
  - Penelope, Prusa MMU2S Multi-Filament Printer 4
  - Sally, Samsung Screen 1
  - Sammy, Samsung Screen 2
  - Sandy, the Soldering Station


## Demo Videos:

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/aZHMp5tJoS4/0.jpg)](https://youtu.be/aZHMp5tJoS4)

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/ffELl5H_1vw/0.jpg)](https://youtu.be/ffELl5H_1vw)

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/VJhp0Hv6mcY/0.jpg)](https://youtu.be/VJhp0Hv6mcY)
      
      
## Data Feed and Database

- [Three GOSUND Smart Plugs](https://www.amazon.co.uk/Google-Control-Monitoring-Function-Required/dp/B0983HNB7M/ref=asc_df_B0983HNB7M/?tag=googshopuk-21&linkCode=df0&hvadid=535047026873&hvpos=&hvnetw=g&hvrand=7351062071157182144&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9044962&hvtargid=pla-1393506937628&psc=1&th=1&psc=1) are implemented around the CE Lab. They are responsible for collecting the energy data and publishing them to the CE MQTT Server. 

<img width="400" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/GOSUND.png">

- Then, the CE MQTT Server provides the energy data directly to Energy Diary.

<img width="400" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/mqtt.png">

- In addition, the backend of the app connects to Cloud Firestore and pushes the energy consumption data directly to the collection called "Date".

<img width="700" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/cloud%20firestore.png">

- Finally, the app fetches energy consumption data based on the specific date and electronic device. The "monthly energy usage" graphs from the information pages are generated using the fetched data from Cloud Firestore.

## Key Packages and Libraries Used
- [**firebase_auth 4.2.6**](https://pub.dev/packages/firebase_auth)  
Used for the purpose of authentication users, links with firebase within Google Cloud Platform

- [**firebase_core 2.6.1**](https://pub.dev/packages/firebase_core/example)  
A Flutter plugin to use the Firebase Core API, which enables connecting to multiple Firebase apps

- [**cloud_firestore: ^4.5.2**](https://pub.dev/packages/firebase_core/example)  
A Flutter plugin to use the Cloud Firestore API.

- [**hexcolor 3.0.1**](https://pub.dev/packages/hexcolor)  
Used in converting material colors to hex colors.

- [**mqtt_client 9.7.4**](https://pub.dev/packages/mqtt_client)  
  - [**mqtt_server_client**](https://github.com/shamblett/mqtt_client/blob/master/example/mqtt_server_client_autoreconnect.dart)  
  Used in connecting to the MQTT server and subscribing to the topics.

- [**material library**](https://api.flutter.dev/flutter/material/material-library.html)  
Implementing Material Design to Flutter widgets.

- [**services library**](https://api.flutter.dev/flutter/services/services-library.html)  
Used in preventing device orientation changes and forcing portrait up and down, and changing the status bar colour to transparent. 

- [**foundation library**](https://api.flutter.dev/flutter/foundation/foundation-library.html)  
Used in detecting if the app the app is running on the web.

- [**dart:io library**](https://api.dart.dev/stable/2.19.2/dart-io/dart-io-library.html)  
Providing information about the environment in which the current program is running.

- [**dart:math library**](https://api.dart.dev/stable/2.19.2/dart-math/dart-math-library.html)  
Providing mathematical constants and functions.

- [**vector_math 2.1.4**](https://pub.dev/packages/vector_math)  
Providing constant factor to convert angle from degrees to radians.

- [**widgets library**](https://api.flutter.dev/flutter/widgets/widgets-library.html)  
Providing the Flutter widgets framework.

- [**dart:convert library**](https://api.dart.dev/stable/2.19.2/dart-convert/dart-convert-library.html)  
Providing encoders and decoders for converting JSON data fetched from MQTT.

- [**screen_loader 4.0.1**](https://pub.dev/packages/screen_loader)  
Providing easy to use mixin ScreenLoader, which will handle the loading on the screen without using state or navigation stack. 

- [**syncfusion_flutter_charts: ^21.1.41**](https://pub.dev/packages/syncfusion_flutter_charts)
Creating various types of cartesian, circular and spark charts with seamless interaction, responsiveness, and smooth animation. It has a rich set of features, and it is completely customizable and extendable.

## Helpful Resources and Tutorials 

Below is a list of links to resources and tutorials that helped in the development of the app:
- https://www.engineeringtoolbox.com/kva-reactive-d_886.html
- https://fluttercentral.com/Articles/Post/1237/Waveclipper_using_ClipPath_in_Flutter
- https://medium.com/@dev.n/definitive-flutter-painting-guide-ab9f51202656
- https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
- https://stackoverflow.com/questions/52489458/how-to-change-status-bar-color-in-flutter
- https://stackoverflow.com/questions/45924474/how-do-you-detect-the-host-platform-from-dart-code
- https://www.kodeco.com/31284650-getting-started-with-staggered-animations-in-flutter
- https://github.com/baoolong/WaveProgressBar/blob/master/lib/waveprogressbar_flutter.dart
- https://blog.logrocket.com/flutter-floatingactionbutton-a-complete-tutorial-with-examples/
- https://medium.com/firebase-developers/dive-into-firebase-auth-on-flutter-email-and-link-sign-in-e51603eb08f8
- https://medium.com/google-developer-experts/firebase-authentication-flutter-80e8f00338ac
- https://medium.com/firebase-developers/dive-into-firebase-auth-on-flutter-email-and-link-sign-in-e51603eb08f8


## How To Install The App




1. For developers who want to refine or extend the App, please download [the files](https://github.com/LeoLiu5/EnergyDiary/tree/main/EnergyDiary) and open them in Android Studio or Visual Studio Code. 

2. Please install [Flutter](https://github.com/flutter/flutter) and IOS Simulator or run the app using Android Emulator from Android Studio. 

3. The App uses multiple Packages and Libraries as highlighted above. They can be installed through the terminal or manually added to Flutter dependencies.

4. Enter your MQTT client username and password in the "mqtt receiver.dart" file.

5. The App uses the Firebase Authentication service. Please create a Firebase project and register your App on Firebase by providing your ```applicationID``` in ```android>app>build.grade``` for Android devices. After registration, download the "google-services.json" configuration file and implement it in the Android app module root directory. Finally, generate the "firebase_options.dart" File generated by FlutterFire CLI. The original "google-services.json", "firebase_app_id_file.json", and "firebase_options.dart" files for this app have been removed for security purposes. To set up Firebase in your Flutter App, please refer to [here](https://firebase.google.com/docs/flutter/setup?platform=android).


## License
MIT License

Copyright (c) Leo Liu liuxiaochen11@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


##  Contact Details

- <a href="www.linkedin.com/in/xiaochen-liu-60b056193"> <img width="50" alt="image" src="https://github.com/LeoLiu5/EnergyDiary/blob/main/EnergyDiary/assets/download.png">

- Email: liuxiaochen11@gmail.com
