//
//  XcodeDownloads.m
//  nitoClassEnvironmentSetup
//
//  Created by Kevin Bradley on 3/28/20.
//  Copyright © 2020 nito. All rights reserved.
//

#import "XcodeDownloads.h"
#import "HelperClass.h"

@implementation XcodeDownloads

- (instancetype)init {
    self = [super init];
    if (self){
        _sytemVersion = [HelperClass currentVersion];
        [self _populateInfo];
        _xcodeInstalled = [HelperClass xcodeInstalled];
        _cliInstalled = [HelperClass commandLineToolsInstalled];
    }
    return self;
}

- (void)_populateInfo {
    
    switch (_sytemVersion) {
        case NCSystemVersionTypeCatalina:
            _systemVersionCodename = @"Catalina or Later";
            _xcodeDownloadURL = @"https://download.developer.apple.com/Developer_Tools/Xcode_11.4/Xcode_11.4.xip";
            _commandLineURL = @"https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_for_Xcode_11.4/Command_Line_Tools_for_Xcode_11.4.dmg";
            break;
            
        case NCSystemVersionTypeMojave:
            _systemVersionCodename = @"Mojave";
            _xcodeDownloadURL = @"https://download.developer.apple.com/Developer_Tools/Xcode_11.3.1/Xcode_11.3.1.xip";
            _commandLineURL = @"https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_for_Xcode_11.3.1/Command_Line_Tools_for_Xcode_11.3.1.dmg";
            break;
            
        case NCSystemVersionTypeHighSierra:
            _systemVersionCodename = @"High Sierra";
            _xcodeDownloadURL  = @"https://download.developer.apple.com/Developer_Tools/Xcode_10.1/Xcode_10.1.xip";
            _commandLineURL = @"https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_macOS_10.13_for_Xcode_10/Command_Line_Tools_macOS_10.13_for_Xcode_10.dmg";
        default:
            break;
    }
    
}


@end
