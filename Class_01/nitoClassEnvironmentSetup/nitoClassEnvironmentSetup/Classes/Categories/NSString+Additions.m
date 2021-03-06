

#import "NSString+Additions.h"
#import "NSData+Flip.h"
#import "NSData+CommonCrypto.h"

@implementation NSNumber (NumberFormatting)

-(NSString*) suffixNumber {
    
    long long num = [self longLongValue];
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    num = llabs(num);
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10l(num) / 3.f); //log10l(1000));
    NSArray* units = @[@"MB",@"GB",@"TB",@"PB",@"EB",@"YB"];
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

@end

@implementation NSString (Additions)

- (BOOL)validateFileSHA:(NSString *)sha {
    if ([FM fileExistsAtPath:self]){
        NSData *data = [NSData dataWithContentsOfFile:self];
        NSString *ourSHA = [[data SHA1Hash] stringFromHexData];
        return [ourSHA isEqualToString:sha];
    }
    return FALSE;
}

- (NSString *)TIMEFormat {
    
    NSInteger secondsLeft = [self integerValue];
    NSInteger _hours = (NSInteger)secondsLeft / 3600;
    NSInteger _minutes = (NSInteger)secondsLeft / 60 % 60;
    NSInteger _seconds = (NSInteger)secondsLeft % 60;
    return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)_hours, (long)_minutes, (long)_seconds];
}

-(NSString*) suffixNumber {
    
    long long num = [self longLongValue];
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    num = llabs(num);
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10l(num) / 3.f); //log10l(1000));
    NSArray* units = @[@"MB",@"GB",@"TB",@"PB",@"EB",@"YB"];
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}


- (NSString *)nextVersionNumber {
    
    NSArray *comp = [self componentsSeparatedByString:@"-"];
    if (comp.count > 1){
        
        NSString *first = comp[0];
        NSInteger bumpVersion = [[comp lastObject] integerValue]+1;
        
        return [NSString stringWithFormat:@"%@-%lu", first, bumpVersion];
        
    } else {
        return nil;
    }
    return nil;
}

- (void)writeToFileWithoutAttributes:(NSString *)theFile {
    
    if ([FM fileExistsAtPath:theFile]){
        
        DLog(@"overwriting file: %@", theFile);
    }
    FILE *fd = fopen([theFile UTF8String], "w+");
    const char *text = self.UTF8String;
    fwrite(text, strlen(text) + 1, 1, fd);
    fclose(fd);
    
}

- (NSString *)plistSafeString
{
    NSUInteger startingLocation = [self rangeOfString:@"<?xml"].location;
    
    //find NSRange of the end of the plist (there is "junk" cert data after our plist info as well
    NSRange endingRange = [self rangeOfString:@"</plist>"];
    
    //adjust the location of endingRange to include </plist> into our newly trimmed string.
    NSUInteger endingLocation = endingRange.location + endingRange.length;
    
    //offset the ending location to trim out the "garbage" before <?xml
    NSUInteger endingLocationAdjusted = endingLocation - startingLocation;
    
    //create the final range of the string data from <?xml to </plist>
    
    NSRange plistRange = NSMakeRange(startingLocation, endingLocationAdjusted);
    
    //actually create our string!
    return [self substringWithRange:plistRange];
}



- (id)dictionaryRepresentation {
    NSString *error = nil;
    NSPropertyListFormat format;
    NSData *theData = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    id theDict = [NSPropertyListSerialization propertyListFromData:theData
                                                  mutabilityOption:NSPropertyListImmutable
                                                            format:&format
                                                  errorDescription:&error];
    return theDict;
}

@end
