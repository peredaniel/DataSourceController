//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation

public protocol SectionDataControllerType {
    var headerTitle: String? { get }
    var footerTitle: String? { get }
}

open class SectionDataController: SectionDataControllerType {
    private(set) public var headerTitle: String?
    private(set) public var footerTitle: String?

    public init(header: String?, footer: String?) {
        headerTitle = header
        footerTitle = footer
    }

    public convenience init(_ model: SectionDataModelType) {
        self.init(header: model.header, footer: model.footer)
    }
}
