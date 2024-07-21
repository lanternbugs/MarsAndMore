# MarsAndMore
GPL and On the App store on both Mac and iOS at https://apps.apple.com/gb/app/mars-more-astro-charts/id1615627889

To run, one can compile from source on Mac by hitting the play button and inputing code signing. No further setup will be needed.  Mars and More is a GPL Swift App that uses Swift UI for the user Interface. It uses one third party C library discussed below under GPL for its ephemeris. My previous app Diamond Chess, used Objective-c, with some Swift View Controllers, and Auto Layout for most scenes. I thought it would be interesting to do an app in Swift with SwiftUI to teach myself SwiftUI.

The app shows three different kinds of astro chart wheels: natal, synastry, and transit. It also shows the time of day in local time for when planets/comets make exact angles to each other for any day. The major angles are used, 0, 60, 90, 120, 180, but the minor angle transit times that were advanced by Kepler can also be shown if enabled in settings.  See the resource view in app for exactly which minor angles are included. The app's models make extensive use of enums.

Mars and More git is managed on Dropbox and Master is pushed to Github.

The app as of 1.1 has Mars Curiosity Rover photo's with images using the NASA API on the Space Tab. There is also an option to see the NASA Photo of day at top of Space tab. Photos will update daily at midnight and current data is saved with Core Data. 1.3 has an Art Tab with Mars and Venus themed art that updates each day from the MET. There is an option to save art images that the user likes to a library similar to a like feature.

This program, or parts, can be redistributed and/or modified under the terms of the GNU General Public License; either version 2 of the License, or (at your option) any later version.

Mars and More uses the Swiss Ephemeris located at AstroApp/Astrobot/Ephemeris. This is a C library. We currently are using 4 API calls from AstroApp/Astrobot/Adapter/AdapterToEphemeris.m implementation to the Swiss Ephemeris.  Its data files are at AstroApp/Astrobot/ephe. Its license is located next to ours in outer folder, swiss-ephemeris-license. It is compatible with GPL and Mars and More uses it under GPL. It also has a dual license. And for those interested in just the Ephemeris there is also a GPL Java port by Thomas Mack.

City data in cities.json for latitude and longitude is from KStars, https://edu.kde.org/kstars/ and used under GPL. 

