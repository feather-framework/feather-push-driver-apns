//
//  APNSPushComponentBuilder.swift
//  FeatherPushDriverAPNS
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherComponent
import Foundation
import APNS

struct APNSPushComponentBuilder: ComponentBuilder {

    let context: APNSPushComponentContext

    init(context: APNSPushComponentContext) {
        self.context = context
    }

    func build(using config: ComponentConfig) throws -> Component {
        APNSPushComponent(config: config)
    }

}
