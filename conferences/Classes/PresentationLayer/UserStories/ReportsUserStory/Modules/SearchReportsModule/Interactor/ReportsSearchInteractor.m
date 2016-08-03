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

#import "ReportsSearchInteractor.h"

#import "SpeakerService.h"
#import "LectureService.h"
#import "EventService.h"
#import "EventModelObject.h"
#import "LectureModelObject.h"
#import "SpeakerModelObject.h"
#import "EventPlainObject.h"
#import "SpeakerPlainObject.h"
#import "LecturePlainObject.h"
#import "EventTypeDeterminator.h"
#import "ROSPonsomizer.h"

@implementation ReportsSearchInteractor

#pragma mark - ReportListInteractorInput

- (NSArray *)obtainFoundObjectListWithSearchText:(NSString *)text {
    
    NSMutableArray *foundObjects = [NSMutableArray new];
    
    NSPredicate *predicate;

    NSString *selectorName = [EventModelObjectAttributes name];
    predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[c] %@",selectorName, text];
    
    id managedObjectEvents = [self.eventService obtainEventWithPredicate:predicate];
    NSArray *events = [self.ponsomizer convertObject:managedObjectEvents];
    [foundObjects addObjectsFromArray:events];
    
    id managedObjectSpeakers = [self.speakerService obtainSpeakerWithPredicate:predicate];
    NSArray *speakers = [self.ponsomizer convertObject:managedObjectSpeakers];
    [foundObjects addObjectsFromArray:speakers];
    
    id managedObjectLectures = [self.lectureService obtainLectureWithPredicate:predicate];
    NSArray *lectures = [self.ponsomizer convertObject:managedObjectLectures];
    [foundObjects addObjectsFromArray:lectures];
    
    return foundObjects;
}

@end