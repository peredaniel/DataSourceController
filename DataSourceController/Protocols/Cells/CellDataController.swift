//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

public protocol CellDataController {
    var reuseIdentifier: String { get }
    static func populate(with model: Any) -> CellDataController
}
