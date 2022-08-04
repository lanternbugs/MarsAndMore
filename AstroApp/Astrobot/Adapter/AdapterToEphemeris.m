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

#import "AdapterToEphemeris.h"
#include "sweodef.h"
#include "swephexp.h"
#include <string.h>


@implementation AdapterToEphemeris

-(double) getPlanetDegree:(double) astroTime : (int) type
{
    double xx[6];
    char serr[999];
    swe_calc_ut(astroTime,  type, 0, xx, serr);
    return xx[0];
}

-(double) getAscendent:(double) time : (double) latitude : (double) longitude
{
    double cusp[16];  /* empty + 12 houses */
    double ascmc[10];    /* asc, mc, armc, vertex .. */
    char system = 'P'; // house system Placidius
     int val =swe_houses(time, latitude, longitude, system, cusp,  ascmc);
    return cusp[1];
}

-(double) getHouse:(double) time : (double) latitude : (double) longitude : (int) house : (char) system
{
    double cusp[16];  /* empty + 12 houses */
    double ascmc[10];    /* asc, mc, armc, vertex .. */
   //char system = 'P'; // house system Placidius
     int val =swe_houses(time, latitude, longitude, system, cusp,  ascmc);
    return cusp[house];
}

-(double) getSweJulianDay:(int) year : (int) month : (int) day : (double) time
{
    return swe_julday(year, month, day, time, 1);
}

-(id) init
{
    self = [super init];
    if(self) {
        NSString *path = [[NSBundle mainBundle] resourcePath];
        const char *ephe = [path UTF8String];
        sprintf(ephepath, "%s", ephe);
        swe_set_ephe_path(ephepath);
    }
    return self;
}

@end
