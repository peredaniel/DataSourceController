//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

public protocol SectionDataControllerType {
    var headerTitle: String? { get }
    var footerTitle: String? { get }
}

open class SectionDataController: SectionDataControllerType {
    public private(set) var headerTitle: String?
    public private(set) var footerTitle: String?

    public init(
        header: String?,
        footer: String?
    ) {
        headerTitle = header
        footerTitle = footer
    }

    public convenience init(_ model: SectionDataModelType) {
        self.init(header: model.header, footer: model.footer)
    }
}
