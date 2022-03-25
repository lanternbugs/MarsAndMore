# MarsAndMore
Mars and More is a Swift App that uses Swift UI for the user Interface. My previous app Diamond Chess, used Objective-c, with some Swift View Controllers, and Auto Layout for most scenes. And I thought it would be interesting to do an app entirely in Swift with MVVM and SwiftUI.

This program, or parts, can be redistributed and/or modified under the terms of the GNU General Public License; either version 2 of the License, or (at your option) any later version.

Mars and More uses the Swiss Ephemeris located at AstroApp/Astrobot/Ephemeris. This is a C library. We currently are using 3 and soon 4 API calls from the AdapterToEphemeris class in Astrobot/Adapter folder to the Swiss Ephemeris.  Its data files are at AstroApp/Astrobot/ephe. And its license is located next to ours in outer folder, swiss-ephemeris-license. It is compatible with GPL and also has a dual license. If you use any part of Mars and More, allowing for simply studying some part and redesigning your own, the whole App must be under GPL. But if you just take the Ephemeris, which is also available from Astrodienst, then you can choose the choice of GPL or purchase a direct license from Astrodienst. I am summarizing by this what is in, swiss-ephemeris-license, and for my own purpose it is sufficient to say this full app can be used or any part under GPL. And for those interested in just the Ephemeris there is also a Java port by Thomas Mack.

City data in cities.json for latitude and longitude is from KStars, https://edu.kde.org/kstars/ and used under GPL. 

