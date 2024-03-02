//
//  APNSPushComponentContext.swift
//  FeatherPushDriverAPNS
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherComponent
import Foundation
import NIO
import APNS
import FeatherComponent

public struct APNSPushComponentContext: ComponentContext {

    let configuration: APNSClientConfiguration
    let eventLoopGroupProvider: NIOEventLoopGroupProvider
    let responseDecoder: JSONDecoder
    let requestEncoder: JSONEncoder
    let byteBufferAllocator: ByteBufferAllocator

    public init(
        configuration: APNSClientConfiguration,
        eventLoopGroupProvider: NIOEventLoopGroupProvider = .createNew,
        responseDecoder: JSONDecoder = .init(),
        requestEncoder: JSONEncoder = .init(),
        byteBufferAllocator: ByteBufferAllocator = .init()
    ) {
        self.configuration = configuration
        self.eventLoopGroupProvider = eventLoopGroupProvider
        self.responseDecoder = responseDecoder
        self.requestEncoder = requestEncoder
        self.byteBufferAllocator = byteBufferAllocator
    }

    public func make() throws -> ComponentBuilder {
        APNSPushComponentBuilder(context: self)
    }

}
