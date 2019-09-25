//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController

class MockDataSourceControllerDelegate: DataSourceControllerDelegate {
    var didMutateDataSource: (() -> Void)?
    var didMutateSection: ((Int) -> Void)?
    var didMutateRows: (([IndexPath]) -> Void)?

    func dataSourceWasMutated(_: DataSourceController) {
        didMutateDataSource?()
    }

    func dataSourceWasMutated(_: DataSourceController, section: Int) {
        didMutateSection?(section)
    }

    func dataSourceWasMutated(_: DataSourceController, rows: [IndexPath]) {
        didMutateRows?(rows)
    }
}
