//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation

public protocol SectionDataModelType {
    var header: String? { get }
    var footer: String? { get }
}

public struct SectionDataModel: SectionDataModelType {
    private(set) public var header: String?
    private(set) public var footer: String?

    public init(header: String? = nil, footer: String? = nil) {
        self.header = header
        self.footer = footer
    }
}
