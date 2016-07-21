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

#import "EventInteractor.h"
#import "EventInteractorOutput.h"
#import "EventService.h"
#import "EventPlainObject.h"
#import "PrototypeMapper.h"
#import "EventTypeDeterminator.h"
#import "EventStoreServiceProtocol.h"
#import "ErrorConstants.h"
#import "EXTScope.h"

static NSString *const kEventByObjectIdPredicateFormat = @"eventId = %@";

@implementation EventInteractor

#pragma mark - EventListInteractorInput

- (EventPlainObject *)obtainEventWithObjectId:(NSString *)objectId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:kEventByObjectIdPredicateFormat, objectId];
    
    NSArray *events = [self.eventService obtainEventWithPredicate:predicate];
    id managedObjectEvent = [events firstObject];
    
    EventPlainObject *eventPlainObject = [self mapEvent:managedObjectEvent];
    
    return eventPlainObject;
}

- (void)saveEventToCalendar:(EventPlainObject *)event {
    @weakify(self);
    [self.eventStoreService saveEventToCaledar:event withCompletionBlock:^(NSArray *errors) {
        @strongify(self);
        if (errors.count > 0) {
            for (NSError *error in errors) {
                if (error.code == ErrorEventAlreadyStoredInCalendar) {
                    [self.output didSaveEventToCalendarWithError:error];
                }
            }
        }
        else {
            [self.output didSaveEventToCalendarWithError:nil];
        }
    }];
}

- (NSArray *)obtainActivityItemsForEvent:(EventPlainObject *)event {
    /**
     @author Artem Karpushin
     
     // TODO: fill the array
     */
    NSArray *activityItems = @[];
    return activityItems;
}

#pragma mark - Private methods

- (EventPlainObject *)mapEvent:(NSManagedObjectModel *)managedObjectEvent {
    EventPlainObject *eventPlainObject = [EventPlainObject new];
    [self.eventPrototypeMapper fillObject:eventPlainObject withObject:managedObjectEvent];
    
    EventType eventType = [self.eventTypeDeterminator determinateTypeForEvent:eventPlainObject];
    eventPlainObject.eventType = eventType;
    
    return eventPlainObject;
}

@end