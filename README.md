# MarsAndMore
App not available in the US market till January 1st, 2026 due to use of material from a 1930 book. Those in US who wish to run it can compile from source on Mac by hitting the play button and inputing code signing. No further setup will be needed. https://apps.apple.com/gb/app/mars-and-more/id1615627889 Mars and More is a GPL Swift App that uses Swift UI for the user Interface. It uses one third party C library discussed below under GPL for its ephemeris.  Releasing outside USA as reading material is currently under copyright for 2 more years in US. If the project is downloaded and run in Xcode it should be set up to run as a Mac App by hitting play. My previous app Diamond Chess, used Objective-c, with some Swift View Controllers, and Auto Layout for most scenes. And I thought it would be interesting to do an app in Swift with SwiftUI.

Mars and More git is managed on Dropbox and Master is pushed to Github.

In 1.1 update shows Mars Rover photo's with images using the NASA API on the Space Tab. Starting this with NASA Photo of day at top option then the three choices of five rover photos each day for Curiosity, Opportunity and Spirit. Photos will update daily and current data is saved with Core Data. Comming up, 1.3  in planning will have an Art Tab with mars and venus themed art to update each day from the MET.

This program, or parts, can be redistributed and/or modified under the terms of the GNU General Public License; either version 2 of the License, or (at your option) any later version.

Mars and More uses the Swiss Ephemeris located at AstroApp/Astrobot/Ephemeris. This is a C library. We currently are using 4 API calls from AstroApp/Astrobot/Adapter/AdapterToEphemeris.m implementation to the Swiss Ephemeris.  Its data files are at AstroApp/Astrobot/ephe. Its license is located next to ours in outer folder, swiss-ephemeris-license. It is compatible with GPL and Mars and More uses it under GPL. It also has a dual license. And for those interested in just the Ephemeris there is also a GPL Java port by Thomas Mack.

City data in cities.json for latitude and longitude is from KStars, https://edu.kde.org/kstars/ and used under GPL. 

