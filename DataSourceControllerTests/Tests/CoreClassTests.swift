//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

@testable import DataSourceController
import XCTest

class CoreClassTests: XCTestCase {
    let dataModels = DataModels()

    func testInitializerWithRowsSuccessfullyInitializes() {
        // Given
        let rows = dataModels.phones

        // When
        let controller = DataSourceController(rows: rows)

        let withinBoundsSection: Int = .zero
        let outOfBoundsSection = Int.random(in: 1...Int.max)
        let withinBoundsIndexPath = IndexPath(row: Int.random(in: 0..<rows.count), section: withinBoundsSection)
        let outOfBoundsIndexPathBySection = IndexPath(row: Int.random(in: Int.min...Int.max), section: outOfBoundsSection)
        let outOfBoundsIndexPathByRow = IndexPath(row: Int.random(in: rows.count...Int.max), section: withinBoundsSection)

        // Then
        XCTAssertEqual(controller.sectionCount, 1)
        XCTAssertEqual(controller.rowCount(for: withinBoundsSection), dataModels.phones.count)
        XCTAssertEqual(controller.rowCount(for: outOfBoundsSection), .zero)
        XCTAssertEqual(controller.totalRowCount, dataModels.phones.count)

        XCTAssertNil(controller.data(for: withinBoundsSection))
        XCTAssertNil(controller.data(for: outOfBoundsSection))

        XCTAssertNotNil(controller.modelObject(at: withinBoundsIndexPath) as? Product)
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathBySection))
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathByRow))
    }

    func testInitializerWithSingleSectionNoSectionDataSuccessfullyInitializes() {
        // Given
        let section = dataModels.singleSectionNoSectionData

        // When
        let controller = DataSourceController(section: section)

        let withinBoundsSection = 0
        let outOfBoundsSection = Int.random(in: 1...Int.max)
        let withinBoundsIndexPath = IndexPath(row: Int.random(in: 0..<section.rows.count), section: withinBoundsSection)
        let outOfBoundsIndexPathBySection = IndexPath(row: Int.random(in: Int.min...Int.max), section: outOfBoundsSection)
        let outOfBoundsIndexPathByRow = IndexPath(row: Int.random(in: section.rows.count...Int.max), section: withinBoundsSection)

        // Then
        XCTAssertEqual(controller.sectionCount, 1)
        XCTAssertEqual(controller.rowCount(for: withinBoundsSection), section.rows.count)
        XCTAssertEqual(controller.rowCount(for: outOfBoundsSection), 0)
        XCTAssertEqual(controller.totalRowCount, section.rows.count)

        XCTAssertNil(controller.data(for: withinBoundsSection))
        XCTAssertNil(controller.data(for: outOfBoundsSection))

        XCTAssertNotNil(controller.modelObject(at: withinBoundsIndexPath) as? Product)
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathBySection))
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathByRow))
    }

    func testInitializerWithSingleSectionWithSectionDataSuccessfullyInitializes() {
        // Given
        let section = dataModels.singleSectionWithSectionData

        // When
        let controller = DataSourceController(section: section)

        let withinBoundsSection = 0
        let outOfBoundsSection = Int.random(in: 1...Int.max)
        let withinBoundsIndexPath = IndexPath(row: Int.random(in: 0..<section.rows.count), section: withinBoundsSection)
        let outOfBoundsIndexPathBySection = IndexPath(row: Int.random(in: Int.min...Int.max), section: outOfBoundsSection)
        let outOfBoundsIndexPathByRow = IndexPath(row: Int.random(in: section.rows.count...Int.max), section: withinBoundsSection)

        // Then
        XCTAssertEqual(controller.sectionCount, 1)
        XCTAssertEqual(controller.rowCount(for: withinBoundsSection), section.rows.count)
        XCTAssertEqual(controller.rowCount(for: outOfBoundsSection), 0)
        XCTAssertEqual(controller.totalRowCount, section.rows.count)

        XCTAssertNil(controller.data(for: outOfBoundsSection))

        XCTAssertNotNil(controller.data(for: withinBoundsSection))
        XCTAssertEqual(controller.data(for: withinBoundsSection)?.header, "Header")
        XCTAssertEqual(controller.data(for: withinBoundsSection)?.footer, "Footer")

        XCTAssertNotNil(controller.modelObject(at: withinBoundsIndexPath) as? Product)
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathBySection))
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathByRow))
    }

    func testInitializerWithMultipleSectionNoDataSuccessfullyInitializes() {
        // Given
        let sections = dataModels.multipleSectionsNoSectionData

        // When
        let controller = DataSourceController(sections: sections)

        let withinBoundsSection = Int.random(in: 0..<sections.count)
        let outOfBoundsSection = Int.random(in: sections.count...Int.max)
        let withinBoundsIndexPath = IndexPath(row: Int.random(in: 0..<sections[withinBoundsSection].rows.count), section: withinBoundsSection)
        let outOfBoundsIndexPathBySection = IndexPath(row: Int.random(in: Int.min...Int.max), section: outOfBoundsSection)
        let outOfBoundsIndexPathByRow = IndexPath(row: Int.random(in: sections[withinBoundsSection].rows.count...Int.max), section: withinBoundsSection)

        // Then
        XCTAssertEqual(controller.sectionCount, sections.count)
        XCTAssertEqual(controller.rowCount(for: withinBoundsSection), sections[withinBoundsSection].rows.count)
        XCTAssertEqual(controller.rowCount(for: outOfBoundsSection), 0)
        XCTAssertEqual(controller.totalRowCount, sections.flatMap { $0.rows }.count)

        XCTAssertNil(controller.data(for: withinBoundsSection))
        XCTAssertNil(controller.data(for: outOfBoundsSection))

        XCTAssertNotNil(controller.modelObject(at: withinBoundsIndexPath) as? Product)
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathBySection))
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathByRow))
    }

    func testInitializerWithMultipleSectionMixingSectionDataSuccessfullyInitializes() {
        // Given
        let sections = dataModels.multipleSectionsMixingSectionData

        // When
        let controller = DataSourceController(sections: sections)

        let withinBoundsSection = Int.random(in: 0..<sections.count)
        let sectionWithData = 2
        let sectionNoData = 1
        let outOfBoundsSection = Int.random(in: sections.count...Int.max)
        let withinBoundsIndexPath = IndexPath(row: Int.random(in: 0..<sections[withinBoundsSection].rows.count), section: withinBoundsSection)
        let outOfBoundsIndexPathBySection = IndexPath(row: Int.random(in: Int.min...Int.max), section: outOfBoundsSection)
        let outOfBoundsIndexPathByRow = IndexPath(row: Int.random(in: sections[withinBoundsSection].rows.count...Int.max), section: withinBoundsSection)

        // Then
        XCTAssertEqual(controller.sectionCount, sections.count)
        XCTAssertEqual(controller.rowCount(for: withinBoundsSection), sections[withinBoundsSection].rows.count)
        XCTAssertEqual(controller.rowCount(for: outOfBoundsSection), .zero)
        XCTAssertEqual(controller.totalRowCount, sections.flatMap { $0.rows }.count)

        XCTAssertNil(controller.data(for: sectionNoData))

        XCTAssertNotNil(controller.data(for: sectionWithData))
        XCTAssertEqual(controller.data(for: sectionWithData)?.header, "Header")
        XCTAssertEqual(controller.data(for: sectionWithData)?.footer, "Footer")

        XCTAssertNotNil(controller.modelObject(at: withinBoundsIndexPath) as? Product)
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathBySection))
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathByRow))
    }

    func testInitializerWithMultipleSectionWithSectionDataSuccessfullyInitializes() {
        // Given
        let sections = dataModels.multipleSectionsWithSectionData

        // When
        let controller = DataSourceController(sections: sections)

        let withinBoundsSection = Int.random(in: 0..<sections.count)
        let outOfBoundsSection = Int.random(in: sections.count...Int.max)
        let withinBoundsIndexPath = IndexPath(row: Int.random(in: 0..<sections[withinBoundsSection].rows.count), section: withinBoundsSection)
        let outOfBoundsIndexPathBySection = IndexPath(row: Int.random(in: Int.min...Int.max), section: outOfBoundsSection)
        let outOfBoundsIndexPathByRow = IndexPath(row: Int.random(in: sections[withinBoundsSection].rows.count...Int.max), section: withinBoundsSection)

        // Then
        XCTAssertEqual(controller.sectionCount, sections.count)
        XCTAssertEqual(controller.rowCount(for: withinBoundsSection), sections[withinBoundsSection].rows.count)
        XCTAssertEqual(controller.rowCount(for: outOfBoundsSection), .zero)
        XCTAssertEqual(controller.totalRowCount, sections.flatMap { $0.rows }.count)

        XCTAssertNil(controller.data(for: outOfBoundsSection))

        XCTAssertNotNil(controller.data(for: withinBoundsSection))
        XCTAssertEqual(controller.data(for: withinBoundsSection)?.header, "Header")
        XCTAssertEqual(controller.data(for: withinBoundsSection)?.footer, "Footer")

        XCTAssertNotNil(controller.modelObject(at: withinBoundsIndexPath) as? Product)
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathBySection))
        XCTAssertNil(controller.modelObject(at: outOfBoundsIndexPathByRow))
    }

    func testRegisterCellDataControllerWithExpectedModelTypeReturnsControllerPopulated() {
        // Given
        let section = dataModels.singleSectionNoSectionData
        let controller = DataSourceController(section: section)

        // When
        controller.register(dataController: MockCellDataController.self, for: Product.self)
        let product = section.rows.randomElement()!
        let dataController = controller.dataController(for: product) as? MockCellDataController

        // Then
        XCTAssertNotNil(dataController)
        XCTAssertTrue(dataController!.populateFunctionHasBeenCalled)
    }

    func testRegisterCellDataControllerWithExpectedModelTypeAndCallForAnotherReturnsNil() {
        // Given
        let section = dataModels.singleSectionNoSectionData
        let controller = DataSourceController(section: section)

        // When
        controller.register(dataController: MockCellDataController.self, for: Product.self)
        let dataController = controller.dataController(for: String()) // We have registered MockCellDataController for Product and not String

        // Then
        XCTAssertNil(dataController)
    }

    func testRegisterCellDataControllerWithNonExpectedModelTypeReturnsControllerNotPopulated() {
        // Given
        let section = Section(rows: dataModels.phones.map { $0.name })
        let controller = DataSourceController(section: section)

        // When
        controller.register(dataController: MockCellDataController.self, for: String.self) // MockCellDataController can't be populated with String as per implementation
        let string = section.rows.randomElement()!
        let dataController = controller.dataController(for: string) as? MockCellDataController

        // Then
        XCTAssertNotNil(dataController)
        XCTAssertFalse(dataController!.populateFunctionHasBeenCalled)
    }

    func testRegisterSameDataControllerToDifferentObjects() {
        // Given
        let section = dataModels.singleSectionNoSectionData
        let controller = DataSourceController(section: section)

        // When
        controller.register(dataController: MockCellDataController.self, for: Product.self)
        controller.register(dataController: MockCellDataController.self, for: String.self)
        let product = section.rows.randomElement()!
        let productDataController = controller.dataController(for: product) as? MockCellDataController
        let stringDataController = controller.dataController(for: String()) as? MockCellDataController

        // Then
        XCTAssertNotNil(productDataController)
        XCTAssertTrue(productDataController!.populateFunctionHasBeenCalled)

        XCTAssertNotNil(stringDataController)
        XCTAssertFalse(stringDataController!.populateFunctionHasBeenCalled)
    }

    func testRegisterDifferentDataControllerToSameObject() {
        // Given
        let section = dataModels.singleSectionNoSectionData
        let controller = DataSourceController(section: section)

        // When
        controller.register(dataController: MockCellDataController.self, for: Product.self)
        controller.register(dataController: SecondaryMockCellDataController.self, for: Product.self)
        let product = section.rows.randomElement()!
        let dataController = controller.dataController(for: product)

        // Then
        XCTAssertNil(dataController as? MockCellDataController)

        XCTAssertNotNil(dataController as? SecondaryMockCellDataController)
        XCTAssertTrue((dataController as! SecondaryMockCellDataController).populateFunctionHasBeenCalled)
    }

    func testRegisterCellDataControllerToCellDataController() {
        // Given
        let section = dataModels.singleSectionNoSectionData
        let controller = DataSourceController(section: section)

        // When
        controller.register(dataController: MockCellDataController.self, for: Product.self)
        controller.register(dataController: SecondaryMockCellDataController.self, for: MockCellDataController.self)
        let product = section.rows.randomElement()!
        let dataController = controller.dataController(for: product) as? MockCellDataController
        let secondaryDataController = controller.dataController(for: MockCellDataController(false)) as? MockCellDataController

        // Then
        XCTAssertNotNil(dataController)
        XCTAssertTrue(dataController!.populateFunctionHasBeenCalled)

        XCTAssertNotNil(secondaryDataController)
        XCTAssertFalse(secondaryDataController!.populateFunctionHasBeenCalled)
    }
}
