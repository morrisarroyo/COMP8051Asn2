//
//  mazeProcessor.h
//  COMP8051Asn2
//
//  Created by Renz on 3/12/19.
//  Copyright © 2019 BCIT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct Cell {
    BOOL northWallPresent, southWallPresent, eastWallPresent, westWallPresent;
} Cell;

@interface MazeCaller : NSObject {
    @private
    struct MazeClass *MazeObject;
    //struct CPlusPlusClass *cPlusPlusObject;
}

- (struct Cell)getCelli:(int)i j:(int)j;
- (int)getNumRows;
- (int)getNumCols;

@end
