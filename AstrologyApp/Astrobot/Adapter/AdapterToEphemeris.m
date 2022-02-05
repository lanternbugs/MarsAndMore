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

-(double) getPlanetDegree:(int) type
{
    
    time_t rawtime;
    struct tm * ptm;
    time ( &rawtime );
    ptm = gmtime ( &rawtime );
    double thetime= (double) (ptm->tm_hour+(double)ptm->tm_min/60);
    int day=ptm->tm_mday;
    int month=ptm->tm_mon+1;
    int year=ptm->tm_year+1900;
    double astro_time=swe_julday(year, month, day, thetime, 1);

    double xxx[6], *xx=xxx;
    char serr[999], *serr2=serr;
        
    swe_calc_ut(astro_time,  type, 0, xx, serr2);
    return xxx[0];
}

@end
