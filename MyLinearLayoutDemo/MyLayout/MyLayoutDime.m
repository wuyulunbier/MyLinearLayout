//
//  MyLayoutDime.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/6/14.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "MyLayoutDime.h"
#import "MyLayoutDimeInner.h"
#import "MyLayoutBase.h"

@implementation MyLayoutDime
{
    CGFloat _addVal;
    CGFloat _minVal;
    CGFloat _maxVal;
    CGFloat _mutilVal;
    id _dimeVal;
}

-(id)init
{
    self= [super init];
    if (self !=nil)
    {
        _view = nil;
        _dime = MGRAVITY_NONE;
        _addVal = 0;
        _mutilVal = 1;
        _minVal = -CGFLOAT_MAX;
        _maxVal = CGFLOAT_MAX;
        _dimeVal = nil;
        _dimeValType = MyLayoutValueType_NULL;
    }
    
    return self;
}

-(void)setNeedLayout
{
    if (_view.superview != nil && [_view.superview isKindOfClass:[MyLayoutBase class]])
    {
        MyLayoutBase* lb = (MyLayoutBase*)_view.superview;
        if (!lb.isLayouting)
            [_view.superview setNeedsLayout];
    }
    
}

//乘
-(MyLayoutDime* (^)(CGFloat val))multiply
{
    return ^id(CGFloat val){
        
        _mutilVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
    
}

//加
-(MyLayoutDime* (^)(CGFloat val))add
{
    return ^id(CGFloat val){
        
        _addVal = val;
        
        [self setNeedLayout];
        
        return self;
        
    };
    
}

-(MyLayoutDime* (^)(CGFloat val))min
{
    return ^id(CGFloat val){
        
        _minVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}

-(MyLayoutDime* (^)(CGFloat val))max
{
    return ^id(CGFloat val){
        
        _maxVal = val;
        
        [self setNeedLayout];
        
        return self;
    };
}


-(MyLayoutDime* (^)(id val))equalTo
{
    return ^id(id val){
        
        _dimeVal = val;
        
        if ([val isKindOfClass:[NSNumber class]])
            _dimeValType = MyLayoutValueType_NSNumber;
        else if ([val isKindOfClass:[MyLayoutDime class]])
            _dimeValType = MyLayoutValueType_Layout;
        else if ([val isKindOfClass:[NSArray class]])
            _dimeValType = MyLayoutValueType_Array;
        else
            _dimeValType = MyLayoutValueType_NULL;
        
        [self setNeedLayout];
        
        return self;
    };
    
}

-(NSNumber*)dimeNumVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_NSNumber)
        return _dimeVal;
    return nil;
}

-(void)setDimeNumVal:(NSNumber *)dimeNumVal
{
    NSAssert(0, @"oops");
}


-(NSArray*)dimeArrVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_Array)
        return _dimeVal;
    return nil;
    
}

-(void)setDimeArrVal:(NSArray *)dimeArrVal
{
    NSAssert(0, @"oops");
    
}

-(MyLayoutDime*)dimeRelaVal
{
    if (_dimeVal == nil)
        return nil;
    if (_dimeValType == MyLayoutValueType_Layout)
        return _dimeVal;
    return nil;
    
}

-(void)setDimeRelaVal:(MyLayoutDime *)dimeRelaVal
{
    NSAssert(0, @"oops");
    
}

-(BOOL)isMatchParent
{
    return self.dimeRelaVal != nil && self.dimeRelaVal.view == _view.superview;
}

-(void)setIsMatchParent:(BOOL)isMatchParent
{
    NSAssert(0, @"oops");
}


-(BOOL)isMatchView:(UIView*)v
{
    return self.dimeRelaVal != nil && self.dimeRelaVal.view == v;
}


-(CGFloat) measure
{
    CGFloat retVal = self.dimeNumVal.doubleValue * _mutilVal + _addVal;
    return [self validMeasure:retVal];
}

-(CGFloat)validMeasure:(CGFloat)measure
{
    measure = MAX(_minVal, measure);
    return MIN(_maxVal, measure);
}



-(void)setMeasure:(CGFloat)measure
{
    NSAssert(0, @"oops");
}


+(NSString*)dimestrFromDime:(MyLayoutDime*)dimeobj showView:(BOOL)showView
{
    
    NSString *viewstr = @"";
    if (showView)
    {
        viewstr = [NSString stringWithFormat:@"View:%p.", dimeobj.view];
    }
    
    NSString *dimeStr = @"";
    
    switch (dimeobj.dime) {
        case MGRAVITY_HORZ_FILL:
            dimeStr = @"WidthDime";
            break;
        case MGRAVITY_VERT_FILL:
            dimeStr = @"HeightDime";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@%@",viewstr,dimeStr];
    
}

-(NSString*)description
{
    NSString *dimeValStr = @"";
    switch (_dimeValType) {
        case MyLayoutValueType_NULL:
            dimeValStr = @"nil";
            break;
        case MyLayoutValueType_NSNumber:
            dimeValStr = [_dimeVal description];
            break;
        case MyLayoutValueType_Layout:
            dimeValStr = [MyLayoutDime dimestrFromDime:_dimeVal showView:YES];
            break;
        case MyLayoutValueType_Array:
        {
            dimeValStr = @"[";
            for (NSObject *obj in _dimeVal)
            {
                if ([obj isKindOfClass:[MyLayoutDime class]])
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[MyLayoutDime dimestrFromDime:(MyLayoutDime*)obj showView:YES]];
                }
                else
                {
                    dimeValStr = [dimeValStr stringByAppendingString:[obj description]];
                    
                }
                
                if (obj != [_dimeVal lastObject])
                    dimeValStr = [dimeValStr stringByAppendingString:@", "];
                
            }
            
            dimeValStr = [dimeValStr stringByAppendingString:@"]"];
            
        }
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@=%@, Multiply=%g, Add=%g, Max=%g, Min=%g",[MyLayoutDime dimestrFromDime:self showView:NO], dimeValStr, _mutilVal, _addVal, _maxVal == CGFLOAT_MAX ? NAN : _maxVal , _minVal == -CGFLOAT_MAX ? NAN : _minVal];
    
}


@end

