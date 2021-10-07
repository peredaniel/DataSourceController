//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

public protocol DataSourceControllerDelegate: AnyObject {
    func backgroundEmptyView(for view: UIView) -> UIView?
    func dataSourceWasMutated(_ datasource: DataSourceController)
    func dataSourceWasMutated(_ datasource: DataSourceController, section: Int)
    func dataSourceWasMutated(_ datasource: DataSourceController, rows: [IndexPath])
}

public extension DataSourceControllerDelegate {
    func backgroundEmptyView(for _: UIView) -> UIView? { return nil }
    func dataSourceWasMutated(_: DataSourceController) {}
    func dataSourceWasMutated(_: DataSourceController, section _: Int) {}
    func dataSourceWasMutated(_: DataSourceController, rows _: [IndexPath]) {}
}
