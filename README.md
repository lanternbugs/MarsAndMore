# MarsAndMore
Mars and More is a GPL Swift App that uses Swift UI for the user Interface. It uses one third party C library discussed below under GPL for its ephemeris. https://apps.apple.com/gb/app/mars-and-more/id1615627889 Releasing outside USA as reading material is currently under copyright for 2 more years in US. If the project is downloaded and run in Xcode it should be set up to run as a Mac App by hitting play. My previous app Diamond Chess, used Objective-c, with some Swift View Controllers, and Auto Layout for most scenes. And I thought it would be interesting to do an app entirely in Swift with MVVM and SwiftUI.

This program, or parts, can be redistributed and/or modified under the terms of the GNU General Public License; either version 2 of the License, or (at your option) any later version.

Mars and More uses the Swiss Ephemeris located at AstroApp/Astrobot/Ephemeris. This is a C library. We currently are using 4 API calls from AstroApp/Astrobot/Adapter/AdapterToEphemeris.m implementation to the Swiss Ephemeris.  Its data files are at AstroApp/Astrobot/ephe. Its license is located next to ours in outer folder, swiss-ephemeris-license. It is compatible with GPL and Mars and More uses it under GPL. It also has a dual license. And for those interested in just the Ephemeris there is also a GPL Java port by Thomas Mack.

City data in cities.json for latitude and longitude is from KStars, https://edu.kde.org/kstars/ and used under GPL. 

