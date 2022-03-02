/*
*  Copyright (C) 2022 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

#ifndef AdapterToEphemeris_h
#define AdapterToEphemeris_h
#import <Foundation/Foundation.h>

@interface AdapterToEphemeris: NSObject
{
    char ephepath[500];
}
-(double) getPlanetDegree:(double) astroTime : (int) type;
-(double) getSweJulianDay:(int) year : (int) month : (int) day : (double) time;
-(double) getAscendent:(double) time : (double) latitude : (double) longitude;
@end

#endif /* AdapterToEphemeris_h */
