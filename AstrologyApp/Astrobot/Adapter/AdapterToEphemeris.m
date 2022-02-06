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
    double xxx[6], *xx=xxx;
    char serr[999], *serr2=serr;
        
    swe_calc_ut(astroTime,  type, 0, xx, serr2);
    return xxx[0];
}

-(double) getSweJulianDay:(int) year : (int) month : (int) day : (int) time
{
    return swe_julday(year, month, day, time, 1);
}

@end
