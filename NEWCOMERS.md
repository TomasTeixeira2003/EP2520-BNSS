# Newcomer's Guide to the ACME Internal Network

Welcome aboard! We're glad to have you here. This document will guide you through the ACME corporate network, how to access it, and what services are available to aid your work.

## Devices

You have been provided with at least a **corporate laptop**, and a **corporate mobile phone**. Both of these have your personal certificate already installed, this is what you will use to log in to the network. You must also create a new password on first login, for which the system will prompt you.

Whenever you are on company premises, you can use the internal network `Group1-Stockholm` or `Group1-London` (depending on your location) to access corporate resources. While working remotely, you must use the VPN installed on your device. Follow the manufacturer's guide to enable the VPN: ([Android](https://support.google.com/work/android/answer/9213914?hl=en))([macOS](https://support.apple.com/guide/mac-help/set-up-a-vpn-connection-on-mac-mchlp2963/mac))([Windows](https://support.microsoft.com/en-us/windows/connect-to-a-vpn-in-windows-3d29aeb1-f497-f6b7-7633-115722c1009c)).

As an exception, you may also use your private device to connect to the corporate network while on premises, you must contact IT to set the device up with your personal certificate for this.

## Authentication

ACME uses the Keycloak <https://keycloak.internal> tool for authentication of web tools. **Never enter your credentials anywhere else!**

### One-Time Pad (OTP) Codes

To access some parts of the ACME network with stricter security, you will need the **FreeOTP** app pre-installed on your phone to set up an OTP code. When prompted by the <https://keycloak.internal> authentication service, enter this one-time code to access the requested resource.

## Services

The company provides a set of services to aid collaborative working. Use your company credentials to log in to all these services.

### NextCloud <https://nextcloud.internal>

NextCloud is a platform to store and share files, collaborate on documents with colleagues, and much more.

### Chat <https://chat.internal>

We use Matrix for communication. This is an Instant Messaging (IM) service. You can use any client you like to access it, just make sure to select `chat.internal` as your homeserver. We recommend the following:

- Web: <https://app.element.io/#/login>
- Android: <https://play.google.com/store/apps/details?id=im.vector.app>
- iOS: <https://play.google.com/store/apps/details?id=im.vector.app>

### Secure Web Server <https://secureweb.internal>

For cases that require extra security, we use the Secure Web Server. You will need to be on premises to access this server, and use your **company mobile phone** to enter the OTP code for access.
