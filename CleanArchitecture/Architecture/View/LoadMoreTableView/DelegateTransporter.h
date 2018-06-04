#import <Foundation/Foundation.h>

@interface DelegateTransporter : NSObject
- (nonnull instancetype)initWithDelegates:(NSArray<id> * __nonnull)delegates NS_REFINED_FOR_SWIFT;
@end
