OpenCast is a Mac/iOS framework for communicating with Google Cast devices. It ships with the same headers as the official [Google Cast iOS framework](https://developers.google.com/cast/docs/downloads#ios) and aims to be fully API-compatible with version 2 of the official framework.

# Use Cases
* Developing Mac apps that interact with Google Cast devices (e.g., Chromecast)
* iOS/Mac product families that want to support Google Cast
* Complex iOS sender applications for Google Cast that may not be possible with the official framework

# Examples
See the [Samples/](Samples) directory for example code. The [CastCommander](https://github.com/acj/CastCommander) project is an example of a remote control-style Mac application that uses OpenCast.

# Feature Parity
## Implemented
* Scan for devices
* Connect to device
* Launch custom receiver application
* Launch "default" media receiver application
	* Load media from URL
	* Play, pause, stop
	* Seek
* Stop receiver application
* Change volume, mute
* Respond to heartbeat messages

## Not yet implemented
* Connect to existing session
* Launch application {even, except} if there's an existing session
* Pass custom data (`customData` parameters) to receiver application
* API changes in version 3