//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

public protocol CellDataController {
    var reuseIdentifier: String { get }
    static func populate(with model: Any) -> CellDataController
}
