//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import DataSourceController
import SnapshotTesting
import XCTest

class UITableViewDataSourceTests: XCTestCase {
    let dataModels = DataModels()
    let viewController = MockTableViewController()

    func testEmptySectionBackgroundMessageDisplaysCorrectly() {
        let controller = DataSourceController(rows: [])

        viewController.dataSourceController = controller
        _ = viewController.view

        assertSnapshot(matching: viewController, as: .image)
    }

    func testSingleSectionNoSectionDataDisplaysCorrectly() {
        let controller = DataSourceController(section: dataModels.singleSectionNoSectionData)
        controller.register(dataController: MockCellDataController.self, for: Product.self)

        viewController.dataSourceController = controller
        _ = viewController.view

        assertSnapshot(matching: viewController, as: .image)
    }

    func testSingleSectionWithSectionDataDisplaysCorrectly() {
        let controller = DataSourceController(section: dataModels.singleSectionWithSectionData)
        controller.register(dataController: MockCellDataController.self, for: Product.self)

        viewController.dataSourceController = controller
        _ = viewController.view

        assertSnapshot(matching: viewController, as: .image)
    }

    func testMultipleSectionsNoSectionDataDisplaysCorrectly() {
        let controller = DataSourceController(sections: dataModels.multipleSectionsNoSectionData)
        controller.register(dataController: MockCellDataController.self, for: Product.self)

        viewController.dataSourceController = controller
        _ = viewController.view

        assertSnapshot(matching: viewController, as: .image)
    }

    func testMultipleSectionsWithSectionDataDisplaysCorrectly() {
        let controller = DataSourceController(sections: dataModels.multipleSectionsWithSectionData)
        controller.register(dataController: MockCellDataController.self, for: Product.self)

        viewController.dataSourceController = controller
        _ = viewController.view

        assertSnapshot(matching: viewController, as: .image)
    }

    func testUnregisteredDataControllerDisplaysError() {
        let controller = DataSourceController(sections: dataModels.multipleSectionsNoSectionData)
        controller.register(dataController: MockCellDataController.self, for: String.self)

        viewController.dataSourceController = controller
        _ = viewController.view

        assertSnapshot(matching: viewController, as: .image)
    }
}
