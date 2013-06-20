//
//  SampleCard.m
//  SampleBezier
//
//  Created by Gregory on 5/14/13.
//  Copyright (c) 2013 Gregory. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) int shapeLengthX;
@property (nonatomic) int shapeLengthY;
@property (nonatomic) int startPointX;


@end

@implementation SetCardView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define MAXIMUM_NUMBER_OF_SHAPES 3
#define LINE_WIDTH_TO_SHAPE_LENGTH 10

#define SHAPES_INDENT_SIZE 0.5 //half shape in between

#define SHAPE_LENGTH_TO_MAX_LENGTH_RATIO 0.8

#define SQUIGLLE_LENGTH_TO_HIGHT_RATIO 3
#define SQUIGLLE_X_EXTENSION_TO_Y_RATIO 0.667

-(void)setShape:(NSString*)shape{
    _shape = shape;
    
    int shapeLengthToHighRatio  = 3;
    int shapeLengthToHighRatioForMax = 3;
    
    if([@"squiggle" isEqualToString:_shape]){
        shapeLengthToHighRatioForMax = SQUIGLLE_LENGTH_TO_HIGHT_RATIO+SQUIGLLE_X_EXTENSION_TO_Y_RATIO;
        shapeLengthToHighRatio = SQUIGLLE_LENGTH_TO_HIGHT_RATIO;
    }
    else if([@"oval" isEqualToString:_shape]){
        shapeLengthToHighRatio = 3;
        shapeLengthToHighRatioForMax = shapeLengthToHighRatio;
    }
    else if([@"diamond" isEqualToString:_shape]){
        shapeLengthToHighRatio = 3;
        shapeLengthToHighRatioForMax = shapeLengthToHighRatio;
    }

    
    //identify max lenght of squiggle
    int maxShapeLengthXFromWidth = self.bounds.size.width;
    int maxNoShapesToFitInY = MAXIMUM_NUMBER_OF_SHAPES+(MAXIMUM_NUMBER_OF_SHAPES+1)*SHAPES_INDENT_SIZE;
    int maxShapeLengthXFromHight = (self.bounds.size.height/maxNoShapesToFitInY)*shapeLengthToHighRatioForMax;
    int maxShapeLengthX = maxShapeLengthXFromWidth<maxShapeLengthXFromHight?maxShapeLengthXFromWidth:maxShapeLengthXFromHight;
    
    
    _shapeLengthX = SHAPE_LENGTH_TO_MAX_LENGTH_RATIO*maxShapeLengthX;
    _shapeLengthY = _shapeLengthX/shapeLengthToHighRatio;
    _startPointX = self.bounds.size.width/2 - (_shapeLengthX/2);

}


- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    

    
    [self.color setStroke];
    
    for(int i= 0;i<self.numberOfShapes;i++){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        UIBezierPath* shape = [self drawShape:i];
        [shape setLineWidth: self.shapeLengthX/LINE_WIDTH_TO_SHAPE_LENGTH];
        [self setShadingForShape:shape];
        [shape stroke];
        
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
    
}

-(void)setShadingForShape:(UIBezierPath *)shape{
    // solid open /stripe
    if([@"solid" isEqualToString:self.shading]){
        [self.color setFill];
        [shape fill];
    }
    else if([@"open" isEqualToString:self.shading]){
        //leave as is
    }
    else if([@"stripe" isEqualToString:self.shading]){
        [shape addClip];
        [self applyStripesToShape:shape];
    }

}

-(UIBezierPath *)drawShape:(int)shapeNumber{
    if([@"squiggle" isEqualToString:self.shape]){
        return [self drawSquiggle:shapeNumber];
    }
    else if([@"oval" isEqualToString:self.shape]){
        return [self drawOval:shapeNumber];
    }
    else if([@"diamond" isEqualToString:self.shape]){
        return [self drawDiamond:shapeNumber];
    }
    return NULL;
}


-(int) calculateCurrentYForShape:(int) shapeNumber{
    int centerY = self.bounds.size.height/2;
    int numberOfIndents = _numberOfShapes -1;
    int startPointY = centerY - (_numberOfShapes*_shapeLengthY+numberOfIndents*_shapeLengthY*SHAPES_INDENT_SIZE)/2;
    int startPointYIncrement = _shapeLengthY+_shapeLengthY*SHAPES_INDENT_SIZE;
    return startPointY+startPointYIncrement*shapeNumber;

}

-(UIBezierPath *)drawSquiggle:(int)shapeNumber{
   

    
    int controlPointOffsetX = self.shapeLengthY*SQUIGLLE_X_EXTENSION_TO_Y_RATIO;
    int controlPointOffsetY = controlPointOffsetX;
    int currentStartY = [self calculateCurrentYForShape:shapeNumber];
    
    UIBezierPath *shape  = [UIBezierPath bezierPath];
    [shape moveToPoint:CGPointMake(self.startPointX, currentStartY)];
    [shape addCurveToPoint:CGPointMake(self.startPointX+self.shapeLengthX, currentStartY) controlPoint1:CGPointMake(self.startPointX+self.shapeLengthX/2, currentStartY-controlPointOffsetY) controlPoint2:CGPointMake(self.startPointX+self.shapeLengthX/2, currentStartY+controlPointOffsetY)];
    [shape addQuadCurveToPoint: CGPointMake(self.startPointX+self.shapeLengthX, currentStartY+self.shapeLengthY)controlPoint: CGPointMake(self.startPointX+self.shapeLengthX+controlPointOffsetX, currentStartY)];
    [shape addCurveToPoint:CGPointMake(self.startPointX, currentStartY+self.shapeLengthY) controlPoint1:CGPointMake(self.startPointX+self.shapeLengthX/2, currentStartY+self.shapeLengthY+controlPointOffsetY) controlPoint2:CGPointMake(self.startPointX+self.shapeLengthX/2, currentStartY+self.shapeLengthY-controlPointOffsetY)];
    [shape addQuadCurveToPoint: CGPointMake(self.startPointX, currentStartY)controlPoint: CGPointMake(self.startPointX-controlPointOffsetX, currentStartY+self.shapeLengthY)];
    [shape closePath];
    return shape;
}


-(UIBezierPath *)drawOval:(int)shapeNumber{
     int currentStartY = [self calculateCurrentYForShape:shapeNumber];
    UIBezierPath *shape  = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.startPointX, currentStartY, self.shapeLengthX, self.shapeLengthY)];
    return shape;

}

-(UIBezierPath *)drawDiamond:(int)shapeNumber{
    int currentStartY = [self calculateCurrentYForShape:shapeNumber];
    CGPoint point1 = CGPointMake(self.startPointX, currentStartY+self.shapeLengthY/2);
    CGPoint point2 = CGPointMake(self.startPointX+self.shapeLengthX/2, currentStartY);
    CGPoint point3 = CGPointMake(self.startPointX+self.shapeLengthX, currentStartY+self.shapeLengthY/2);
    CGPoint point4 = CGPointMake(self.startPointX+self.shapeLengthX/2, currentStartY+self.shapeLengthY);
    
    UIBezierPath *shape  = [UIBezierPath bezierPath];
    [shape moveToPoint:point1];
    [shape addLineToPoint:point2];
    [shape addLineToPoint:point3];
    [shape addLineToPoint:point4];
    [shape addLineToPoint:point1];
    [shape closePath];
    return shape;

}

#define STRIPE_TO_SIZE_RATIO 0.08
-(void) applyStripesToShape:(UIBezierPath*)shape{
    int stripeFrequency = (self.bounds.size.width>self.bounds.size.height?self.bounds.size.width:self.bounds.size.height)*STRIPE_TO_SIZE_RATIO;
    CGRect shapeSize = shape.bounds;
    
   
    int startLineX = shapeSize.origin.x;
    int startLineY = shapeSize.origin.y;
    int endLineX = startLineX;
    int endLineY = startLineY;
    while (startLineX<=shapeSize.origin.x+shapeSize.size.width||startLineY<=shapeSize.origin.y+shapeSize.size.height) {
        if(startLineX<=shapeSize.origin.x+shapeSize.size.width){
            startLineX+=stripeFrequency;
        } else {
          startLineY+=stripeFrequency;
        }
        
        if(endLineY<=shapeSize.origin.y+shapeSize.size.height){
            endLineY+=stripeFrequency;
        } else {
            endLineX+=stripeFrequency;
        }
        
          
        UIBezierPath *stripe  = [UIBezierPath bezierPath];
        [stripe moveToPoint: CGPointMake(startLineX, startLineY)];
        [stripe addLineToPoint:CGPointMake(endLineX, endLineY)];
        //[stripe setLineWidth:self.shapeLengthX/LINE_WIDTH_TO_SHAPE_LENGTH];
        [stripe stroke];
    }
    
}





@end
