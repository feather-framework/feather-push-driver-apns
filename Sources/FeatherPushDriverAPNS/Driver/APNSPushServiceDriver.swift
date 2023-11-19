//
//  APNSPushServiceDriver.swift
//  FeatherPushDriverAPNS
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherService
import Foundation
import APNS

struct APNSPushServiceDriver: ServiceDriver {

    let client: APNSClient<JSONDecoder, JSONEncoder>
    let context: APNSPushServiceContext
    
    init(context: APNSPushServiceContext) {
        self.context = context
        self.client = .init(
            configuration: context.configuration,
            eventLoopGroupProvider: context.eventLoopGroupProvider,
            responseDecoder: context.responseDecoder,
            requestEncoder: context.requestEncoder
        )
    }
    
    func run(using config: ServiceConfig) throws -> Service {
        APNSPushService(config: config, client: client)
    }
    
    func shutdown() throws {
        try client.syncShutdown()
    }
}
