//
//  ViewController.m
//  test
//
//  Created by chouheiwa on 2018/11/29.
//  Copyright © 2018 chouheiwa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@interface Cls : NSObject // 类对象的结构体指针地址为由低向高转化

@property(nonatomic,copy) NSString *test; // 指针首位 + 2

@property(nonatomic,copy) NSString *test1;// 指针首位 + 4

@end

@implementation Cls

- (void)speak {
    NSLog(@"test:%@",_test); //打印的是当前结构体的首位指针 + 2
    
    NSLog(@"test1:%@",_test1); // 打印的是当前结构体的首位指针 + 4
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //在64位测试机环境下 指针地址的间隔是  2
    //[super viewDidLoad] 会有一个 隐藏参数 self 被压入栈中，并且地址为由高地址向低地址分配
    // Do any additional setup after loading the view, typically from a nib.
    //
    NSString *str = @"111";// 在参数生成时，又会栈中又会压入新的地址，因此这时self 的地址 就是 str地址 + 2
    
    void *obj_tmp = &str + 2;// 测试对应信息是否正确(void *) 不会在当前栈创建新的指针地址
    
    NSLog(@"%@",(__bridge id)obj_tmp);// 打印对应参数

    id cls = [Cls class]; // cls 参数生成时，栈中又压入新的地址，这个地址指向 Cls 的类地址，因此，我们如果把这个地址中包含的值当成是一个标准的Object-c对象结构体地址来看的话，它已经符合Object-c对象结构体的定义了。接下来这个结构体里地址由低到高的指针位置会依次被当成这个类的成员变量地址，也就是说
    //test成员变量的位置会在&cls + 2 也就是str的位置
    //test1成员变量的位置会在&cls + 4 也就是最终会指向当前的viewController
    //如果此时我们有成员变量test2，因为在当前&cls + 6的位置没有对应的值，所以这个值相当于是一个野指针，自然也就会报错了

    void *obj = &cls;
    
    [(__bridge id)obj speak]; // 这个地址最终形成的对象符合Object-C msg_send 方法中的一切定义，因此调用不会报错与崩溃
}


@end
