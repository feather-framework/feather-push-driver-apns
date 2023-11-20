//
//  APNSPushService.swift
//  FeatherPushDriverAPNS
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherService
import FeatherPush
import APNS
import Foundation

extension Platform {

    // TODO: macOS, tvOS, watchOS support?
    var isAPNSCompatible: Bool {
        switch self {
        case .iOS, .macOS, .tvOS, .watchOS, .visionOS, .safari:
            return true
        default:
            return false
        }
    }
}

@dynamicMemberLookup
struct APNSPushService {

    let config: ServiceConfig

    subscript<T>(
        dynamicMember keyPath: KeyPath<APNSPushServiceContext, T>
    ) -> T {
        let context = config.context as! APNSPushServiceContext
        return context[keyPath: keyPath]
    }

    init(config: ServiceConfig) {
        self.config = config
    }
}

extension APNSPushService: PushService {

    func send(
        notification: FeatherPush.Notification,
        to recipients: [Recipient]
    ) async throws {
        let recipients = recipients.filter { $0.platform.isAPNSCompatible }
        guard !recipients.isEmpty else {
            return
        }

        let client = APNSClient<JSONDecoder, JSONEncoder>(
            configuration: self.configuration,
            eventLoopGroupProvider: self.eventLoopGroupProvider,
            responseDecoder: self.responseDecoder,
            requestEncoder: self.requestEncoder
        )
        for recipient in recipients {
            _ = try? await client.sendAlertNotification(
                .init(
                    alert: .init(
                        title: .raw(notification.title),
                        subtitle: nil,
                        body: .raw(notification.body),
                        launchImage: nil
                    ),
                    expiration: .immediately,
                    priority: .immediately,
                    topic: "general",  // TODO: use proper topic / bundle id
                    payload: notification.userInfo,
                    badge: nil,
                    sound: nil,
                    threadID: nil,
                    category: nil,
                    mutableContent: nil,
                    targetContentID: nil,
                    interruptionLevel: nil,
                    relevanceScore: nil,
                    apnsID: nil
                ),
                deviceToken: recipient.token
            )
        }

        try client.syncShutdown()
    }
}
