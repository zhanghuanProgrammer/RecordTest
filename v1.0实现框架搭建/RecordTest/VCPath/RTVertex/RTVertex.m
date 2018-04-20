
#import "RTVertex.h"
#import "RecordTestHeader.h"
#import "NSDictionary+ZH.h"

#define N 1000 //图的顶点最多数
const int INF=100000;
int p[N][N],d[N],path[N];       //path数组用于记录路径

void dijkstra(int sec,int n)    //sec为出发节点，n表示图中节点总数
{
    int i,j,min,min_num=0;
    int vis[N]={0,};
    for(i=0;i<n;i++)
    {
        d[i]=p[sec][i];
    }
    vis[sec]=1;d[sec]=0;
    for(i=1;i<n;i++)
    {
        min=INF;
        for(j=0;j<n;j++)
        {
            if(!vis[j]&&d[j]<min)
            {
                min=d[j];
                min_num=j;
            }
        }
        vis[min_num]=1;
        for(j=0;j<n;j++)
        {
            if(d[j]>min+p[min_num][j])
            {
                path[j]=min_num;//path[j]记录d[j]暂时最短路径的最后一个中途节点min_num，表明d[j]最后一段从节点min_num到节点j
                d[j]=min+p[min_num][j];
            }
        }
    }
}

void print(int sec,int n)       //sec为出发节点，n表示图中节点总数
{
    int i,j;
    NSMutableArray * q = [NSMutableArray array]; //由于记录的中途节点是倒序的，所以使用栈（先进后出），获得正序
    for(i=0;i<n;i++)            //打印从出发节点到各节点的最短距离和经过的路径
    {
        j=i;
        while(path[j]!=-1)      //如果j有中途节点
        {
            [q addObject:@(j)]; //将j压入堆
            j=path[j];          //将j的前个中途节点赋给j
        }
        [q addObject:@(j)];
        printf("%d=>%d, length:%d, path: %d ",sec,i,d[i],sec);
        while(q.count>0)       //先进后出,获得正序
        {
            printf("%d ",[[q lastObject] intValue]);//打印堆的头节点
            [q removeLastObject];            //将堆的头节点弹出
        }
        printf("\n");
    }
}

NSArray * shortestPath(int sec,int n)       //sec为出发节点，n表示目标节点
{
    int i=n,j;
    NSMutableArray * q = [NSMutableArray array];
    j=i;
    while(path[j]!=-1)      //如果j有中途节点
    {
        [q addObject:@(j)]; //将j压入堆
        j=path[j];          //将j的前个中途节点赋给j
    }
    [q addObject:@(j)];
    [q addObject:@(sec)];
    if (d[i]==0 || d[i]==INF) {
        return nil;
    }
    printf("%d=>%d, length:%d, path: %d ",sec,i,d[i],sec);
    return q;
}

void initData(){
    memset(path,-1,sizeof(path));//将path数组初始化为-1
    int i,j,n=N;
    for(i=0;i<n;i++){
        for(j=0;j<n;j++){
            p[i][j]=(i==j?0:INF);
        }
    }
}

@implementation RTVertex

+ (RTVertex*)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static RTVertex* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[RTVertex alloc] init];
        _sharedObject.repearDictionary = [ZHRepearDictionary new];
    });
    return _sharedObject;
}

+ (NSArray *)shortestPath:(NSArray *)paths from:(NSString *)from to:(NSString *)to{
    [[RTVertex shareInstance].repearDictionary clear];
    initData();
    int max = -1;
    for (NSInteger i=0 , count = paths.count; i<count-1; i++) {
        RTOperationQueueModel *model = paths[i];
        RTOperationQueueModel *modelNext = paths[i+1];
        if (model.runResult != modelNext.runResult) {
            continue;
        }
        int vcFrom = [[[RTVCLearn shareInstance] getVcIdentity:model.vc] intValue];
        int vcTo = [[[RTVCLearn shareInstance] getVcIdentity:modelNext.vc] intValue];
        if(vcFrom>max)max=vcFrom;
        if(vcTo>max)max=vcTo;
        if (vcFrom!=vcTo) {
            [[RTVertex shareInstance].repearDictionary setValue:@(i) forKey:[NSString stringWithFormat:@"%d->%d",vcFrom,vcTo]];
            if (p[vcTo][vcFrom]!=1&&p[vcFrom][vcTo]!=1) {
                p[vcFrom][vcTo]=1;
//                printf("p[%d][%d]= %d;\n",vcFrom,vcTo,p[vcFrom][vcTo]);
            }
        }
    }
    NSLog(@"%@",[[RTVertex shareInstance].repearDictionary.dicM jsonPrettyStringEncoded]);
    int vcFrom = [[[RTVCLearn shareInstance] getVcIdentity:from] intValue];
    int vcTo = [[[RTVCLearn shareInstance] getVcIdentity:to] intValue];
    dijkstra(vcFrom,max+1);
//    print(vcFrom,max+1);
    NSLog(@"😄 i:%@-%@ j:%@-%@",from,@(vcFrom),to,@(vcTo));
    return shortestPath(vcFrom,vcTo).copy;
}

@end
