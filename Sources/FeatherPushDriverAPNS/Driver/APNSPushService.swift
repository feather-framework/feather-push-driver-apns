//
//  APNSPushService.swift
//  FeatherPushDriverAPNS
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherService
import FeatherPush
@preconcurrency import APNS
import Foundation

extension Platform {

    // TODO: macOS, tvOS, watchOS support?
    var isAPNSCompatible: Bool {
        switch self {
        case .ios:
            return true
        default:
            return false
        }
    }
}

@dynamicMemberLookup
struct APNSPushService {

    let config: ServiceConfig
    let client: APNSClient<JSONDecoder, JSONEncoder>

    subscript<T>(
        dynamicMember keyPath: KeyPath<APNSPushServiceContext, T>
    ) -> T {
        let context = config.context as! APNSPushServiceContext
        return context[keyPath: keyPath]
    }

    init(config: ServiceConfig, client: APNSClient<JSONDecoder, JSONEncoder>) {
        self.config = config
        self.client = client
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
                    topic: "general", // TODO: use proper topic / bundle id
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
    }
}
