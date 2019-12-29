//
//  ViewController.h
//  Chess
//
//  Created by Lance Sigersmith on 11/14/18.
//  Copyright © 2018 Lance Sigersmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    BOOL WKingCheck;
    BOOL BKingCheck;
    
    NSArray *pieces;
    NSArray *piecesStrings;
    NSDictionary *pieceFind;
    NSInteger *turn; //0-White 1-Black
    NSDictionary *letterForNum;
    NSDictionary *numForLetter;
    NSInteger moveStarted; //0 - No // 1 - Yes
    NSDictionary *positionStringForRect;
    NSDictionary *positionForTag;
    NSDictionary *tagForPosition;
    
    NSMutableArray *possibleMoves;
    UIImageView *selectedPiece;
    NSString *selectedSpace;
    
    NSMutableArray *wKing;
    NSMutableArray *bKing;
    
    IBOutlet UIView *board;
    IBOutlet UILabel *message;
    IBOutlet UILabel *turnSign;
    
    UIView *A1;
     UIView *A2;
     UIView *A3;
     UIView *A4;
     UIView *A5;
     UIView *A6;
     UIView *A7;
     UIView *A8;
    
     UIView *B1;
     UIView *B2;
     UIView *B3;
     UIView *B4;
     UIView *B5;
     UIView *B6;
     UIView *B7;
     UIView *B8;
    
     UIView *C1;
     UIView *C2;
     UIView *C3;
     UIView *C4;
     UIView *C5;
     UIView *C6;
     UIView *C7;
     UIView *C8;
    
     UIView *D1;
     UIView *D2;
     UIView *D3;
     UIView *D4;
     UIView *D5;
     UIView *D6;
     UIView *D7;
     UIView *D8;
    
     UIView *E1;
     UIView *E2;
     UIView *E3;
     UIView *E4;
     UIView *E5;
     UIView *E6;
     UIView *E7;
     UIView *E8;
    
     UIView *F1;
     UIView *F2;
     UIView *F3;
     UIView *F4;
     UIView *F5;
     UIView *F6;
     UIView *F7;
     UIView *F8;
    
     UIView *G1;
     UIView *G2;
     UIView *G3;
     UIView *G4;
     UIView *G5;
     UIView *G6;
     UIView *G7;
     UIView *G8;
    
     UIView *H1;
     UIView *H2;
     UIView *H3;
     UIView *H4;
     UIView *H5;
     UIView *H6;
     UIView *H7;
     UIView *H8;
    
    UIImageView *BPawn1;
    UIImageView *BPawn2;
    UIImageView *BPawn3;
    UIImageView *BPawn4;
    UIImageView *BPawn5;
    UIImageView *BPawn6;
    UIImageView *BPawn7;
    UIImageView *BPawn8;
    
    UIImageView *WPawn1;
    UIImageView *WPawn2;
    UIImageView *WPawn3;
    UIImageView *WPawn4;
    UIImageView *WPawn5;
    UIImageView *WPawn6;
    UIImageView *WPawn7;
    UIImageView *WPawn8;
    
    UIImageView *BCastle1;
    UIImageView *WCastle1;
    UIImageView *BCastle2;
    UIImageView *WCastle2;
    
    UIImageView *BHorse1;
    UIImageView *WHorse1;
    UIImageView *BHorse2;
    UIImageView *WHorse2;
    
    UIImageView *BBishop1;
    UIImageView *WBishop1;
    UIImageView *BBishop2;
    UIImageView *WBishop2;
    
    UIImageView *BKing;
    UIImageView *WKing;
    
    UIImageView *WQueen;
    UIImageView *BQueen;
    
}


@end

