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

-(double) getPlanetDegree:(double) astroTime : (int) type : (BOOL) tropical : (int) siderealSystem
{
    double xx[6];
    char serr[999];
    // for sidereal swe_set_sid_mode(SE_SIDM_LAHIRI, 0, 0); swe_calc_ut(astroTime,  type, SEFLG_SIDEREAL, xx, serr);
    // for tropical swe_calc_ut(astroTime,  type, 0, xx, serr);
    if(tropical) {
        swe_calc_ut(astroTime,  type, 0, xx, serr);
    } else {
        swe_set_sid_mode(siderealSystem, 0, 0);
        swe_calc_ut(astroTime,  type, SEFLG_SIDEREAL, xx, serr);
    }
    return xx[0];
}

-(double) getAscendent:(double) time : (double) latitude : (double) longitude : (char) system : (BOOL) tropical : (int) siderealSystem
{
    double cusp[16];  /* empty + 12 houses */
    double ascmc[10];    /* asc, mc, armc, vertex .. */
    //char system = 'P'; // house system Placidius
     // int val =swe_houses(time, latitude, longitude, system, cusp,  ascmc); regular
    // swe_set_sid_mode(SE_SIDM_LAHIRI, 0, 0); int val =swe_houses_ex(time, SEFLG_SIDEREAL, latitude, longitude, system, cusp,  ascmc); sidreal
    if(tropical) {
         swe_houses(time, latitude, longitude, system, cusp,  ascmc);
    } else {
        swe_set_sid_mode(siderealSystem, 0, 0);
        swe_houses_ex(time, SEFLG_SIDEREAL, latitude, longitude, system, cusp,  ascmc);
    }
    
    return cusp[1];
}

-(double) getMC:(double) time : (double) latitude : (double) longitude : (char) system : (BOOL) tropical : (int) siderealSystem
{
    double cusp[16];  /* empty + 12 houses */
    double ascmc[10];    /* asc, mc, armc, vertex .. */
    //char system = 'P'; // house system Placidius
     // int val =swe_houses(time, latitude, longitude, system, cusp,  ascmc); regular
    // swe_set_sid_mode(SE_SIDM_LAHIRI, 0, 0); int val =swe_houses_ex(time, SEFLG_SIDEREAL, latitude, longitude, system, cusp,  ascmc); sidreal
    if(tropical) {
         swe_houses(time, latitude, longitude, system, cusp,  ascmc);
    } else {
        swe_set_sid_mode(siderealSystem, 0, 0);
        swe_houses_ex(time, SEFLG_SIDEREAL, latitude, longitude, system, cusp,  ascmc);
    }
    
    return cusp[10];
}


-(double) getHouse:(double) time : (double) latitude : (double) longitude : (int) house : (char) system : (BOOL) tropical : (int) siderealSystem
{
    double cusp[16];  /* empty + 12 houses */
    double ascmc[10];    /* asc, mc, armc, vertex .. */
    //char system = 'P'; // house system Placidius
    // int val =swe_houses(time, latitude, longitude, system, cusp,  ascmc); regular
    // swe_set_sid_mode(SE_SIDM_LAHIRI, 0, 0); int val =swe_houses_ex(time, SEFLG_SIDEREAL,  latitude, longitude, system, cusp,  ascmc); sidereal
    if(tropical) {
        swe_houses(time, latitude, longitude, system, cusp,  ascmc);
    } else {
        swe_set_sid_mode(siderealSystem, 0, 0);
        swe_houses_ex(time, SEFLG_SIDEREAL,  latitude, longitude, system, cusp,  ascmc);
    }
    
    
    return cusp[house];
}

-(double) getSweJulianDay:(int) year : (int) month : (int) day : (double) time
{
    return swe_julday(year, month, day, time, 1);
}

-(double) convertSweDate:(double) time {
    
    int year = 0;
    int month = 0;
    int day = 0;
    double hour = 0;
    swe_revjul(time, SE_JUL_CAL, &year, &month, &day, &hour);
    double monthFraction = (double) month / 12;
    double dayFraction = (double) day / 365;
    double hourFraction = (double) ((hour / 24)/ 365);
    return (double) year + monthFraction + dayFraction + hourFraction;
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
