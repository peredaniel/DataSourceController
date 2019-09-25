//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

public protocol SectionDataModelType {
    var header: String? { get }
    var footer: String? { get }
}

public struct SectionDataModel: SectionDataModelType {
    public private(set) var header: String?
    public private(set) var footer: String?

    public init(
        header: String? = nil,
        footer: String? = nil
    ) {
        self.header = header
        self.footer = footer
    }
}
