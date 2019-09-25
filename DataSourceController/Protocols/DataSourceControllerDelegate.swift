//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

public protocol DataSourceControllerDelegate: AnyObject {
    func backgroundMessageLabel(for view: UIView) -> UILabel?
    func dataSourceWasMutated(_ datasource: DataSourceController)
    func dataSourceWasMutated(_ datasource: DataSourceController, section: Int)
    func dataSourceWasMutated(_ datasource: DataSourceController, rows: [IndexPath])
}

public extension DataSourceControllerDelegate {
    func backgroundMessageLabel(for _: UIView) -> UILabel? { return nil }
    func dataSourceWasMutated(_: DataSourceController) {}
    func dataSourceWasMutated(_: DataSourceController, section _: Int) {}
    func dataSourceWasMutated(_: DataSourceController, rows _: [IndexPath]) {}
}
