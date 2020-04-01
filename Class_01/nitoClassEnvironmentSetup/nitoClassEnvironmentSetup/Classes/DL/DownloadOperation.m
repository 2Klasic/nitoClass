//
//  YTDownloadOperation.m
//  yourTubeiOS
//
//  Created by Kevin Bradley on 2/9/16.
//
//

#import "DownloadOperation.h"
#import "HelperClass.h"

@interface DownloadOperation ()

@property BOOL _ourExecuting;
@property BOOL _ourFinished;
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@end

//download operation class, handles file downloads.


@implementation DownloadOperation

@synthesize downloadLocation, CompletedBlock;

- (BOOL)isAsynchronous {
    return true;
}

- (BOOL)isExecuting {
    LOG_SELF;
    return __ourExecuting;
}

- (BOOL)isFinished {
    LOG_SELF;
    return __ourFinished;
}

- (id)initWithURL:(NSURL *)fileURL progresss:(DownloadProgressBlock)progressBlock completed:(DownloadCompletedBlock)completedBlock {
    self = [super init];
    if (self) {
        _downloadURL = fileURL;
        _FancyProgressBlock = progressBlock;
        CompletedBlock = completedBlock;
        downloadLocation = [[HelperClass tempFolder] stringByAppendingPathComponent:[fileURL lastPathComponent]];
        
    }
    return self;
}

- (void)cancel {
    [super cancel];
    [[self downloadTask] cancel];
    [self willChangeValueForKey:@"finished"];
    __ourFinished = true;
    [self didChangeValueForKey:@"finished"];
    [self willChangeValueForKey:@"executing"];
    __ourExecuting = false;
    [self didChangeValueForKey:@"executing"];
}

- (void)main {
    [self start];
    [self willChangeValueForKey:@"finished"];
    __ourFinished = false;
    [self didChangeValueForKey:@"finished"];
    [self willChangeValueForKey:@"executing"];
    __ourExecuting = true;
    [self didChangeValueForKey:@"executing"];


}

- (void)start {
    self.session = [self backgroundSessionWithId:self.downloadURL.absoluteString];
    
    if (self.downloadTask){
        return;
    }
    
    NSLog(@"starting task...");
    /*
     Create a new download task using the URL session. Tasks start in the “suspended” state; to start a task you need to explicitly call -resume on a task after creating it.
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:self.downloadURL];
    self.downloadTask = [self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    /*
     Report progress on the task.
     If you created more than one task, you might keep references to them and report on them individually.
     */
    
    if (downloadTask == self.downloadTask) {
        double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        //NSLog(@"DownloadTask: %@ progress: %lf", downloadTask, progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.FancyProgressBlock){
                self.FancyProgressBlock(progress, totalBytesWritten, totalBytesExpectedToWrite);
            }
        });
    }
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL {
    
    /*
     The download completed, you need to copy the file at targetPath before the end of this block.
     As an example, copy the file to the Documents directory of your app.
     */

    NSLog(@"downloaded file to url: %@", downloadURL);
    NSURL *destinationURL = [NSURL fileURLWithPath:[self downloadLocation]];
    NSError *errorCopy;
    
    // For the purposes of testing, remove any esisting file at the destination.
    [FM removeItemAtURL:destinationURL error:NULL];
    BOOL success = [FM copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];
    if (success){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Task: %@ completed successfully", downloadTask);
            if (self.CompletedBlock != nil)
            {
                self.CompletedBlock(self->downloadLocation);
            }
        });
    } else {
        /*
         In the general case, what you might do in the event of failure depends on the error and the specifics of your application.
         */
        NSLog(@"Error during the copy: %@", [errorCopy localizedDescription]);
    }
    [self willChangeValueForKey:@"executing"];
    __ourExecuting = false;
    [self didChangeValueForKey:@"executing"];
    [self willChangeValueForKey:@"finished"];
    __ourFinished = true;
    [self didChangeValueForKey:@"finished"];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
     /*
        NSLog(@"Task: %@ completed successfully", task);
        if (self.CompletedBlock != nil) {
            self.CompletedBlock(downloadLocation);
        }
      */
    } else {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
        if (self.CompletedBlock != nil) {
            self.CompletedBlock(downloadLocation);
        }
    }

    self.downloadTask = nil;
}

- (NSURLSession *)backgroundSessionWithId:(NSString *)sessionID {
    /*
     Using disptach_once here ensures that multiple background sessions with the same identifier are not created in this instance of the application. If you want to support multiple background sessions within a single process, you should create each session with its own identifier.
     */
    static NSURLSession *session = nil;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionID];
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    return session;
}

@end