//
//  ServiceContextFactory+APNSPushService.swift
//  FeatherPushDriverAPNS
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherService
import Foundation
import NIO
import APNS

public extension ServiceContextFactory {

    static func apnsPush(
        configuration: APNSClientConfiguration,
        eventLoopGroupProvider: NIOEventLoopGroupProvider = .createNew,
        responseDecoder: JSONDecoder = .init(),
        requestEncoder: JSONEncoder = .init(),
        byteBufferAllocator: ByteBufferAllocator = .init()
    ) -> Self {
        .init {
            APNSPushServiceContext(
                configuration: configuration,
                eventLoopGroupProvider: eventLoopGroupProvider,
                responseDecoder: responseDecoder,
                requestEncoder: requestEncoder,
                byteBufferAllocator: byteBufferAllocator
            )
        }
    }
}
