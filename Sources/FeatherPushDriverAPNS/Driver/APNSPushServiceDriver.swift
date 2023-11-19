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

    let context: APNSPushServiceContext
    
    init(context: APNSPushServiceContext) {
        self.context = context
    }
    
    func run(using config: ServiceConfig) throws -> Service {
        APNSPushService(config: config)
    }
}
