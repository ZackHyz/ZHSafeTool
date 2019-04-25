# 不写一行代码，大幅降低崩溃率


# 背景：
我们在项目中，经常会遇到各种莫名其妙的崩溃，但是常见的就那么几种而且出现率非常高，如果我们每次出现了就去修复，那么以后同样的崩溃出现的时候，还是又得做一次修复，这样效率非常低下，现在我们可以基于Runtime来做统一的处理，只要遇到类似的崩溃情况都能hold住，大幅降低崩溃率，而且不入侵业务代码。自从用了这套解决方案之后，我们App的崩溃率从千分之五降到了万分之二。

# 接入方法

```
pod 'ZHSafeTool'
```

# 解决常见崩溃的代码段
1.数组溢出

```
@implementation NSMutableArray (Exception)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(replace_objectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(replace_insertObject:atIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(setObject:atIndexedSubscript:) swizzledSelector:@selector(replace_setObject:atIndexedSubscript:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(replaceObjectAtIndex:withObject:) swizzledSelector:@selector(replace_replaceObjectAtIndex:withObject:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectAtIndex:) swizzledSelector:@selector(replace_removeObjectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectsInRange:) swizzledSelector:@selector(replace_removeObjectsInRange:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObject:inRange:) swizzledSelector:@selector(replace_removeObject:inRange:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(replace_objectAtIndexedSubscript:)];
        }
    });
}

- (id)replace_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self replace_objectAtIndex:index];
}

- (void)replace_insertObject:(id)object atIndex:(NSInteger)index{
    if (index > self.count || index < 0) {
        return ;
    }
    if (!object) {
        return;
    }
    return [self replace_insertObject:object atIndex:index];
}

- (void)replace_setObject:(id)object atIndexedSubscript:(NSInteger)index{
    if (index > self.count || index < 0) {
        return ;
    }
    if (!object) {
        return;
    }
    return [self replace_setObject:object atIndexedSubscript:index];
}

- (void)replace_replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject{
    if (index >= self.count || index < 0) {
        return ;
    }
    if (!anObject) {
        return;
    }
    return [self replace_replaceObjectAtIndex:index withObject:anObject];
}


- (void)replace_removeObjectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return ;
    }
    return [self replace_removeObjectAtIndex:index];
}

- (void)replace_removeObjectsInRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }
    if (range.length > self.count) {
        return;
    }
    if ((range.location + range.length) > self.count) {
        return;
    }
    return [self replace_removeObjectsInRange:range];
}

- (void)replace_removeObject:(id)anObject inRange:(NSRange)range{
    if (range.location > self.count) {
        return;
    }
    if (range.length > self.count) {
        return;
    }
    if ((range.location + range.length) > self.count) {
        return;
    }
    if (!anObject){
        return;
    }
    return [self replace_removeObject:anObject inRange:range];
}

- (id)replace_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {    
        return nil;
    }
    return [self replace_objectAtIndexedSubscript:index];
}

```

2.set nil object
```
@implementation NSDictionary (Exception)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSPlaceholderDictionary") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(replace_initWithObjects:forKeys:count:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(replace_setObject:forKey:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(removeObjectForKey:) swizzledSelector:@selector(replace_removeObjectForKey:)];
        }
    });
}

- (instancetype)replace_initWithObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count{
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }else{
            rightCount++;
        }
    }
    return [self replace_initWithObjects:objects forKeys:keys count:rightCount];
}

- (void)replace_setObject:(id)object forKey:(id<NSCopying>)key{
    if ((!object) || (!key)) {
      return;
    }
    return [self replace_setObject:object forKey:key];
}

- (void)replace_removeObjectForKey:(id)key{
    if (!key) {
        return;
    }
    return [self replace_removeObjectForKey:key];
}
```

3.no selector


```
@interface FakeForwardTargetObject : NSObject

- (instancetype)initWithSelector:(SEL)aSelector;

@end

id fakeIMP(id sender,SEL sel,...){
    return nil;
}

@implementation FakeForwardTargetObject

- (instancetype)initWithSelector:(SEL)aSelector
{
    if (self = [super init]) {
        if(class_addMethod([self class], aSelector, (IMP)fakeIMP, NULL)) {
            NSLog(@"add Fake Selector:[instance %@]", NSStringFromSelector(aSelector));
        }
    }
    return self;
}

@end




@implementation NSObject (Exception)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
           [objc_getClass("NSObject") swizzleMethod:@selector(forwardingTargetForSelector:) swizzledSelector:@selector(replace_forwardingTargetForSelector:)];
            
        }
    });
}

- (id)replace_forwardingTargetForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if ([self respondsToSelector:aSelector] || signature) {
        return [self replace_forwardingTargetForSelector:aSelector];
    }
    
    return [NSObject createFakeForwardTargetObject:self selector:aSelector];

}

+ (id)createFakeForwardTargetObject:(id)aTarget selector:(SEL)aSelector
{
    if ([[NSString string] respondsToSelector:aSelector]) {
        NSString *szTarget = nil;
        if ([aTarget isKindOfClass:[NSNumber class]]) {
            szTarget = [NSString stringWithFormat:@"%@", aTarget];
        }
        
        if (szTarget) {
            return szTarget;
        }
    }
    
    FakeForwardTargetObject *fakeTaget = [[FakeForwardTargetObject alloc] initWithSelector:aSelector];
    return fakeTaget;
}
```
4.webView的webGL随机崩溃（在后台的时候关闭这个webGL可以非常有效的降低崩溃率，这个需要在业务代码里面加一点点代码，详情可以看下面说的Demo）

```
@implementation UIWebView (Exception)

typedef void (*CallFuc)(id, SEL, BOOL);
typedef BOOL (*GetFuc)(id, SEL);

//打开/关闭 webview 的GL 
-(BOOL)enableGL:(BOOL)bEnable
{
    UIWebView *view = self;
    BOOL bRet = NO;
    do
    {
        Ivar internalVar = class_getInstanceVariable([view class], "_internal");
        if (!internalVar)
        {
            NSLog(@"enable GL _internal invalid!");
            break;
        }
        
        UIWebViewInternal* internalObj = object_getIvar(view, internalVar);
        Ivar browserVar = class_getInstanceVariable(object_getClass(internalObj), "browserView");
        if (!browserVar)
        {
            NSLog(@"enable GL browserView invalid!");
            break;
        }
        
        id webbrowser = object_getIvar(internalObj, browserVar);
        Ivar webViewVar = class_getInstanceVariable(object_getClass(webbrowser), "_webView");
        if (!webViewVar)
        {
            NSLog(@"enable GL _webView invalid!");
            break;
        }
        
        id webView = object_getIvar(webbrowser, webViewVar);
        if (!webView)
        {
            NSLog(@"enable GL webView obj nil!");
        }
        
        if(object_getClass(webView) != NSClassFromString(@"WebView"))
        {
            NSLog(@"enable GL webView not WebView!");
            break;
        }
        
        SEL selector = NSSelectorFromString(@"_setWebGLEnabled:");
        IMP impSet = [webView methodForSelector:selector];
        CallFuc func = (CallFuc)impSet;
        func(webView, selector, bEnable);
        
        SEL selectorGet = NSSelectorFromString(@"_webGLEnabled");
        IMP impGet = [webView methodForSelector:selectorGet];
        GetFuc funcGet = (GetFuc)impGet;
        BOOL val = funcGet(webView, selector);
        
        bRet = (val == bEnable);
        
    }while(NO);
    
    return bRet;
}
```

# Demo

https://github.com/ZackHyz/ZHSafeTool



-------------------------------------------------------
# 8月29日更新1.1.0

1.增加异常frame设置时候的防崩溃。

2.对UITableView reloadSections 和 reloadRowsAtIndexPaths做输入参数校验。
  对UICollectionView reloadSections 和 reloadItemsAtIndexPaths做输入参数校验。

-------------------------------------------------------
# 10月10日 
10月的崩溃率重新稳定到了万分之二，因为中途加入新人挖了不少坑， 从1月开始崩溃率从千分之五的峰值降到了万分之二。

-------------------------------------------------------
# 2019年4月25日 
解决iOS 8&9弹出键盘按Home键崩溃的问题。


![](https://user-gold-cdn.xitu.io/2018/10/10/1665c85387ebee1e?w=2254&h=818&f=png&s=219149)

# 掘金原文

https://juejin.im/post/5b5e82ade51d4513ee6ded6b


