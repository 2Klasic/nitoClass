
#import <Foundation/Foundation.h>
#import "NSObject+Additions.h"
#import "NSString+Additions.h"
#import "NRFileManager.h"
#import "EXTScope.h"
#import "CocoaLumberjack.h"

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

typedef NS_ENUM(NSInteger, BSPackageFileType)
{
    
    BSPackageFileTypeFile,
    BSPackageFileTypeDirectory,
    BSPackageFileTypeBlock,
    BSPackageFileTypeCharacter,
    BSPackageFileTypeLink,
    BSPackageFileTypePipe,
    BSPackageFileTypeSocket,
    BSPackageFileTypeUnknown
    
};

typedef NS_ENUM(NSInteger, NCSystemVersionType) {
    
    NCSystemVersionTypeUnsupported,
    NCSystemVersionTypeHighSierra,
    NCSystemVersionTypeMojave,
    NCSystemVersionTypeCatalina
};
#import "HelperClass.h"
#define LOG_SELF        DDLogInfo(@"%@ %@", self, NSStringFromSelector(_cmd))
#define DLOG_SELF DLog(@"%@ %@", self, NSStringFromSelector(_cmd))
//#define NLog(format, ...) NSLog(@"%@", [@"[nitoClassSetup] " stringByAppendingString:[NSString stringWithFormat:format, ## __VA_ARGS__]]);
#define NLog(format, ...) DDLogInfo(@"%@", [NSString stringWithFormat:format, ## __VA_ARGS__]);
#define DLog(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);
#define FM [NSFileManager defaultManager]
