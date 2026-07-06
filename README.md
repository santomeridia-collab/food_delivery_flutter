# food_delivery app flutter

### This application uses jdk version 23

# How to run the application with android studio (emulator):

```sh
flutter run -d <device-id>
```

### if you are using an emulator like andriod studio you'll have to replace `<device-id>` with its id for eg.

```sh
flutter run -d emulator-5554
```

### **NOTE: You can check available devices with `flutter devices` command**

**Example output:**

```sh
food_delivery_flutter (auth-api-integration) > flutter devices
Found 4 connected devices:
  sdk gphone16k x86 64 (mobile) • emulator-5554 • android-x64    • Android 17 (API 37) (emulator) # <------- My andriod phone
  Windows (desktop)             • windows       • windows-x64    • Microsoft Windows [Version 10.0.26200.8655]
  Chrome (web)                  • chrome        • web-javascript • Google Chrome 149.0.7827.201
  Edge (web)                    • edge          • web-javascript • Microsoft Edge 149.0.4022.98
```

# How to run the applicaiton on your personal android device (via USB debugging):

### **For android:**

- Enable developer mode for your andriod device
- Go to settings > additional settings > developer mode and there enable USB debugging and USB install
- Then connect your android phone with your computer and when select data transfer as the mode
- run the command `flutter devices` adn there you should see your andriod device like so:

```sh
Harsh > flutter devices
Found 4 connected devices:
  22031116AI (mobile) • FIIZ5TZXF6N78XUW • android-arm64  • Android 13 (API 33) # <------- My andriod phone
  Windows (desktop)   • windows          • windows-x64    • Microsoft Windows [Version
  10.0.26200.8655]
  Chrome (web)        • chrome           • web-javascript • Google Chrome 149.0.7827.201
  Edge (web)          • edge             • web-javascript • Microsoft Edge 149.0.4022.98
```

then you can use the flutter run command with the device id like so:

```sh
flutter run -d FIIZ5TZXF6N78XUW
```

# If you wanna mirror the your android device screen on your system you can use an application like **Screen Copy**: https://github.com/genymobile/scrcpy
