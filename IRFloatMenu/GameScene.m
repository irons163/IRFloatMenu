//
//  GameScene.m
//  Try_Sprite_view
//
//  Created by irons on 2016/3/29.
//  Copyright (c) 2016年 irons. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene{
    float previousX;
    float previousY;
    NSMutableArray* circleArray;
    SKLabelNode *myLabel;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    circleArray = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    myLabel.text = @"";
    myLabel.fontSize = 25;
    myLabel.fontColor = [UIColor blueColor];
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self addChild:myLabel];
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    for(int i = 0; i < 10; i++){
        int randomRadius = arc4random_uniform(10)+30;
        SKShapeNode* circle = [SKShapeNode shapeNodeWithCircleOfRadius:randomRadius]; // Size of Circle
        circle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:randomRadius];
        circle.physicsBody.density =1;
        circle.physicsBody.dynamic = YES;;
        circle.physicsBody.linearDamping = 0.6f;
        circle.physicsBody.angularDamping = 0.6f;
        circle.position = CGPointMake(self.frame.size.width - randomRadius,
                                      i*30);
        circle.strokeColor = [SKColor blackColor];
        circle.glowWidth = 1.0;
        [self addChild:circle];
        [circleArray addObject:circle];
    }
}

-(void)moveWithVx:(float)vx withVy:(float)vy{
    float forceRate = 4.15f;
    CGVector force = CGVectorMake(vx*forceRate, vy*forceRate);
    for(SKShapeNode* circle in circleArray){
        [circle.physicsBody applyForce:force];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        previousX = location.x;
        previousY = location.y;
        
        for(SKShapeNode* circle in circleArray){
            CGRect boundingBox = CGPathGetBoundingBox(circle.path);
            CGFloat radius = boundingBox.size.width / 2.0;
            if(sqrtf(powf(circle.position.x - location.x, 2) + powf(circle.position.y - location.y, 2)) < radius){
                    myLabel.text = [NSString stringWithFormat:@"Radius=%f", radius];
                break;
            }
        }
        break;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        float dx = location.x - previousX;
        float dy = location.y - previousY;
        previousX = location.x;
        previousY = location.y;
        [self moveWithVx:dx withVy:dy];
        break;
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
