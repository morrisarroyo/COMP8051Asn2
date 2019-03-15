#import "MazeCaller.h"
#import "maze.h"

struct MazeClass {
    Maze maze;
};

@implementation MazeCaller

- (id)init {
    self = [super init];
    if (self) {
        MazeObject = new MazeClass;
        MazeObject->maze.Create();
        /*
        useObjC = YES;
        val = 0;
        cPlusPlusObject = new CPlusPlusClass;
        */
    }
    return self;
}

- (struct Cell)getCelli:(int)row j:(int)col {
    
    MazeCell mazeCell = MazeObject->maze.GetCell(row, col);
    
    struct Cell cell;
    cell.eastWallPresent = mazeCell.eastWallPresent;
    cell.westWallPresent = mazeCell.westWallPresent;
    cell.southWallPresent = mazeCell.southWallPresent;
    cell.northWallPresent = mazeCell.northWallPresent;
    
    return cell;
}

- (int) getNumRows {
    return MazeObject->maze.rows;
}

- (int) getNumCols {
    return MazeObject->maze.cols;
}

@end
