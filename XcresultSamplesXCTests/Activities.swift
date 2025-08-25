import XCTest

final class Activities: XCTestCase {
    func testOnePassedActivity() throws {
        XCTContext.runActivity(named: "Step 1", block: { _ in })
    }
    
    func testOneActivityWithOneFailedAssertion() throws {
        XCTContext.runActivity(named: "Step 1") { _ in
            XCTAssertEqual("foo", "bar")
        }
    }
    
    func testOneActivityWithTwoFailedAssertions() throws {
        XCTContext.runActivity(named: "Step 1") { _ in
            XCTAssertEqual("foo", "bar")
            XCTAssertEqual("baz", "qux")
        }
    }
    
    func testOneActivityWithOneExpectedFailure() throws {
        XCTContext.runActivity(named: "Step 1") { _ in
            XCTExpectFailure("We expect a failure here")
            XCTAssertEqual("foo", "bar")
        }
    }
    
    func testOneActivityWithTwoExpectedFailures() throws {
        XCTContext.runActivity(named: "Step 1") { _ in
            XCTExpectFailure("We expect two failures here")
            XCTAssertEqual("foo", "bar")
            XCTAssertEqual("baz", "qux")
        }
    }
    
    func testThreeActivitiesWithExpectedAndUnexpectedFailures() throws {
        XCTContext.runActivity(named: "Step 1") { _ in
            XCTContext.runActivity(named: "Step 1.1") { _ in
                XCTExpectFailure("We expect a failure here")
                XCTAssertEqual("foo", "bar")
            }
            XCTContext.runActivity(named: "Step 1.2") { _ in
                XCTAssertEqual("baz", "qux")
            }
        }
    }
    
    func testFailureAggregation() throws {
        XCTAssertEqual("foo", "bar")
        XCTContext.runActivity(named: "Step 1") { _ in
            XCTAssertEqual("bar", "baz")
            XCTContext.runActivity(named: "Step 1.1") { _ in
                XCTAssertEqual("baz", "qux")
            }
        }
    }
    
    func testSixNestedSteps() throws {
        XCTContext.runActivity(named: "Step 1") { _ in
            XCTContext.runActivity(named: "Step 1.1") { _ in
                
            }
            XCTContext.runActivity(named: "Step 1.2") { _ in
                
            }
        }
        XCTContext.runActivity(named: "Step 2") { _ in
            XCTContext.runActivity(named: "Step 2.1") { _ in
                
            }
            XCTContext.runActivity(named: "Step 2.2") { _ in
                
            }
        }
    }
    
    func testTextAttachment() throws {
        XCTContext.runActivity(named: "Foo", block: { activity in
            let attachment = XCTAttachment(string: "Lorem Ipsum")
            attachment.name = "Bar"
            activity.add(attachment)
        })
    }
    
    func testStepAttachments() throws {
        XCTContext.runActivity(named: "Step 1") { activity in
            XCTContext.runActivity(named: "Step 1.1") { _ in
                
            }
            
            // Activity start/stop timestamps has resolution of 1 millisecond in xcresult
            // We use sleep calls, so the structure of steps in Allure Report matches the
            // chronology of activities/attachments in the source code.
            Thread.sleep(forTimeInterval: 0.01)
            
            let attachment = XCTAttachment(string: "Lorem Ipsum")
            activity.add(attachment)
            
            Thread.sleep(forTimeInterval: 0.01)
            
            XCTContext.runActivity(named: "Step 1.2") { _ in
                
            }
            
            Thread.sleep(forTimeInterval: 0.01)
            
            XCTContext.runActivity(named: "Step 1.3") { _ in
                
            }
        }
    }
}
