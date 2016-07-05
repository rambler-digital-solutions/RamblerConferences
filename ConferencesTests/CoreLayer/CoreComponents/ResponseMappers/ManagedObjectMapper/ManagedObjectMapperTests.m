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

#import <XCTest/XCTest.h>
#import <MagicalRecord/MagicalRecord.h>

#import "ManagedObjectMapper.h"
#import "ManagedObjectMappingProvider.h"
#import "ResultsResponseObjectFormatter.h"
#import "EntityNameFormatterImplementation.h"

#import "SocialNetworkAccountManagedObject.h"
#import "EventManagedObject.h"
#import "MetaEventManagedObject.h"
#import "TechManagedObject.h"
#import "LectureManagedObject.h"
#import "SpeakerManagedObject.h"
#import "TagManagedObject.h"
#import "LectureMaterialManagedObject.h"

#import "NetworkingConstantsHeader.h"

@interface ManagedObjectMapperTests : XCTestCase

@property (strong, nonatomic) ManagedObjectMapper *mapper;

@end

@implementation ManagedObjectMapperTests

- (void)setUp {
    [super setUp];
    
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    ManagedObjectMappingProvider *provider = [[ManagedObjectMappingProvider alloc] init];
    EntityNameFormatterImplementation *entityFormatter = [[EntityNameFormatterImplementation alloc] init];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
    provider.entityNameFormatter = entityFormatter;
    provider.dateFormatter = formatter;
    self.mapper = [[ManagedObjectMapper alloc] initWithMappingProvider:provider
                                                  responseObjectFormatter:nil
                                                   entityNameFormatter:entityFormatter];
}

- (void)tearDown {
    self.mapper = nil;
    
    [MagicalRecord cleanUp];
    
    [super tearDown];
}

- (void)testThatMapperMapsEvent {
    Class targetClass = [EventManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(eventId)),
                                NSStringFromSelector(@selector(name)),
                                NSStringFromSelector(@selector(startDate)),
                                NSStringFromSelector(@selector(endDate)),
                                NSStringFromSelector(@selector(metaEvent)),
                                NSStringFromSelector(@selector(tech))
                                ];
    NSArray *testArrays = @[
                            NSStringFromSelector(@selector(lectures))
                            ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties nonEmptyArrayProperties:testArrays];
}

- (void)testThatMapperMapsMetaEvent {
    Class targetClass = [MetaEventManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(metaEventId)),
                                NSStringFromSelector(@selector(metaEventDescription)),
                                NSStringFromSelector(@selector(name)),
                                NSStringFromSelector(@selector(websiteUrlPath)),
                                NSStringFromSelector(@selector(imageUrlPath))
                                ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties];
}

- (void)testThatMapperMapsTech {
    Class targetClass = [TechManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(techId)),
                                NSStringFromSelector(@selector(name)),
                                NSStringFromSelector(@selector(color))
                                ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties];
}

- (void)testThatMapperMapsLecture {
    Class targetClass = [LectureManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(lectureId)),
                                NSStringFromSelector(@selector(name)),
                                NSStringFromSelector(@selector(lectureDescription)),
                                NSStringFromSelector(@selector(speaker))
                                ];
    NSArray *testArrays = @[
                            NSStringFromSelector(@selector(tags)),
                            NSStringFromSelector(@selector(lectureMaterials))
                            ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties nonEmptyArrayProperties:testArrays];
}

- (void)testThatMapperMapsSpeaker {
    Class targetClass = [SpeakerManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(speakerId)),
                                NSStringFromSelector(@selector(name)),
                                NSStringFromSelector(@selector(biography)),
                                NSStringFromSelector(@selector(job)),
                                NSStringFromSelector(@selector(company)),
                                NSStringFromSelector(@selector(imageLink))
                                ];
    NSArray *testArrays = @[
                            NSStringFromSelector(@selector(socialNetworkAccounts))
                            ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties nonEmptyArrayProperties:testArrays];
}

- (void)testThatMapperMapsSocialNetworkAccount {
    Class targetClass = [SocialNetworkAccountManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(profileLink)),
                                NSStringFromSelector(@selector(type))
                                ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties];
}

- (void)testThatMapperMapsTag {
    Class targetClass = [TagManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(tagId)),
                                NSStringFromSelector(@selector(name)),
                                NSStringFromSelector(@selector(slug))
                                ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties];
}

- (void)testThatMapperMapsLectureMaterial {
    Class targetClass = [LectureMaterialManagedObject class];
    NSArray *testProperties = @[
                                NSStringFromSelector(@selector(lectureMaterialId)),
                                NSStringFromSelector(@selector(link)),
                                NSStringFromSelector(@selector(name))
                                ];
    [self verifyMappingOfClass:targetClass withNonNilChecksForProperties:testProperties];
}

#pragma mark - Helper Methods

- (void)verifyMappingOfClass:(Class)objectClass withNonNilChecksForProperties:(NSArray *)nonNilProperties {
    [self verifyMappingOfClass:objectClass withNonNilChecksForProperties:nonNilProperties nonEmptyArrayProperties:nil];
}

- (void)verifyMappingOfClass:(Class)objectClass withNonNilChecksForProperties:(NSArray *)nonNilProperties nonEmptyArrayProperties:(NSArray *)nonEmptyArrayProperties {
    // given
    NSDictionary *serverResponse = [self generateServerResponseForModelClass:objectClass];
    NSDictionary *mappingContext = [self generateMappingContextForModelClass:objectClass];
    
    // when
    NSArray *result = [self.mapper mapServerResponse:serverResponse
                                  withMappingContext:mappingContext
                                               error:nil];
    id firstObject = [result firstObject];
    
    // then
    XCTAssertEqual(result.count, 1);
    XCTAssertTrue([firstObject isKindOfClass:objectClass]);
    for (NSString *property in nonNilProperties) {
        SEL propertySelector = NSSelectorFromString(property);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        XCTAssertNotNil([firstObject performSelector:propertySelector]);
#pragma clang diagnostic pop
    }
    
    for (NSString *property in nonEmptyArrayProperties) {
        SEL propertySelector = NSSelectorFromString(property);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        XCTAssertGreaterThan([[firstObject performSelector:propertySelector] count], 0);
#pragma clang diagnostic pop
    }
}

- (NSDictionary *)generateMappingContextForModelClass:(Class)modelClass {
    NSString *className = NSStringFromClass(modelClass);
    return @{
             kMappingContextModelClassKey : className
             };
}

- (NSDictionary *)generateServerResponseForModelClass:(Class)modelClass {
    Class testCaseClass = [self class];
    
    NSString *bundleName = NSStringFromClass(testCaseClass);
    NSString *modelName = NSStringFromClass(modelClass);
    NSString *fileName = [NSString stringWithFormat:@"%@.json", modelName];
    
    NSBundle *resourceBundle = [NSBundle bundleForClass:testCaseClass];
    
    NSString *pathToTestBundle = [resourceBundle pathForResource:bundleName ofType:@"bundle"];
    NSBundle *testBundle = [NSBundle bundleWithPath:pathToTestBundle];
    
    NSString *pathToFile = [[testBundle resourcePath] stringByAppendingPathComponent:fileName];
    NSData *responseData = [NSData dataWithContentsOfFile:pathToFile
                                                  options:0
                                                    error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:nil];
    
    return json;
}

@end