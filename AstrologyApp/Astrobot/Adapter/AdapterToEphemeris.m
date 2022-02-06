//
//  AdapterToEphemeris.m
//  MarsAndMore
//
//  Created by Michael Adams on 1/21/22.
//
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

-(double) getSweJulianDay:(int) year : (int) month : (int) day : (double) time
{
    return swe_julday(year, month, day, time, 1);
}

@end
