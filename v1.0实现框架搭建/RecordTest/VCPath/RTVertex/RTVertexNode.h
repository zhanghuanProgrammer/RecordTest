//
//  RTVertexNode.h
//  CJOL
//
//  Created by mac on 2018/4/19.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTVertexNode : NSObject

@end

//边
@interface RTVertexArcNode : NSObject
{
    int adjvex;
    int weight;
    RTVertexArcNode *nextarc;
}
@end

@interface RTVertexVNode : NSObject
{
    NSInteger data;
    RTVertexArcNode *firstarc;
}
@end

@interface RTVertexALGraph : NSObject
{
    RTVertexVNode *vertices;//数组
    int vexnum, arcnum;
}
@end



