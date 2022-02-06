//
//  AdapterToEphemeris.h
//  MarsAndMore
//
//  Created by Michael Adams on 2/2/22.
//

#ifndef AdapterToEphemeris_h
#define AdapterToEphemeris_h
#import <Foundation/Foundation.h>

@interface AdapterToEphemeris: NSObject
-(double) getPlanetDegree:(double) astroTime : (int) type;
-(double) getSweJulianDay:(int) year : (int) month : (int) day : (int) time;
@end

#endif /* AdapterToEphemeris_h */
