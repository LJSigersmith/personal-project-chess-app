//
//  ViewController.m
//  Chess
//
//  Created by Lance Sigersmith on 11/14/18.
//  Copyright © 2018 Lance Sigersmith. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)checkKings {
    
    //Find King Position
    NSString *position;
    for (UIView *space in [board subviews]) {
        for (UIView *piece in [space subviews]) {
            NSString *pieceString = (NSString *)[pieceFind objectForKey:[NSNumber numberWithInt:piece.tag]];
            if ([pieceString containsString:@"White_King"]) {
                position = (NSString *)[tagForPosition objectForKey:[NSNumber numberWithInt:space.tag]];
                NSMutableArray *positionArray = [[NSMutableArray alloc] init];
                [positionArray addObject:[NSString stringWithFormat:@"%C,%C", [position characterAtIndex:0], [position characterAtIndex:1]]];
                wKing = positionArray;
                NSLog(@"WKING %@", wKing);
            } else if ([pieceString containsString:@"Black_King"]) {
                position = (NSString *)[tagForPosition objectForKey:[NSNumber numberWithInt:space.tag]];
                NSMutableArray *positionArray = [[NSMutableArray alloc] init];
                [positionArray addObject:[NSString stringWithFormat:@"%C,%C", [position characterAtIndex:0], [position characterAtIndex:1]]];
                bKing = positionArray;
                NSLog(@"BKING %@", bKing);
            }
        }
    }
    
    

    
    
    [possibleMoves removeAllObjects];
}

-(NSInteger) determinePiece: (NSString *)piece {
    //0-Pawn, 1-Castle, 2-Horse, 3-Bishop, 4-Queen, 5-King
    if ([piece containsString:@"Pawn"]) {
        return 0;
    }
    if ([piece containsString:@"Castle"]) {
        return 1;
    }
    if ([piece containsString:@"Horse"]) {
        return 2;
    }
    if ([piece containsString:@"Bishop"]) {
        return 3;
    }
    if ([piece containsString:@"Queen"]) {
        return 4;
    }
    if ([piece containsString:@"King"]) {
        return 5;
    }
    return 6;
}
-(void) makeMove: (id)sender {
    NSLog(@"tag: %ld", (long)[[sender view] tag]);
    UIView *parent = [sender view];
    if (moveStarted == 1) {
        //Begin Move
        //Determing Space
        NSString *position;
        if (position == 0) {
            NSLog(@"A1");
            position = [NSString stringWithFormat:@"A,1"];
        }
        if (parent.tag > 0 && parent.tag <=8) {
            NSLog(@"A%ld", (long)parent.tag);
            position = [NSString stringWithFormat:@"A,%ld", (long)parent.tag];
        }
        if (parent.tag >= 9 && parent.tag <=16) {
            position = [NSString stringWithFormat:@"B,%ld", (long)parent.tag-8];
        }
        if (parent.tag >= 17 && parent.tag <=24) {
            position = [NSString stringWithFormat:@"C,%ld", ((long)parent.tag)-16];
        }
        if (parent.tag >= 25 && parent.tag <=32) {
            position = [NSString stringWithFormat:@"D,%ld", ((long)parent.tag)-24];
        }
        if (parent.tag >= 33 && parent.tag <=40) {
            position = [NSString stringWithFormat:@"E,%ld", ((long)parent.tag)-32];
        }
        if (parent.tag >= 41 && parent.tag <=48) {
            position = [NSString stringWithFormat:@"F,%ld", ((long)parent.tag)-40];
        }
        if (parent.tag >= 49 && parent.tag <=56) {
            position = [NSString stringWithFormat:@"G,%ld", ((long)parent.tag)-48];
        }
        if (parent.tag >= 57 && parent.tag <=64) {
            position = [NSString stringWithFormat:@"H,%ld", ((long)parent.tag)-56];
        }
        NSLog(@"Position: %@", position);
        
        if ([possibleMoves containsObject:position]) {
            NSLog(@"We can make this move");
            [self movePiece:[sender view]];
            
            [self checkForCheck];
            
        } else {
            NSLog(@"Invalid Move");
        }
    } else {
        //No move
        message.text = @"Select a Piece";
    }
}

- (void) checkForCheck {

    //Get All Possible Check Positions From King
    //If Any Spaces Are Occupied By Appropriate Piece, still Check
    NSMutableArray *kingPosArray = [[NSMutableArray alloc] init];
    /*if (turn == 0) {
        kingPosArray = wKing;
    } else if (turn == (NSInteger *)1) {
        kingPosArray = bKing;
    }
     */
    NSString *kingStr = (NSString *)[bKing objectAtIndex:0];
    kingPosArray = [kingStr componentsSeparatedByString:@","];
    
    BOOL inCheck = NO;
    //Up Rook, Queen
    NSMutableArray *up = [self posUp:kingPosArray andMoves:8];
    NSMutableArray *down = [self posDown:kingPosArray andMoves:8];
    for (UIView *space in  [board subviews]) {
        for (UIImageView *piece in [space subviews]) {
            NSString *pieceStr = [pieceFind objectForKey:[NSNumber numberWithInt:[piece tag]]];
            if (([pieceStr containsString:@"Castle"] || [pieceStr containsString:@"Queen"]) && [pieceStr containsString:@"White"]) {
                NSString *position = [tagForPosition objectForKey:[NSNumber numberWithInt:[space tag]]];
                if ([up containsObject:position] || [down containsObject:position]) {
                    inCheck = YES;
                    NSLog(@"in check");
                }
            }
        }
    }
    
}
- (void) movePiece: (UIView *)space {
    
    float width = board.frame.size.width / 8;
    float height = board.frame.size.height / 8;
    [selectedPiece removeFromSuperview];
    selectedPiece.frame = (CGRectMake(0, 0, width, height));
    [space addSubview:selectedPiece];
    
    [possibleMoves removeAllObjects];
    [self checkKings];
    [self determineMoves:(id)selectedPiece];
    NSString *wKingStr = [NSString stringWithFormat:@"%@", [wKing objectAtIndex:0]];
    NSString *bKingStr = [NSString stringWithFormat:@"%@", [bKing objectAtIndex:0]];
    if (turn == 0 && [possibleMoves containsObject:bKingStr]) {
        //Check
        message.text = @"Check";
        BKingCheck = YES;
    } else if (turn == (NSInteger *)1 && [possibleMoves containsObject:wKingStr]) {
        //Check
        message.text = @"Check";
        WKingCheck = YES;
    } else {
        message.text = @"Safe - No Check";
        WKingCheck = NO;
        BKingCheck = NO;
    }
    
    moveStarted = 0;
    if (turn == 0) {
        turn = (NSInteger *) 1;
        turnSign.text = @"BLACK";
    } else {
        turn = (NSInteger *) 0;
        turnSign.text = @"WHITE";
    }
    
    
}
-(void) makeTakeMove: (UIView *)opponentsPiece {
    
}
- (void) finalPositions: (NSArray *)allPositionArrays {
    
    NSMutableArray *finalPositions = [[NSMutableArray alloc] init];
    NSLog(@"FULL: %@", allPositionArrays);
    for (int i=0; i<allPositionArrays.count; i++) {
        NSMutableArray *directionArray = [allPositionArrays objectAtIndex:i];
        if (directionArray.count == 0 || directionArray == nil) {
            NSLog(@"NULL: %@", directionArray);
        } else {
            NSLog(@"directionArray:%@", directionArray);
            for (int k=0; k<directionArray.count; k++) {
                //@"%@,%ld"
                NSString *position = (NSString *)[directionArray objectAtIndex:k];
                [finalPositions addObject:position];
            }
        }
    }
    
    possibleMoves = [[NSMutableArray alloc] init];
    [possibleMoves removeAllObjects];
    possibleMoves = finalPositions;
    NSLog(@"FINAL POSITIONS: %@", possibleMoves);
}
- (NSInteger) verifyPosition: (NSString *)positionArrayString {

    NSString *positionString = [positionArrayString stringByReplacingOccurrencesOfString:@"," withString:@""];
    //NSString *positionString = [NSString stringWithFormat:@"%@%@", [positionArray objectAtIndex:0], [positionArray objectAtIndex:1]];
    NSInteger tag = [[positionForTag objectForKey:positionString] integerValue];
    UIView *space = [board viewWithTag:tag];
    //NSLog(@"%@ space:", space);
    //NSLog(@"%@ sub:", [space subviews]);
    if ([[space subviews] count] == 0 || [space subviews] == nil) {
        return 0;
    } else {
        UIImageView *pieceView = [[space subviews] objectAtIndex:0];
        NSNumber *pieceTag = [NSNumber numberWithInt:[pieceView tag]];
        NSString *piece = (NSString *)[pieceFind objectForKey:pieceTag];
        
        if ([piece containsString:@"White_"] == YES && turn == 0) {
            return 1;
        } else if ([piece containsString:@"Black_"] == YES && turn == 1) {
            return 1;
        } else if ([piece containsString:@"White_"] == YES && turn == 1) {
            return 2;
        } else if ([piece containsString:@"Black_"] == YES && turn == 0) {
            return 2;
        } else {
            return 0;
        }
    }
}
- (void) determineMoves: (id)sender {
    if (turn == 0 && WKingCheck == YES) {
        message.text = @"You're in check";
    } else if (turn == (NSInteger *)1 && BKingCheck == YES) {
        message.text = @"You're in check";
    }
    NSLog(@"class: %@", [sender class]);
    UIImageView *selected;
    if ([sender class] == [UITapGestureRecognizer class]) {
    selected = (UIImageView *)[sender view];
    } else if ([sender class] == [UIImageView class]) {
    selected = (UIImageView *)sender;
    }
    UIView *parent = (UIView *)[selected superview];
    NSNumber *pieceTag = [NSNumber numberWithInt:selected.tag];
    NSString *piece = (NSString *)[pieceFind objectForKey:pieceTag];
    if (([piece containsString:@"White_"] == TRUE && turn == 1) || ([piece containsString:@"Black_"] == TRUE && turn == 0)) {
        if (moveStarted == 1) {
            //Selected Opponents Piece After Starting Move
            //NSLog(@"TAKE IT");
            UIImageView *selected = (UIImageView *)[sender view];
            UIView *parent = (UIView *)[selected superview];
            NSNumber *pieceTag = [NSNumber numberWithInt:selected.tag];
            NSString *piece = (NSString *)[pieceFind objectForKey:pieceTag];
            
            if ([piece containsString:@"White_"] == TRUE && turn == 0) {
                message.text = @"You can't take your own piece";
            } else if ([piece containsString:@"Black_"] == TRUE && turn == 1) {
                message.text = @"You cn't take your own piece";
            } else {
                //Lets Take This Piece
            //Determing Space
            NSString *position;
            if (parent.tag > 0 && parent.tag <=8) {
                NSLog(@"A%ld", (long)parent.tag);
                position = [NSString stringWithFormat:@"A,%ld", (long)parent.tag];
            }
            if (parent.tag >= 9 && parent.tag <=16) {
                position = [NSString stringWithFormat:@"B,%ld", (long)parent.tag-8];
            }
            if (parent.tag >= 17 && parent.tag <=24) {
                position = [NSString stringWithFormat:@"C,%ld", ((long)parent.tag)-16];
            }
            if (parent.tag >= 25 && parent.tag <=32) {
                position = [NSString stringWithFormat:@"D,%ld", ((long)parent.tag)-24];
            }
            if (parent.tag >= 33 && parent.tag <=40) {
                position = [NSString stringWithFormat:@"E,%ld", ((long)parent.tag)-32];
            }
            if (parent.tag >= 41 && parent.tag <=48) {
                position = [NSString stringWithFormat:@"F,%ld", ((long)parent.tag)-40];
            }
            if (parent.tag >= 49 && parent.tag <=56) {
                position = [NSString stringWithFormat:@"G,%ld", ((long)parent.tag)-48];
            }
            if (parent.tag >= 57 && parent.tag <=64) {
                position = [NSString stringWithFormat:@"H,%ld", ((long)parent.tag)-56];
            }
                if ([possibleMoves containsObject:position]) {
                    NSLog(@"We can take this piece");
                    [selected removeFromSuperview];
                    [self movePiece:parent];
                } else {
                    NSLog(@"Invalid Move");
                    message.text = @"Can;t take this piece";
                }
            }
        } else {
            NSLog(@"Select Your own piece");
        }
    } else {
//Normal Move
    //Determine Piece
    selectedPiece = selected;
    NSLog(@"Piece Tag: %ld", (long)selected.tag);
    parent = (UIView *)[selected superview];
    NSLog(@"Space Tag: %ld", (long)parent.tag);
    pieceTag = [NSNumber numberWithInt:selected.tag];
    NSLog(@"Piece: %@", [pieceFind objectForKey:pieceTag]);
    piece = (NSString *)[pieceFind objectForKey:pieceTag];
    NSInteger *pieceColor;
    if ([piece containsString:@"White_"] == TRUE) {
        pieceColor = 0;
    } else if ([piece containsString:@"Black_"] == TRUE) {
        pieceColor = (NSInteger *)1;
    } else {
        pieceColor = (NSInteger *)2;
        NSLog(@"determineMoves:");
    }
    
    //0 - White; 1 - Black
    if (turn != pieceColor) {
        message.text = @"Cannot Move Another Player's Piece";
    } else {
        moveStarted = 1;
        message.text = @"Move Started";
    
    
    //Determing Space
    NSString *position;
    if (position == 0) {
        NSLog(@"A1");
        position = [NSString stringWithFormat:@"A.1"];
    }
    if (parent.tag > 0 && parent.tag <=8) {
        NSLog(@"A%ld", (long)parent.tag);
        position = [NSString stringWithFormat:@"A.%ld", (long)parent.tag];
    }
    if (parent.tag >= 9 && parent.tag <=16) {
        position = [NSString stringWithFormat:@"B.%ld", (long)parent.tag-8];
    }
    if (parent.tag >= 17 && parent.tag <=24) {
       position = [NSString stringWithFormat:@"C.%ld", ((long)parent.tag)-16];
    }
    if (parent.tag >= 25 && parent.tag <=32) {
        position = [NSString stringWithFormat:@"D.%ld", ((long)parent.tag)-24];
    }
    if (parent.tag >= 33 && parent.tag <=40) {
        position = [NSString stringWithFormat:@"E.%ld", ((long)parent.tag)-32];
    }
    if (parent.tag >= 41 && parent.tag <=48) {
        position = [NSString stringWithFormat:@"F.%ld", ((long)parent.tag)-40];
    }
    if (parent.tag >= 49 && parent.tag <=56) {
        position = [NSString stringWithFormat:@"G.%ld", ((long)parent.tag)-48];
    }
    if (parent.tag >= 57 && parent.tag <=64) {
        position = [NSString stringWithFormat:@"H.%ld", ((long)parent.tag)-56];
    }
    selectedSpace = position;
    NSLog(@"Position: %@", position);
    
    //Define Some Vars
    letterForNum = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil] forKeys:[NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", nil]];
    numForLetter = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", nil] forKeys:[NSArray arrayWithObjects: [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil]];
    NSArray *positionArray = [position componentsSeparatedByString:@"."];
    NSLog(@"PosArray: %@", positionArray);
    
    NSInteger pieceNumber = [self determinePiece:piece];
    NSMutableArray *posLeft;
    NSMutableArray *posRight;
    NSMutableArray *posUp;
    NSMutableArray *posDown;
    NSMutableArray *diagUpL;
    NSMutableArray *diagUpR;
    NSMutableArray *diagDownL;
    NSMutableArray *diagDownR;
    NSMutableArray *horseUpRight;
    NSMutableArray *horseUpLeft;
    NSMutableArray *horseDownRight;
    NSMutableArray *horseDownLeft;
    
    //Determing All Possible Moves
    switch (pieceNumber) {
        case 0:
            if (turn == 0) {
            NSLog(@"TURN 0");
            posUp = [self posUp:positionArray andMoves:2];
            } else {
            NSLog(@"TURN 1");
            posDown = [self posDown:positionArray andMoves:2];
            }
            break;
        //0-Pawn, 1-Castle, 2-Horse, 3-Bishop, 4-Queen, 5-King
        case 1:
            posLeft = [self posLeft:positionArray andMoves:8];
            posRight = [self posRight:positionArray andMoves:8];
            posUp = [self posUp:positionArray andMoves:8];
            posDown = [self posDown:positionArray andMoves:8];
            break;
        case 2:
            horseUpRight = [self horseUpRight:positionArray];
            horseUpLeft = [self horseUpLeft:positionArray];
            horseDownRight = [self horseDownRight:positionArray];
            horseDownLeft = [self horseDownLeft:positionArray];
            break;
        case 3:
            diagUpL = [self diagUpL:positionArray andMoves:8];
            diagUpR = [self diagUpR:positionArray andMoves:8];
            diagDownR = [self diagDownR:positionArray andMoves:8];
            diagDownL = [self diagDownL:positionArray andMoves:8];
            break;
        case 4:
            posUp = [self posUp:positionArray andMoves:8];
            posDown = [self posDown:positionArray andMoves:8];
            posLeft = [self posLeft:positionArray andMoves:8];
            posRight = [self posRight:positionArray andMoves:8];
            diagUpL = [self diagUpL:positionArray andMoves:8];
            diagUpR = [self diagUpR:positionArray andMoves:8];
            diagDownR = [self diagDownR:positionArray andMoves:8];
            diagDownL = [self diagDownL:positionArray andMoves:8];
            break;
        case 5:
            posUp = [self posUp:positionArray andMoves:1];
            posDown = [self posDown:positionArray andMoves:1];
            posLeft = [self posLeft:positionArray andMoves:1];
            posRight = [self posRight:positionArray andMoves:1];
            diagUpL = [self diagUpL:positionArray andMoves:1];
            diagUpR = [self diagUpR:positionArray andMoves:1];
            diagDownR = [self diagDownR:positionArray andMoves:1];
            diagDownL = [self diagDownL:positionArray andMoves:1];
            break;
        default:
            break;
    }
    
    /*NSMutableArray *posLeft;
    NSMutableArray *posRight;
    NSMutableArray *posUp;
    NSMutableArray *posDown;
    NSMutableArray *diagUpL;
    NSMutableArray *diagUpR;
    NSMutableArray *diagDownL;
    NSMutableArray *diagDownR;
    NSMutableArray *horseUpRight;
    NSMutableArray *horseUpLeft;
    NSMutableArray *horseDownRight;
    NSMutableArray *horseDownLeft;
     */
    
    NSLog(@"Horse Up Left: %@", horseUpLeft);
    NSLog(@"Horse Up Right: %@", horseUpRight);
    
    NSMutableArray *allPositions = [[NSMutableArray alloc] init];
    
    if (posLeft != nil || posLeft.count != 0) {
        NSLog(@"posLeft: %@", posLeft);
        [allPositions addObject:posLeft];
    }
    
    if (posRight != nil || posRight.count != 0) {
    NSLog(@"posRIght: %@", posRight);
    [allPositions addObject:posRight];
    }
    if (posUp != nil || posUp.count != 0) {
    NSLog(@"posUp: %@", posUp);
    [allPositions addObject:posUp];
    }
    if (posDown != nil || posDown.count != 0) {
    NSLog(@"posDown: %@", posDown);
    [allPositions addObject:posDown];
    }
    if (diagUpL != nil || diagUpL.count != 0) {
NSLog(@"diagUpL: %@", diagUpL);
[allPositions addObject:diagUpL];
    }
    if (diagUpR != nil || diagUpR.count != 0) {
NSLog(@"diagUpR: %@", diagUpR);
[allPositions addObject:diagUpR];
    }
    if (diagDownL != nil || diagDownL.count != 0) {
NSLog(@"diagDownL: %@,", diagDownL);
[allPositions addObject:diagDownL];
    }
    if (diagDownR != nil || diagDownR.count != 0) {
NSLog(@"diagDownR: %@,", diagDownR);
[allPositions addObject:diagDownR];
        }
    if (horseUpLeft != nil || horseUpLeft.count != 0) {
NSLog(@"horseUpLeft: %@,", horseUpLeft);
[allPositions addObject:horseUpLeft];
    }
    if (horseUpRight != nil || horseUpRight.count != 0) {
NSLog(@"horseUpRight: %@,", horseUpRight);
[allPositions addObject:horseUpRight];
        }
    if (horseDownLeft != nil || horseDownLeft.count != 0) {
NSLog(@"horseDownLeft: %@,", horseDownLeft);
[allPositions addObject:horseDownLeft];
                    }
    if (horseDownRight != nil || horseDownRight.count != 0) {
NSLog(@"horseDownRight: %@,", horseDownRight);
[allPositions addObject:horseDownRight];
    }
    
    NSLog(@"BEFORE %@", allPositions);
    [self finalPositions:allPositions];
    
    
    
    }
    }
}

-(NSMutableArray *)horseDownRight: (NSArray *)positionArray {
    NSMutableArray *posV1 = [self posHDown:positionArray andMoves:1];
    NSLog(@"POS V1: %@", posV1);
    
    if (posV1.count == 0 || posV1 == nil) {
        return posV1;
    } else {
    NSMutableArray *posV2T = (NSMutableArray *)[(NSString *)[posV1 objectAtIndex:0] componentsSeparatedByString:@","];
    NSLog(@"%@", posV2T);
    
    NSMutableArray *posV2 = [self posHDown:posV2T andMoves:1];
        if (posV2.count == 0 || posV2 == nil) {
            return posV2;
        } else {
        NSMutableArray *posVFT = (NSMutableArray *)[(NSString *)[posV2 objectAtIndex:0] componentsSeparatedByString:@","];
        
        NSMutableArray *posF = [self posHRight:posVFT andMoves:1];
            if (posF.count == 0 || posF == nil) {
                return posF;
            }
            NSString *positionStringB = (NSString *)[posF objectAtIndex:0];
            NSArray *posFArray = [positionStringB componentsSeparatedByString:@","];
            
            //Check if Position is Open or Occupied
            NSInteger verifyResult = [self verifyPosition:positionStringB];
            if (verifyResult == 0 || verifyResult == 2) {
                NSLog(@"Open Space");
                NSLog(@"Possible HUR Position: %@, %@", posFArray[0], posFArray[1]);
            
            } else {
                NSLog(@"Occupied Space");
                NSLog(@"Impossible HUR Position: %@, %@", posFArray[0], posFArray[1]);
                posF = nil;
            }
            
        NSLog(@"HORSE DOWN RIGHT: %@", posF);
        return posF;
        }
    }
}
-(NSMutableArray *)horseDownLeft: (NSArray *)positionArray {
    NSMutableArray *posV1 = [self posHDown:positionArray andMoves:1];
    NSLog(@"POS V1: %@", posV1);
    
    if (posV1.count == 0 || posV1 == nil) {
        return posV1;
    } else {
    NSMutableArray *posV2T = (NSMutableArray *)[(NSString *)[posV1 objectAtIndex:0] componentsSeparatedByString:@","];
    NSLog(@"%@", posV2T);
    
    NSMutableArray *posV2 = [self posHDown:posV2T andMoves:1];
        if (posV2.count == 0 || posV2 == nil) {
            return posV2;
        } else {
        NSMutableArray *posVFT = (NSMutableArray *)[(NSString *)[posV2 objectAtIndex:0] componentsSeparatedByString:@","];
        
        NSMutableArray *posF = [self posHLeft:posVFT andMoves:1];
            if (posF.count == 0 || posF == nil) {
                return posF;
            }
            NSString *positionStringB = (NSString *)[posF objectAtIndex:0];
            NSArray *posFArray = [positionStringB componentsSeparatedByString:@","];
            
            //Check if Position is Open or Occupied
            NSInteger verifyResult = [self verifyPosition:positionStringB];
            if (verifyResult == 0 || verifyResult == 2) {
                NSLog(@"Open Space");
                NSLog(@"Possible HUR Position: %@, %@", posFArray[0], posFArray[1]);
                
            } else {
                NSLog(@"Occupied Space");
                NSLog(@"Impossible HUR Position: %@, %@", posFArray[0], posFArray[1]);
                posF = nil;
            }
        
        NSLog(@"HORSE DOWN LEFT: %@", posF);
        return posF;
        }
    }
}
-(NSMutableArray *)horseUpLeft: (NSArray *)positionArray {
    NSMutableArray *posV1 = [self posHUp:positionArray andMoves:1];
    NSLog(@"POS V1: %@", posV1);
    
    if (posV1.count == 0 || posV1 == nil) {
        return posV1;
    } else {
    NSMutableArray *posV2T = (NSMutableArray *)[(NSString *)[posV1 objectAtIndex:0] componentsSeparatedByString:@","];
    NSLog(@"%@", posV2T);
    
    NSMutableArray *posV2 = [self posHUp:posV2T andMoves:1];
        if (posV2.count == 0 || posV2 == nil) {
            return posV2;
        } else {
        NSMutableArray *posVFT = (NSMutableArray *)[(NSString *)[posV2 objectAtIndex:0] componentsSeparatedByString:@","];
            NSLog(@"POSVFT %@", posVFT);
        NSMutableArray *posF = [self posHLeft:posVFT andMoves:1];
            NSLog(@"posF:%@", posF);
            if (posF.count == 0 || posF == nil) {
                return posF;
            }
            NSString *positionStringB = (NSString *)[posF objectAtIndex:0];
            NSArray *posFArray = [positionStringB componentsSeparatedByString:@","];
            
            //Check if Position is Open or Occupied
            NSInteger verifyResult = [self verifyPosition:positionStringB];
            if (verifyResult == 0 || verifyResult == 2) {
                NSLog(@"Open Space");
                NSLog(@"Possible HUR Position: %@, %@", posFArray[0], posFArray[1]);
                
            } else {
                NSLog(@"Occupied Space");
                NSLog(@"Impossible HUR Position: %@, %@", posFArray[0], posFArray[1]);
                posF = nil;
            }
            
        NSLog(@"HORSE UP LEFT: %@", posF);
        return posF;
        }
    }
}
-(NSMutableArray *)horseUpRight: (NSArray *)positionArray {
    NSMutableArray *posV1 = [self posHUp:positionArray andMoves:1];
    NSLog(@"POS V1: %@", posV1);
    
    if (posV1.count == 0 || posV1 == nil) {
        return posV1;
    } else {
    NSMutableArray *posV2T = (NSMutableArray *)[(NSString *)[posV1 objectAtIndex:0] componentsSeparatedByString:@","];
    NSLog(@"%@", posV2T);
    
    NSMutableArray *posV2 = [self posHUp:posV2T andMoves:1];
        if (posV2.count == 0 || posV2 == nil) {
            return posV2;
        } else {
        NSMutableArray *posVFT = (NSMutableArray *)[(NSString *)[posV2 objectAtIndex:0] componentsSeparatedByString:@","];
        
        NSMutableArray *posF = [self posHRight:posVFT andMoves:1];
            if (posF.count == 0 || posF == nil) {
                return posF;
            }
            NSLog(@"%@", posF);
            NSString *positionStringB = (NSString *)[posF objectAtIndex:0];
            NSArray *posFArray = [positionStringB componentsSeparatedByString:@","];
            
            //Check if Position is Open or Occupied
            NSInteger verifyResult = [self verifyPosition:positionStringB];
            if (verifyResult == 0 || verifyResult == 2) {
                NSLog(@"Open Space");
                NSLog(@"Possible HUR Position: %@, %@", posFArray[0], posFArray[1]);
                
            } else {
                NSLog(@"Occupied Space");
                NSLog(@"Impossible HUR Position: %@, %@", posFArray[0], posFArray[1]);
                posF = nil;
            }
        
        NSLog(@"HORSE UP RIGHT: %@", posF);
        return posF;
        }
    }
}
-(NSMutableArray *)diagDownL: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSInteger currentRow = [[positionArray objectAtIndex:1] integerValue];
    NSInteger currentColumn = [[letterForNum objectForKey:[positionArray objectAtIndex:0]]integerValue];
    message.text = [NSString stringWithFormat:@"Current Row: %ld; Current Column: %ld", (long)currentRow, (long)currentColumn];
    for (int i=0; i<canMoveMore; i++) {
        NSInteger newRow = 0;
        //Find Up Direction and New Row
        if (turn == (NSInteger *) 0) {
            newRow = currentRow + (1 + i);
        }
        if (turn == (NSInteger *) 1) {
            newRow = currentRow - (1 + i);
        }
        if (newRow < 1 || newRow > 8) {
            //End of Board
        } else {
            
            NSString *newLetter = @"";
            //Find New Column
            NSInteger newColumn = currentColumn - (1 + i);
            if (newColumn > 0) {
                NSNumber *newColN = [NSNumber numberWithInt:newColumn];
                newLetter = (NSString *)[numForLetter objectForKey:newColN];
                NSString *newPos = [NSString stringWithFormat:@"%@,%ld", newLetter, (long)newRow];
                //Check if Position is Open or Occupied
                NSInteger verifyResult = [self verifyPosition:newPos];
                if (verifyResult == 0) {
                    NSLog(@"Open Space");
                    NSLog(@"Possible DL Position: %@, %ld", newLetter, (long)newRow);
                    [positionsPossible addObject:newPos];
                } else if (verifyResult == 2) {
                    NSLog(@"Occupied By Opponent");
                    NSLog(@"Possible Position");
                    [positionsPossible addObject:newPos];
                    i = canMoveMore;
                } else {
                    NSLog(@"Occupied Space");
                    NSLog(@"Impossible DL Position: %@, %ld", newLetter, (long)newRow);
                    i = canMoveMore;
                }
            }
        }
    }
    NSLog(@"DIAG DOWN LEFT%@", positionsPossible);
    return positionsPossible;
}
-(NSMutableArray *)diagUpR: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSInteger currentRow = [[positionArray objectAtIndex:1] integerValue];
    NSInteger currentColumn = [[letterForNum objectForKey:[positionArray objectAtIndex:0]]integerValue];
    message.text = [NSString stringWithFormat:@"Current Row: %ld; Current Column: %ld", (long)currentRow, (long)currentColumn];
    for (int i=0; i<canMoveMore; i++) {
        NSInteger newRow = 0;
        //Find Up Direction and New Row
        if (turn == (NSInteger *) 0) {
            newRow = currentRow - (1 + i);
        }
        if (turn == (NSInteger *) 1) {
            newRow = currentRow + (1 + i);
        }
        if (newRow < 1 || newRow > 8) {
            //End of Board
        } else {
        
        NSString *newLetter = @"";
        //Find New Column
        NSInteger newColumn = currentColumn + (1 + i);
        if (newColumn < 9) {
            NSNumber *newColN = [NSNumber numberWithInt:newColumn];
            newLetter = (NSString *)[numForLetter objectForKey:newColN];
            NSString *newPos = [NSString stringWithFormat:@"%@,%ld", newLetter, (long)newRow];
            //Check if Position is Open or Occupied
            NSInteger verifyResult = [self verifyPosition:newPos];
            if (verifyResult == 0) {
                NSLog(@"Open Space");
                NSLog(@"Possible UR Position: %@, %ld", newLetter, (long)newRow);
                [positionsPossible addObject:newPos];
            } else if (verifyResult == 2) {
                NSLog(@"Occupied By Opponent");
                NSLog(@"Possible Position");
                [positionsPossible addObject:newPos];
                i = canMoveMore;
            } else {
                NSLog(@"Occupied Space");
                NSLog(@"Impossible UR Position: %@, %ld", newLetter, (long)newRow);
                i = canMoveMore;
            }
        }
    }
    }
    NSLog(@"DIAG UP RIGHT%@", positionsPossible);
    return positionsPossible;
}
-(NSMutableArray *)diagDownR: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSInteger currentRow = [[positionArray objectAtIndex:1] integerValue];
    NSInteger currentColumn = [[letterForNum objectForKey:[positionArray objectAtIndex:0]]integerValue];
    message.text = [NSString stringWithFormat:@"Current Row: %ld; Current Column: %ld", (long)currentRow, (long)currentColumn];
    for (int i=0; i<canMoveMore; i++) {
        NSInteger newRow = 0;
        //Find Up Direction and New Row
        if (turn == (NSInteger *) 0) {
            newRow = currentRow + (1 + i);
        }
        if (turn == (NSInteger *) 1) {
            newRow = currentRow - (1 + i);
        }
        if (newRow < 1 || newRow > 8) {
            //End of Board
        } else {
        
        NSString *newLetter = @"";
        //Find New Column
        NSInteger newColumn = currentColumn + (1 + i);
        if (newColumn < 9) {
            NSNumber *newColN = [NSNumber numberWithInt:newColumn];
            newLetter = (NSString *)[numForLetter objectForKey:newColN];
            NSString *newPos = [NSString stringWithFormat:@"%@,%ld", newLetter, (long)newRow];
            //Check if Position is Open or Occupied
            NSInteger verifyResult = [self verifyPosition:newPos];
            if (verifyResult == 0) {
                NSLog(@"Open Space");
                NSLog(@"Possible DR Position: %@, %ld", newLetter, (long)newRow);
                [positionsPossible addObject:newPos];
            } else if (verifyResult == 2) {
                NSLog(@"Occupied By Opponent");
                NSLog(@"Possible Position");
                [positionsPossible addObject:newPos];
                i = canMoveMore;
            } else {
                NSLog(@"Occupied Space");
                NSLog(@"Impossible DR Position: %@, %ld", newLetter, (long)newRow);
                i = canMoveMore;
            }
        }
    }
    }
    NSLog(@"DIAG DOWN RIGHT%@", positionsPossible);
    return positionsPossible;
}
-(NSMutableArray *)diagUpL: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSInteger currentRow = [[positionArray objectAtIndex:1] integerValue];
    NSInteger currentColumn = [[letterForNum objectForKey:[positionArray objectAtIndex:0]]integerValue];
    message.text = [NSString stringWithFormat:@"Current Row: %ld; Current Column: %ld", (long)currentRow, (long)currentColumn];
    for (int i=0; i<canMoveMore; i++) {
    NSInteger newRow = 0;
    //Find Up Direction and New Row
    if (turn == (NSInteger *) 0) {
        newRow = currentRow - (1 + i);
    }
    if (turn == (NSInteger *) 1) {
        newRow = currentRow + (1 + i);
    }
    if (newRow < 1 || newRow > 8) {
        //End of Board
    } else {
    
    NSString *newLetter = @"";
    //Find New Column
    NSInteger newColumn = currentColumn - (1 + i);
    if (newColumn > 0) {
        NSNumber *newColN = [NSNumber numberWithInt:newColumn];
        newLetter = (NSString *)[numForLetter objectForKey:newColN];
        NSString *newPos = [NSString stringWithFormat:@"%@,%ld", newLetter, (long)newRow];
        //Check if Position is Open or Occupied
        NSLog(@"NEWPOS: %@", newPos);
        NSInteger verifyResult = [self verifyPosition:newPos];
        if (verifyResult == 0) {
            NSLog(@"Open Space");
            NSLog(@"Possible UL Position: %@, %ld", newLetter, (long)newRow);
            [positionsPossible addObject:newPos];
        } else if (verifyResult == 2) {
            NSLog(@"Occupied By Opponent");
            NSLog(@"Possible Position");
            [positionsPossible addObject:newPos];
            i = canMoveMore;
        } else {
            NSLog(@"Occupied Space");
            NSLog(@"Impossible UL Position: %@, %ld", newLetter, (long)newRow);
            i = canMoveMore;
        }
    }
    }
    }
    NSLog(@"DIAG UP LEFT %@", positionsPossible);
    return positionsPossible;
}
-(NSMutableArray *)posDown: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSString *currentString = [positionArray objectAtIndex:1];
    NSInteger currentRow = [currentString integerValue];
    NSInteger newRow = 0;
    
    for (int i=0; i<canMoveMore; i++) {
    /*if (turn == (NSInteger *) 0) {*/
        newRow = currentRow + (i+1);
    /*}
    if (turn == (NSInteger *) 1) {
        newRow = currentRow - (i+1);
    }
     */
        //NSLog(@"NEWROW: %ld", (long)newRow);
    if (newRow < 1 || newRow > 8) {
        
    } else {
        NSLog(@"POSARRAY: %@", positionArray);
        NSLog(@"Possible Down Position: %@, %ld", positionArray[0], (long)newRow);
        NSString *returnS = [NSString stringWithFormat:@"%@,%ld", positionArray[0], (long)newRow];
        //Check if Position is Open or Occupied
        NSInteger verifyResult = [self verifyPosition:returnS];
        if (verifyResult == 0) {
            NSLog(@"Open Space");
            NSLog(@"Possible Up Position: %@, %ld", positionArray[0], (long)newRow);
            [positionsPossible addObject:returnS];
        } else if (verifyResult == 2) {
            NSLog(@"Occupied By Opponent");
            NSLog(@"Possible Position");
            [positionsPossible addObject:returnS];
            i = canMoveMore;
        } else {
            NSLog(@"Occupied Space");
            NSLog(@"Impossible Down Position: %@, %ld", positionArray[0], (long)newRow);
            i = canMoveMore;
        }
        
    }
    }
    return positionsPossible;
}
-(NSMutableArray *)posUp: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSString *currentString = [positionArray objectAtIndex:1];
    NSInteger currentRow = [currentString integerValue];
    NSInteger newRow = 0;
    
    for (int i = 0; i<canMoveMore; i++) {
    //if (turn == (NSInteger *) 0) {
        newRow = currentRow - (i+1);
   /* }
    if (turn == (NSInteger *) 1) {
        newRow = currentRow + (i+1);
    }
    */
    if (newRow < 1 || newRow > 8) {
        //End of Board
    } else {
        
        NSString *returnS = [NSString stringWithFormat:@"%@,%ld", positionArray[0], (long)newRow];
        //Check if Position is Open or Occupied
        NSInteger verifyResult = [self verifyPosition:returnS];
        if (verifyResult == 0) {
            NSLog(@"Open Space");
            NSLog(@"Possible Up Position: %@, %ld", positionArray[0], (long)newRow);
            [positionsPossible addObject:returnS];
        } else if (verifyResult == 2) {
            NSLog(@"Occupied By Opponent");
            NSLog(@"Possible Position");
            [positionsPossible addObject:returnS];
            i = canMoveMore;
        } else if (verifyResult == 1) {
            NSLog(@"Occupied Space");
            NSLog(@"Impossible Up Position: %@, %ld", positionArray[0], (long)newRow);
            i = canMoveMore;
        }
        
    }
    }
    
    return positionsPossible;
}
- (NSMutableArray *)posRight: (NSArray *)positionArray andMoves:(int)canMoveMore {
    //Position to the Right
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSNumber *operator = [letterForNum objectForKey:(NSString *)[positionArray objectAtIndex:0]];
    
    for (int i=0; i<canMoveMore; i++) {
    NSInteger newCol = [operator integerValue] + (i+1);
    if (newCol < 9) {
        NSNumber *newColN = [NSNumber numberWithInt:newCol];
        NSString *newLetter = (NSString *)[numForLetter objectForKey:newColN];
        NSLog(@"Possible Right Position: %@, %@", newLetter, positionArray[1]);
        NSString *returnS = [NSString stringWithFormat:@"%@,%@", newLetter, positionArray[1]];
        //Check if Position is Open or Occupied
        NSInteger verifyResult = [self verifyPosition:returnS];
        if (verifyResult == 0) {
            NSLog(@"Open Space");
            NSLog(@"Possible Right Position: %@, %@", newLetter, positionArray[1]);
            [positionsPossible addObject:returnS];
        } else if (verifyResult == 2) {
            NSLog(@"Occupied By Opponent");
            NSLog(@"Possible Position");
            [positionsPossible addObject:returnS];
            i = canMoveMore;
        } else {
            NSLog(@"Occupied Space");
            NSLog(@"Impossible Right Position: %@, %@", newLetter, positionArray[1]);
            i = canMoveMore;
        }
    }
    }
    return positionsPossible;
}
- (NSMutableArray *)posLeft: (NSArray *)positionArray andMoves:(int)canMoveMore {
    
    //Position to Left
    NSMutableArray *possiblePositions = [[NSMutableArray alloc] init];
    NSNumber *operator = [letterForNum objectForKey:(NSString *)[positionArray objectAtIndex:0]];
    
    for (int i=0; i<canMoveMore; i++) {
    NSInteger newCol = [operator integerValue] - (i+1);
    //NSLog(@"operator: %@", operator);
    //NSLog(@"newCol: %ld", (long)newCol);
    if (newCol > 0) {
        NSNumber *newColN = [NSNumber numberWithInt:newCol];
        NSString *newLetter = (NSString *)[numForLetter objectForKey:newColN];
        NSLog(@"Possible Left Position: %@, %@", newLetter, positionArray[1]);
        NSString *returnS = [NSString stringWithFormat:@"%@,%@", newLetter, positionArray[1]];
        //Check if Position is Open or Occupied
        NSInteger verifyResult = [self verifyPosition:returnS];
        if (verifyResult == 0) {
            NSLog(@"Open Space");
            NSLog(@"Possible Left Position: %@, %@", newLetter, positionArray[1]);
            [possiblePositions addObject:returnS];
        } else if (verifyResult == 2) {
            NSLog(@"Occupied By Opponent");
            NSLog(@"Possible Position");
            [possiblePositions addObject:returnS];
            i = canMoveMore;
        } else {
            NSLog(@"Occupied Space");
            NSLog(@"Impossible Left Position: %@, %@", newLetter, positionArray[1]);
            i = canMoveMore;
        }
    }
    }
    return possiblePositions;
}
-(NSMutableArray *)posHDown: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSString *currentString = [positionArray objectAtIndex:1];
    NSInteger currentRow = [currentString integerValue];
    NSInteger newRow = 0;
    
    for (int i=0; i<canMoveMore; i++) {
        /*if (turn == (NSInteger *) 0) {*/
        newRow = currentRow + (i+1);
        /*}
         if (turn == (NSInteger *) 1) {
         newRow = currentRow - (i+1);
         }
         */
        //NSLog(@"NEWROW: %ld", (long)newRow);
        if (newRow < 1 || newRow > 8) {
            
        } else {
            NSLog(@"POSARRAY: %@", positionArray);
            NSLog(@"Possible Down Position: %@, %ld", positionArray[0], (long)newRow);
            NSString *returnS = [NSString stringWithFormat:@"%@,%ld", positionArray[0], (long)newRow];
            //Check if Position is Open or Occupied
            
                [positionsPossible addObject:returnS];
            
            
        }
    }
    return positionsPossible;
}
-(NSMutableArray *)posHUp: (NSArray *)positionArray andMoves:(int)canMoveMore {
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSString *currentString = [positionArray objectAtIndex:1];
    NSInteger currentRow = [currentString integerValue];
    NSInteger newRow = 0;
    
    for (int i = 0; i<canMoveMore; i++) {
        //if (turn == (NSInteger *) 0) {
        newRow = currentRow - (i+1);
        /* }
         if (turn == (NSInteger *) 1) {
         newRow = currentRow + (i+1);
         }
         */
        if (newRow < 1 || newRow > 8) {
            //End of Board
        } else {
            
            NSString *returnS = [NSString stringWithFormat:@"%@,%ld", positionArray[0], (long)newRow];

                [positionsPossible addObject:returnS];

            
        }
    }
    
    return positionsPossible;
}
- (NSMutableArray *)posHRight: (NSArray *)positionArray andMoves:(int)canMoveMore {
    //Position to the Right
    NSMutableArray *positionsPossible = [[NSMutableArray alloc] init];
    NSNumber *operator = [letterForNum objectForKey:(NSString *)[positionArray objectAtIndex:0]];
    
    for (int i=0; i<canMoveMore; i++) {
        NSInteger newCol = [operator integerValue] + (i+1);
        if (newCol < 9) {
            NSNumber *newColN = [NSNumber numberWithInt:newCol];
            NSString *newLetter = (NSString *)[numForLetter objectForKey:newColN];
            NSLog(@"Possible Right Position: %@, %@", newLetter, positionArray[1]);
            NSString *returnS = [NSString stringWithFormat:@"%@,%@", newLetter, positionArray[1]];
            [positionsPossible addObject:returnS];
        }
    }
    return positionsPossible;
}
- (NSMutableArray *)posHLeft: (NSArray *)positionArray andMoves:(int)canMoveMore {
    
    //Position to Left
    NSMutableArray *possiblePositions = [[NSMutableArray alloc] init];
    NSNumber *operator = [letterForNum objectForKey:(NSString *)[positionArray objectAtIndex:0]];
    
    for (int i=0; i<canMoveMore; i++) {
        NSInteger newCol = [operator integerValue] - (i+1);
        //NSLog(@"operator: %@", operator);
        //NSLog(@"newCol: %ld", (long)newCol);
        if (newCol > 0) {
            NSNumber *newColN = [NSNumber numberWithInt:newCol];
            NSString *newLetter = (NSString *)[numForLetter objectForKey:newColN];
            NSLog(@"Possible Left Position: %@, %@", newLetter, positionArray[1]);
            NSString *returnS = [NSString stringWithFormat:@"%@,%@", newLetter, positionArray[1]];
            [possiblePositions addObject:returnS];
        }
    }
    return possiblePositions;
}

- (void)viewDidLoad {
    A1.tag = 1;
    [self readTags];
    [self renderPieces];
    pieces = [NSArray arrayWithObjects: BPawn1,  BPawn2,  BPawn3,  BPawn4,  BPawn5, BPawn6, BPawn7, BPawn8, BCastle1, BHorse1, BBishop1, BQueen, BKing, BBishop2, BHorse2, BCastle2, WPawn1, WPawn2, WPawn3, WPawn4, WPawn5, WPawn6, WPawn7, WPawn8, WCastle1, WHorse1, WBishop1, WQueen, WKing, WBishop2, WHorse2, WCastle2, nil];
    piecesStrings = [NSArray arrayWithObjects: @"Black_Pawn1",  @"Black_Pawn2",  @"Black_Pawn3",  @"Black_Pawn4",  @"Black_Pawn5", @"Black_Pawn6", @"Black_Pawn7", @"Black_Pawn8", @"Black_Castle1", @"Black_Horse1", @"Black_Bishop1", @"Black_Queen", @"Black_King", @"Black_Bishop2", @"Black_Horse2", @"Black_Castle2", @"White_Pawn1", @"White_Pawn2", @"White_Pawn3", @"White_Pawn4", @"White_Pawn5", @"White_Pawn6", @"White_Pawn7", @"White_Pawn8", @"White_Castle1", @"White_Horse1", @"White_Bishop1", @"White_Queen", @"White_King", @"White_Bishop2", @"White_Horse2", @"White_Castle2", nil];
    NSArray *keys = [NSArray arrayWithObjects:@100,@101,@102,@103,@104,@105,@106,@107,@108,@109,@110, @111, @112, @113, @114, @115, @200, @201, @202, @203, @204, @205, @206, @207, @208, @209, @210, @211, @212, @213, @214, @215, nil];
    pieceFind = [NSDictionary dictionaryWithObjects:piecesStrings forKeys:keys];
    
    NSArray *positions = [NSArray arrayWithObjects:@"A1" , @"A2" , @"A3" , @"A4" , @"A5" , @"A6" , @"A7" , @"A8" , @"B1" , @"B2" , @"B3" , @"B4" , @"B5" , @"B6" , @"B7" , @"B8" , @"C1" , @"C2" , @"C3" , @"C4" , @"C5" , @"C6" , @"C7" , @"C8" , @"D1" , @"D2" , @"D3" , @"D4" , @"D5" , @"D6" , @"D7" , @"D8" , @"E1" , @"E2" , @"E3" , @"E4" , @"E5" , @"E6" , @"E7" , @"E8" , @"F1" , @"F2" , @"F3" , @"F4" , @"F5" , @"F6" , @"F7" , @"F8" , @"G1" , @"G2" , @"G3" , @"G4" , @"G5" , @"G6" , @"G7" , @"G8" , @"H1" , @"H2" , @"H3" , @"H4" , @"H5" , @"H6" , @"H7" , @"H8", nil];
    NSArray *rectS = [NSArray arrayWithObjects:[NSValue valueWithCGRect: A1.frame] , [NSValue valueWithCGRect:B1.frame] , [NSValue valueWithCGRect:C1.frame] , [NSValue valueWithCGRect:D1.frame] , [NSValue valueWithCGRect:E1.frame] , [NSValue valueWithCGRect:F1.frame] , [NSValue valueWithCGRect:G1.frame] , [NSValue valueWithCGRect:H1.frame] , [NSValue valueWithCGRect:A2.frame] , [NSValue valueWithCGRect:B2.frame] , [NSValue valueWithCGRect:C2.frame] , [NSValue valueWithCGRect:D2.frame] , [NSValue valueWithCGRect:E2.frame] , [NSValue valueWithCGRect:F2.frame] , [NSValue valueWithCGRect:G2.frame] , [NSValue valueWithCGRect:H2.frame] , [NSValue valueWithCGRect:A3.frame] , [NSValue valueWithCGRect:B3.frame] , [NSValue valueWithCGRect:C3.frame] , [NSValue valueWithCGRect:D3.frame] , [NSValue valueWithCGRect:E3.frame] , [NSValue valueWithCGRect:F3.frame] , [NSValue valueWithCGRect:G3.frame] , [NSValue valueWithCGRect:H3.frame] , [NSValue valueWithCGRect:A4.frame] , [NSValue valueWithCGRect:B4.frame] , [NSValue valueWithCGRect:C4.frame] , [NSValue valueWithCGRect:D4.frame] , [NSValue valueWithCGRect:E4.frame] , [NSValue valueWithCGRect:F4.frame] , [NSValue valueWithCGRect:G4.frame] , [NSValue valueWithCGRect:H4.frame] , [NSValue valueWithCGRect:A5.frame] , [NSValue valueWithCGRect:B5.frame] , [NSValue valueWithCGRect:C5.frame] , [NSValue valueWithCGRect:D5.frame] , [NSValue valueWithCGRect:E5.frame] , [NSValue valueWithCGRect:F5.frame] , [NSValue valueWithCGRect:G5.frame] , [NSValue valueWithCGRect:H5.frame] , [NSValue valueWithCGRect:A6.frame] , [NSValue valueWithCGRect:B6.frame] , [NSValue valueWithCGRect:C6.frame] , [NSValue valueWithCGRect:D6.frame] , [NSValue valueWithCGRect:E6.frame] , [NSValue valueWithCGRect:F6.frame] , [NSValue valueWithCGRect:G6.frame] , [NSValue valueWithCGRect:H6.frame] , [NSValue valueWithCGRect:A7.frame] , [NSValue valueWithCGRect:B7.frame] , [NSValue valueWithCGRect:C7.frame] , [NSValue valueWithCGRect:D7.frame] , [NSValue valueWithCGRect:E7.frame] , [NSValue valueWithCGRect:F7.frame] , [NSValue valueWithCGRect:G7.frame] , [NSValue valueWithCGRect:H7.frame] , [NSValue valueWithCGRect:A8.frame] , [NSValue valueWithCGRect:B8.frame] , [NSValue valueWithCGRect:C8.frame] , [NSValue valueWithCGRect:D8.frame] , [NSValue valueWithCGRect:E8.frame] , [NSValue valueWithCGRect:F8.frame] , [NSValue valueWithCGRect:G8.frame] , [NSValue valueWithCGRect:H8.frame], nil];
    
    positionStringForRect = [NSDictionary dictionaryWithObjects:rectS forKeys:positions];
    
    NSArray *spaces = [NSArray arrayWithObjects:@"A1", @"A2", @"A3", @"A4", @"A5", @"A6", @"A7", @"A8", @"B1", @"B2", @"B3", @"B4", @"B5", @"B6", @"B7", @"B8", @"C1", @"C2", @"C3", @"C4", @"C5", @"C6", @"C7", @"C8", @"D1", @"D2", @"D3", @"D4", @"D5", @"D6", @"D7", @"D8", @"E1", @"E2", @"E3", @"E4", @"E5", @"E6", @"E7", @"E8", @"F1", @"F2", @"F3", @"F4", @"F5", @"F6", @"F7", @"F8", @"G1", @"G2", @"G3", @"G4", @"G5", @"G6", @"G7", @"G8", @"H1", @"H2", @"H3", @"H4", @"H5", @"H6", @"H7", @"H8", nil];
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (int i=1; i<65; i++) {
        [tags addObject:[NSNumber numberWithInt:i]];
    }
    positionForTag = [NSDictionary dictionaryWithObjects:tags forKeys:spaces];
    tagForPosition = [NSDictionary dictionaryWithObjects:spaces forKeys:tags];
    [self addTags];
    [self addListeners];
    
    moveStarted = 0;
    turn = 0;
    turnSign.text = @"WHITE";
    
    /*NSLog(@"Default Rect: %@", NSStringFromCGRect(A8.frame));
    CGRect area = [[positionStringForRect objectForKey:@"A8"] CGRectValue];
    NSLog(@"Dict Rect: %@", NSStringFromCGRect(area));
    for (UIView *aView in [board subviews]) {
        //NSLog(@"%@", aView);
        if(CGRectContainsRect(area,aView.frame)) {
            NSLog(@"aView: %@", aView);
            NSLog(@"tag: %ld", (long)aView.tag);
        }
    }
     */
    //NSLog(@"%@");
    [self checkKings];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) addTags {
    
    // 100 -107 are Black Pawns
    //108-115 are Black Pieces
    //200-208 are White Pawns
    //208-215 are White Pieces
    
    NSInteger tagN = 100;
    for (int i=0; i<32; i++) {
        if (tagN == 116) {
            tagN = 200;
        }
        UIImageView *imageView = [pieces objectAtIndex:i];
        imageView.tag = tagN;
        tagN ++;
    }
}
-(void) addListeners {
    
    for (int i=0; i<32; i++) {
        UIImageView *imageView = [pieces objectAtIndex:i];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(determineMoves:)];
        tap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tap];
    }
    
    NSArray *boardSpots = [NSArray arrayWithObjects: A1, A2, A3, A4, A5, A6, A7, A8, B1, B2, B3, B4, B5, B6, B7, B8, C1, C2, C3, C4, C5, C6, C7, C8, D1, D2, D3, D4, D5, D6, D7, D8, E1, E2, E3, E4, E5, E6, E7, E8, F1, F2, F3, F4, F5, F6, F7, F8, G1, G2, G3, G4, G5, G6, G7, G8, H1, H2, H3, H4, H5, H6, H7, H8, nil];
    for (int i=0; i<boardSpots.count; i++) {
        UIView *view = [boardSpots objectAtIndex:i];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeMove:)];
        tap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tap];
    }
    
    
}
-(void) addDescription {}
-(void) renderPieces {
    
    NSLog(@"%f %f", A1.bounds.size.height, A1.bounds.size.width);
    float width = board.frame.size.width / 8;
    float height = board.frame.size.height / 8;
    
    //Pawns
        //Black
    BPawn1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BPawn2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BPawn3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BPawn4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BPawn5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BPawn6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BPawn7 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BPawn8 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    BPawn1.image = [UIImage imageNamed:@"BPawn"];
    BPawn2.image = [UIImage imageNamed:@"BPawn"];
    BPawn3.image = [UIImage imageNamed:@"BPawn"];
    BPawn4.image = [UIImage imageNamed:@"BPawn"];
    BPawn5.image = [UIImage imageNamed:@"BPawn"];
    BPawn6.image = [UIImage imageNamed:@"BPawn"];
    BPawn7.image = [UIImage imageNamed:@"BPawn"];
    BPawn8.image = [UIImage imageNamed:@"BPawn"];
    
    [B1 addSubview:BPawn1];
    [B2 addSubview:BPawn2];
    [B3 addSubview:BPawn3];
    [B4 addSubview:BPawn4];
    [B5 addSubview:BPawn5];
    [B6 addSubview:BPawn6];
    [B7 addSubview:BPawn7];
    [B8 addSubview:BPawn8];
    
        //White
    WPawn1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WPawn2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WPawn3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WPawn4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WPawn5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WPawn6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WPawn7 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WPawn8 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    WPawn1.image = [UIImage imageNamed:@"WPawn"];
    WPawn2.image = [UIImage imageNamed:@"WPawn"];
    WPawn3.image = [UIImage imageNamed:@"WPawn"];
    WPawn4.image = [UIImage imageNamed:@"WPawn"];
    WPawn5.image = [UIImage imageNamed:@"WPawn"];
    WPawn6.image = [UIImage imageNamed:@"WPawn"];
    WPawn7.image = [UIImage imageNamed:@"WPawn"];
    WPawn8.image = [UIImage imageNamed:@"WPawn"];
    
    [G1 addSubview:WPawn1];
    [G2 addSubview:WPawn2];
    [G3 addSubview:WPawn3];
    [G4 addSubview:WPawn4];
    [G5 addSubview:WPawn5];
    [G6 addSubview:WPawn6];
    [G7 addSubview:WPawn7];
    [G8 addSubview:WPawn8];
     
    
    //Castles
    BCastle1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BCastle2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WCastle1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WCastle2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    BCastle1.image = [UIImage imageNamed:@"BCastle"];
    BCastle2.image = [UIImage imageNamed:@"BCastle"];
    WCastle1.image = [UIImage imageNamed:@"WCastle"];
    WCastle2.image = [UIImage imageNamed:@"WCastle"];
    
    [A1 addSubview:BCastle1];
    [A8 addSubview:BCastle2];
    [H1 addSubview:WCastle1];
    [H8 addSubview:WCastle2];
    
    //Horses
    BHorse1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BHorse2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WHorse1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WHorse2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    BHorse1.image = [UIImage imageNamed:@"BHorse"];
    BHorse2.image = [UIImage imageNamed:@"BHorse"];
    WHorse1.image = [UIImage imageNamed:@"WHorse"];
    WHorse2.image = [UIImage imageNamed:@"WHorse"];
    
    [A2 addSubview:BHorse1];
    [A7 addSubview:BHorse2];
    [H2 addSubview:WHorse1];
    [H7 addSubview:WHorse2];
    
    //Bishops
    BBishop1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    BBishop2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WBishop1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WBishop2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    BBishop1.image = [UIImage imageNamed:@"BBishop"];
    BBishop2.image = [UIImage imageNamed:@"BBishop"];
    WBishop1.image = [UIImage imageNamed:@"WBishop"];
    WBishop2.image = [UIImage imageNamed:@"WBishop"];
    
    [A3 addSubview:BBishop1];
    [A6 addSubview:BBishop2];
    [H3 addSubview:WBishop1];
    [H6 addSubview:WBishop2];
    
    //Queen
    BQueen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WQueen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    BQueen.image = [UIImage imageNamed:@"BQueen"];
    WQueen.image = [UIImage imageNamed:@"WQueen"];
    
    [A4 addSubview:BQueen];
    [H4 addSubview:WQueen];
    
    //King
    BKing = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    WKing = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    BKing.image = [UIImage imageNamed:@"BKing"];
    WKing.image = [UIImage imageNamed:@"WKing"];
    
    [A5 addSubview:BKing];
    [H5 addSubview:WKing];
    
    
    
    
}
-(void) readTags {
    
    A1 = [board viewWithTag:0];
    B1 = [board viewWithTag:2];
    C1 = [board viewWithTag:3];
    D1 = [board viewWithTag:4];
    E1 = [board viewWithTag:5];
    F1 = [board viewWithTag:6];
    G1 = [board viewWithTag:7];
    H1 = [board viewWithTag:8];
    
    A2 = [board viewWithTag:9];
    B2 = [board viewWithTag:10];
    C2 = [board viewWithTag:11];
    D2 = [board viewWithTag:12];
    E2 = [board viewWithTag:13];
    F2 = [board viewWithTag:14];
    G2 = [board viewWithTag:15];
    H2 = [board viewWithTag:16];
    
    A3 = [board viewWithTag:17];
    B3 = [board viewWithTag:18];
    C3 = [board viewWithTag:19];
    D3 = [board viewWithTag:20];
    E3 = [board viewWithTag:21];
    F3 = [board viewWithTag:22];
    G3 = [board viewWithTag:23];
    H3 = [board viewWithTag:24];
    
    A4 = [board viewWithTag:25];
    B4 = [board viewWithTag:26];
    C4 = [board viewWithTag:27];
    D4 = [board viewWithTag:28];
    E4 = [board viewWithTag:29];
    F4 = [board viewWithTag:30];
    G4 = [board viewWithTag:31];
    H4 = [board viewWithTag:32];
    
    A5 = [board viewWithTag:33];
    B5 = [board viewWithTag:34];
    C5 = [board viewWithTag:35];
    D5 = [board viewWithTag:36];
    E5 = [board viewWithTag:37];
    F5 = [board viewWithTag:38];
    G5 = [board viewWithTag:39];
    H5 = [board viewWithTag:40];
    
    A6 = [board viewWithTag:41];
    B6 = [board viewWithTag:42];
    C6 = [board viewWithTag:43];
    D6 = [board viewWithTag:44];
    E6 = [board viewWithTag:45];
    F6 = [board viewWithTag:46];
    G6 = [board viewWithTag:47];
    H6 = [board viewWithTag:48];
    
    A7 = [board viewWithTag:49];
    B7 = [board viewWithTag:50];
    C7 = [board viewWithTag:51];
    D7 = [board viewWithTag:52];
    E7 = [board viewWithTag:53];
    F7 = [board viewWithTag:54];
    G7 = [board viewWithTag:55];
    H7 = [board viewWithTag:56];
    
    A8 = [board viewWithTag:57];
    B8 = [board viewWithTag:58];
    C8 = [board viewWithTag:59];
    D8 = [board viewWithTag:60];
    E8 = [board viewWithTag:61];
    F8 = [board viewWithTag:62];
    G8 = [board viewWithTag:63];
    H8 = [board viewWithTag:64];
}

@end
