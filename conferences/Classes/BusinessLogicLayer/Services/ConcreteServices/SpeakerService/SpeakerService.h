// Copyright (c) 2015 RAMBLER&Co
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@class NSPredicate;
@class Speaker;

typedef void (^SpeakerCompletionBlock)(Speaker *speaker, NSError *error);

/**
 @author Artem Karpushin
 
 The service is designed to obtain / update Speaker objects
 */
@protocol SpeakerService <NSObject>

/**
 @author Artem Karpushin
 
 Method is used to obtain Speakers object from cache
 
 @param predicate NSPredicate for specifying the filtering parameters
 
 @return Speaker object
 */
- (id)obtainSpeakerWithPredicate:(NSPredicate *)predicate;

/**
 @author Artem Karpushin
 
 Method is used to update Speaker object by sending request to server
 
 @param predicate NSPredicate for specifying the filtering parameters
 @param completionBlock SpeakerCompletionBlock called upon completion the method, and returns Speaker object and NSError object if there is any
 */
- (void)updateSpeakerWithPredicate:(NSPredicate *)predicate completionBlock:(SpeakerCompletionBlock)completionBlock;

@end
