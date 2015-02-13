# Swiss Ephemeris for OS X and iOS
This repo contains a configured Xcode workspace with a Xcode project for use in Mac apps and a Xcode project for use in iOS apps.

# Features
* Preconfigured Xcode project with Swiss Ephemeris 2.00 source code ready to be build.
* Build easily libraries for OS X and iOS. Note: **The source code is not checked or audited for correct operation and results on 64-bit architectures.**
  * OS X: <code>SwissEphemeris.framework</code> supports OS X 10.6 or later on <code>x86_64</code>
  * iOS: <code>libSwissEphemeris.a</code> supports iOS 6.0 or later on the simulator and <code>armv7</code> and <code>arm64</code> on the device
  * iOS: <code>SwissEphemeris.framework</code> supports iOS 8.0 or later on the simulator and <code>armv7</code> and <code>arm64</code> on the device
* A pure as possible distribution and use of the [Swiss Ephemeris source code](http://www.astro.com/ftp/swisseph/src/) from Astrodienst AG. The only changes that increase better support on OS X or iOS will be incorporated.
* Automatic configuration: There is no need to manually call <code>swe_set_ephe_path()</code>. This function will be called automatically. On OS X the framework resources directory will be used and on iOS the main bundle resources directory. **If you don't like this behavior, please open an issue.**
* <code>~/Application Support/SwissEphemeris</code> (OS X): Users can use this folder to add additional data files. The framework will prioritize these files over the data files which are distrubuted as part of the framework.

# Data reference
You can use the [test page](http://www.astro.com/swisseph/swetest.htm) at Astrodient for data comparison.

# Further reading
* [Swiss Ephemeris website](http://www.astro.com/swisseph/)
* [General documentation](http://www.astro.com/swisseph/swisseph.htm)
* [Programmer documentation](http://www.astro.com/swisseph/swephprg.htm)
* [Mailing list](http://www.astro.com/swisseph/swephmlist_e.htm)
* [Download area](http://www.astro.com/ftp/swisseph/)
