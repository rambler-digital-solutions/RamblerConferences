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

#import "ReportListInteractor.h"
#import "ReportListInteractorOutput.h"

#import "EventService.h"
#import "EventManagedObject.h"
#import "EventPrototypeMapper.h"
#import "EventPlainObject.h"
#import "EventType.h"
#import "EventTypeDeterminator.h"

#import "EXTScope.h"

@implementation ReportListInteractor

#pragma mark - ReportListInteractorInput

- (void)updateEventList {
    @weakify(self)
    [self.eventService updateEventWithPredicate:nil completionBlock:^(id data, NSError *error) {
        @strongify(self);
        NSArray *events  = [self getPlainEventsFromManagedObjects:data];
        
        [self.output didUpdateEventList:events];
    }];
}

- (NSArray *)obtainEventList {
    id managedObjectEvents = [self.eventService obtainEventWithPredicate:nil];
    
    NSArray *events = [self getPlainEventsFromManagedObjects:managedObjectEvents];
    
    return events;
}

- (NSArray *)obtainEventListWithPredicate:(NSPredicate *)predicate {
    id managedObjectEvents = [self.eventService obtainEventWithPredicate:predicate];
    NSArray *events = [self getPlainEventsFromManagedObjects:managedObjectEvents];
    
    return events;
}

#pragma mark - Private methods

- (NSArray *)getPlainEventsFromManagedObjects:(NSArray *)managedObjectEvents {
    NSMutableArray *eventPlainObjects = [NSMutableArray array];
    for (EventManagedObject *managedObjectEvent in managedObjectEvents) {
        EventPlainObject *eventPlainObject = [EventPlainObject new];
        
        [self.eventPrototypeMapper fillObject:eventPlainObject withObject:managedObjectEvent];
        
        [eventPlainObjects addObject:eventPlainObject];
    }
    return [self obtainPastEvents:eventPlainObjects];
}

- (NSArray *)obtainPastEvents:(NSArray *)events {
    NSMutableArray *pastEvents = [NSMutableArray array];
    
    for (EventPlainObject *event in events) {
        EventType eventType = [self.eventTypeDeterminator determinateTypeForEvent:event];
        
        if (eventType == PastEvent) {
            [pastEvents addObject:event];
        }
    }
    
    return [self sortEventsByDate:pastEvents];
}

- (NSArray *)sortEventsByDate:(NSMutableArray *)events {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(startDate)) ascending:NO];
    events = [[events sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    
    return events;
}

@end