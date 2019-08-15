//
//  main.m
//  unrecognizedSelector
//
//  Created by zmodo on 2019/8/15.
//  Copyright © 2019 zmodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGPerson.h"
#include <objc/message.h> // 看到这个斜杠我们就知道runtime不在runtime文件 在objc文件


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //        instrumentObjcMessageSends(YES);
        //        [LGPerson run];
        //        [LGStudent new];
        //        instrumentObjcMessageSends(NO);
        LGPerson* p =  [LGPerson new];
        //        [NSString performSelector:@selector(doingclassCrash)];
        [@"ddd" performSelector:@selector(doinginstanceCrash)];
        
        
        /**
         *
         */
        
        
    }
    return 0;
}
