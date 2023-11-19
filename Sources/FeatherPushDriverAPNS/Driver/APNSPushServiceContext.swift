//
//  APNSPushServiceContext.swift
//  FeatherPushDriverAPNS
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import NIO
import APNS
import FeatherService

struct APNSPushServiceContext: ServiceContext {

    let configuration: APNSClientConfiguration
    let eventLoopGroupProvider: NIOEventLoopGroupProvider
    let responseDecoder: JSONDecoder
    let requestEncoder: JSONEncoder
    let byteBufferAllocator: ByteBufferAllocator

    func createDriver() throws -> ServiceDriver {
        APNSPushServiceDriver(context: self)
    }

}
