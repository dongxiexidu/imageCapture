

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (nonatomic,weak) UIView *coverView;
@property (nonatomic,assign) CGPoint startPoint;
@end

@implementation ViewController

// 遮盖的View
- (UIView *)coverView
{
    if (_coverView == nil) {
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = [UIColor grayColor];
        coverView.alpha = 0.5;
        [self.view addSubview:coverView];
        
        self.coverView = coverView;
    }
    return _coverView;
}


- (IBAction)pan:(UIPanGestureRecognizer *)pan {
    // 刚开始的点
    CGPoint curP = [pan locationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _startPoint = curP;
    }else if (pan.state == UIGestureRecognizerStateChanged){
    
        CGFloat offsetX = curP.x - self.startPoint.x;
        CGFloat offsetY = curP.y - self.startPoint.y;
        
        self.coverView.frame = CGRectMake(self.startPoint.x, _startPoint.y, offsetX, offsetY);
    }else if (pan.state == UIGestureRecognizerStateEnded){
        
        // 截屏
        
        // 开启一个跟图片一样大小的上下文
        UIGraphicsBeginImageContextWithOptions(self.imageV.frame.size, NO, 0);
        //UIGraphicsBeginImageContext(self.imageV.frame.size);
        
        // 描述路径
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.coverView.frame];
        
        // 根据路径截屏
        [path addClip];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        // 渲染图片到图形上下文
        [self.imageV.layer renderInContext:ctx];
        
        // 从图形上下文获取新的图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭图形上下文
        UIGraphicsEndImageContext();
        // 重新赋值
        self.imageV.image = newImage;
        [self.coverView removeFromSuperview];
    
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
