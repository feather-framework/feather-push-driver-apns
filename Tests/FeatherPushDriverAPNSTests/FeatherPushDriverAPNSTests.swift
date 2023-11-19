//
//  FeatherPushDriverAPNSTests.swift
//  FeatherPushDriverAPNSTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import NIO
import Logging
import Foundation
import XCTest
import FeatherService
import FeatherPush
import FeatherPushDriverAPNS
import XCTFeatherPush
import APNS

final class FeatherPushDriverAPNSTests: XCTestCase {

    var privateKey: String {
        ProcessInfo.processInfo.environment["APNS_PRIVATE_KEY"]!
    }
    
    var keyId: String {
        ProcessInfo.processInfo.environment["APNS_KEY_ID"]!
    }
    
    var teamId: String {
        ProcessInfo.processInfo.environment["APNS_TEAM_ID"]!
    }
    
    var env: String {
        ProcessInfo.processInfo.environment["APNS_ENV"] ?? "sandbox"
    }
    
    var token: String {
        ProcessInfo.processInfo.environment["APNS_TOKEN"]!
    }

    func testAPNSDriverUsingTestSuite() async throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        do {
            let registry = ServiceRegistry()
            try await registry.add(
                .apnsPush(
                    configuration: .init(
                        authenticationMethod: .jwt(
                            privateKey: .loadFrom(string: privateKey), // try .init(pemRepresentation: privateP8Key)
                            keyIdentifier: keyId,
                            teamIdentifier: teamId),
                        environment: env == "production" ? .production : .sandbox
                    ),
                    eventLoopGroupProvider: .shared(eventLoopGroup)
                ),
                as: .apnsPush
            )
            
            try await registry.run()
            let push = try await registry.get(.apnsPush) as! PushService
            
            do {
                // TODO: enable push test suite
//                let suite = PushTestSuite(push)
//                try await suite.testAll()
                
                let notification = Notification(
                    title: "Test push notification",
                    body: "Test body for the push notification",
                    userInfo: [
                        "foo": "bar"
                    ],
                    delivery: .normal
                )

                let recipient = Recipient(
                    token: token,
                    platform: .ios
                )
                
                try await push.send(
                    notification: notification,
                    to: [recipient]
                )
                
                try await registry.shutdown()
            }
            catch {
                try await registry.shutdown()
                throw error
            }
        }
        catch {
            XCTFail("\(error)")
        }

        try await eventLoopGroup.shutdownGracefully()
    }

}
