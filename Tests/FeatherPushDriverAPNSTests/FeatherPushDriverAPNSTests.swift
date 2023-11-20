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

            //            let appBundleID = "com.your.app.bundle.id"
            //            let privateP8Key = """
            //                -----BEGIN PRIVATE KEY-----
            //                #add your p8 private key here#
            //                -----END PRIVATE KEY-----
            //                """
            //            let keyIdentifier = "add your key identifier here"
            //            let teamIdentifier = "add your team identifier here"

            try await registry.add(
                APNSPushServiceContext(
                    configuration: .init(
                        authenticationMethod: .jwt(
                            privateKey: try! .loadFrom(string: self.privateKey),  // try .init(pemRepresentation: privateP8Key)
                            keyIdentifier: self.keyId,
                            teamIdentifier: self.teamId
                        ),
                        environment: self.env == "production"
                            ? .production : .sandbox
                    ),
                    eventLoopGroupProvider: .shared(eventLoopGroup)
                )
            )

            try await registry.run()
            let push = try await registry.push()

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
                    platform: .iOS
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
