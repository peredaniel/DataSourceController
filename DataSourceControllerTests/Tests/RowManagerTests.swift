//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import DataSourceController
import XCTest

class RowManagerTests: XCTestCase {
    let dataModels = DataModels()

    // MARK: - Add single row

    func testAddRowValidIndexPath() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let indexPath = IndexPath(row: Int.random(in: 0..<sections[sectionIndex].rows.count), section: sectionIndex)
        let newObject = "This is a new object"

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:section:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateSection = { index in
            XCTAssertEqual(indexPath.section, index)
            XCTAssertEqual(controller.modelObject(at: indexPath) as? String, newObject)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.add(row: newObject, at: indexPath, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testAddRowOutOfBoundsIndexPathBySection() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = sections.count + 1
        let indexPath = IndexPath(row: 10, section: sectionIndex)
        let newObject = "This is a new object"

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, sections.count + 1)
            XCTAssertEqual(controller.modelObject(at: IndexPath(row: 0, section: sections.count)) as? String, newObject)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.add(row: newObject, at: indexPath, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testAddRowOutOfBoundsIndexPathByRow() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let indexPath = IndexPath(row: sections[sectionIndex].rows.count + 10, section: sectionIndex)
        let newObject = "This is a new object"

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:section:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateSection = { index in
            XCTAssertEqual(indexPath.section, index)
            XCTAssertEqual(controller.sections[index].rows.last as? String, newObject)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.add(row: newObject, at: indexPath, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - Update single row

    func testUpdateRowValidIndexPath() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let indexPath = IndexPath(row: Int.random(in: 0..<sections[sectionIndex].rows.count), section: sectionIndex)
        let newObject = "This is a new object"

        XCTAssertTrue(controller.modelObject(at: indexPath) is Product)

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:rows:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateRows = { indexPaths in
            XCTAssertEqual(indexPaths.count, 1)
            XCTAssertEqual(indexPath, indexPaths.first)
            XCTAssertEqual(controller.modelObject(at: indexPath) as? String, newObject)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(row: newObject, at: indexPath, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testUpdateRowOutOfBoundsIndexPathBySection() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = sections.count + 1
        let indexPath = IndexPath(row: 10, section: sectionIndex)
        let newObject = "This is a new object"

        controller.update(row: newObject, at: indexPath, notify: true)

        XCTAssertEqual(controller.sections.flatMap { $0.rows as! [Product] }, sections.flatMap { $0.rows as! [Product] })
    }

    func testUpdateRowOutOfBoundsIndexPathByRow() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let indexPath = IndexPath(row: sections[sectionIndex].rows.count + 10, section: sectionIndex)
        let newObject = "This is a new object"

        controller.update(row: newObject, at: indexPath, notify: true)

        XCTAssertEqual(controller.sections.flatMap { $0.rows as! [Product] }, sections.flatMap { $0.rows as! [Product] })
    }

    // MARK: - Update all rows in section

    func testUpdateAllRowsInValidSection() {
        let section = dataModels.singleSectionWithSectionData
        let controller = DataSourceController(section: section)

        let sectionIndex = 0
        let newSectionRows = dataModels.pads

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:rows:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateRows = { indexPaths in
            XCTAssertEqual(indexPaths.map { $0.row }, (0..<newSectionRows.count).map { $0 })
            XCTAssertNotEqual(controller.sections[sectionIndex].rows as? [Product], self.dataModels.singleSectionWithSectionData.rows as? [Product])
            XCTAssertEqual(controller.sections[sectionIndex].rows as? [Product], newSectionRows)
            XCTAssertEqual(controller.sections[sectionIndex].sectionData?.header, section.sectionData?.header)
            XCTAssertEqual(controller.sections[sectionIndex].sectionData?.footer, section.sectionData?.footer)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(rows: newSectionRows, atSection: sectionIndex, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testUpdateAllRowsInOutOfBoundsSection() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = sections.count + 1
        let newSectionRows = dataModels.pads

        controller.update(rows: newSectionRows, atSection: sectionIndex, notify: true)

        XCTAssertEqual(controller.sections.flatMap { $0.rows as! [Product] }, sections.flatMap { $0.rows as! [Product] })
    }

    // MARK: - Update rows by IndexPath

    func testUpdateRowsValidIndexPaths() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let newRows: [IndexPath: Any] = {
            var rows: [IndexPath: Any] = [:]
            for _ in 0..<Int.random(in: 2...6) {
                let sectionIndex = Int.random(in: 0..<sections.count)
                let indexPath = IndexPath(row: Int.random(in: 0..<sections[sectionIndex].rows.count), section: sectionIndex)
                rows[indexPath] = "New object at position (\(indexPath.section), \(indexPath.row))"
            }
            return rows
        }()

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:rows:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateRows = { indexPaths in
            for section in 0..<sections.count {
                XCTAssertEqual(controller.sections[section].sectionData?.header, sections[section].sectionData?.header)
                XCTAssertEqual(controller.sections[section].sectionData?.footer, sections[section].sectionData?.footer)
                for row in 0..<sections[section].rows.count {
                    let indexPath = IndexPath(row: row, section: section)
                    let modelObject = controller.modelObject(at: indexPath)
                    if indexPaths.contains(indexPath) {
                        XCTAssertEqual(modelObject as? String, newRows[indexPath] as? String)
                    } else {
                        XCTAssertTrue(modelObject is Product)
                    }
                }
            }
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(rows: newRows, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testUpdateRowsEmptyValidIndexPaths() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let newRows: [IndexPath: Any] = [:]

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:rows:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateRows = { _ in
            for section in 0..<sections.count {
                XCTAssertEqual(controller.sections[section].sectionData?.header, sections[section].sectionData?.header)
                XCTAssertEqual(controller.sections[section].sectionData?.footer, sections[section].sectionData?.footer)
                for row in 0..<sections[section].rows.count {
                    XCTAssertTrue(controller.modelObject(at: IndexPath(row: row, section: section)) is Product)
                }
            }
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(rows: newRows, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testUpdateRowsInOutOfBoundsIndexPathBySection() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let newRows: [IndexPath: Any] = {
            var rows: [IndexPath: Any] = [:]
            for _ in 0..<Int.random(in: 2...6) {
                let sectionIndex = Int.random(in: 0..<sections.count)
                let indexPath = IndexPath(row: Int.random(in: 0..<sections[sectionIndex].rows.count), section: sectionIndex)
                rows[indexPath] = "New object at position (\(indexPath.section), \(indexPath.row))"
            }
            rows[IndexPath(row: 0, section: sections.count + 1)] = "Invalid object"
            return rows
        }()

        controller.update(rows: newRows, notify: true)
        XCTAssertEqual(controller.sections.flatMap { $0.rows as! [Product] }, sections.flatMap { $0.rows as! [Product] })
    }

    func testUpdateRowsInOutOfBoundsIndexPathByRow() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let validRows: [IndexPath: Any] = {
            var rows: [IndexPath: Any] = [:]
            for _ in 0..<Int.random(in: 2...6) {
                let sectionIndex = Int.random(in: 0..<sections.count)
                let indexPath = IndexPath(row: Int.random(in: 0..<sections[sectionIndex].rows.count), section: sectionIndex)
                rows[indexPath] = "New object at position (\(indexPath.section), \(indexPath.row))"
            }
            return rows
        }()

        let invalidRows: [IndexPath: Any] = {
            var rows: [IndexPath: Any] = [:]
            for _ in 0..<Int.random(in: 2...6) {
                let sectionIndex = Int.random(in: 0..<sections.count)
                let indexPath = IndexPath(row: sections[sectionIndex].rows.count + Int.random(in: 0...10), section: sectionIndex)
                rows[indexPath] = "New object at position (\(indexPath.section), \(indexPath.row))"
            }
            return rows
        }()

        let newRows = validRows.merging(invalidRows) { _, new in new }

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:rows:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateRows = { indexPaths in
            XCTAssertEqual(indexPaths.sorted(), validRows.keys.map { $0 }.sorted())
            for indexPath in indexPaths {
                XCTAssertFalse(invalidRows.keys.map { $0 }.contains(indexPath))
            }
            for section in 0..<sections.count {
                XCTAssertEqual(controller.sections[section].sectionData?.header, sections[section].sectionData?.header)
                XCTAssertEqual(controller.sections[section].sectionData?.footer, sections[section].sectionData?.footer)
                for row in 0..<sections[section].rows.count {
                    let indexPath = IndexPath(row: row, section: section)
                    let modelObject = controller.modelObject(at: indexPath)
                    if indexPaths.contains(indexPath) {
                        XCTAssertEqual(modelObject as? String, newRows[indexPath] as? String)
                    } else {
                        XCTAssertTrue(modelObject is Product)
                    }
                }
            }
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(rows: newRows, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - Remove single row

    func testRemoveRowValidIndexPath() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let indexPath = IndexPath(row: Int.random(in: 0..<sections[sectionIndex].rows.count), section: sectionIndex)
        let numberOfRows = sections[sectionIndex].rows.count

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, sections.count)
            XCTAssertEqual(controller.sections[sectionIndex].rows.count, numberOfRows - 1)
            XCTAssertEqual(controller.sections[sectionIndex].sectionData?.header, sections[sectionIndex].sectionData?.header)
            XCTAssertEqual(controller.sections[sectionIndex].sectionData?.footer, sections[sectionIndex].sectionData?.footer)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.remove(rowAt: indexPath, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testRemoveLastRowValidIndexPath() {
        let sections = dataModels.multipleSectionsWithSectionData + [Section(rows: ["This is a single row"])]
        let controller = DataSourceController(sections: sections)

        let sectionIndex = sections.count - 1
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        let numberOfSections = sections.count

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, numberOfSections - 1)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.remove(rowAt: indexPath, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testRemoveRowOutOfBoundsIndexPathBySection() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = sections.count + 1
        let indexPath = IndexPath(row: 0, section: sectionIndex)

        controller.remove(rowAt: indexPath, notify: true)
        XCTAssertEqual(controller.sections.flatMap { $0.rows as! [Product] }, sections.flatMap { $0.rows as! [Product] })
    }

    func testRemoveRowOutOfBoundsIndexPathByRow() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let indexPath = IndexPath(row: sections[sectionIndex].rows.count + 10, section: sectionIndex)

        controller.remove(rowAt: indexPath, notify: true)
        XCTAssertEqual(controller.sections.flatMap { $0.rows as! [Product] }, sections.flatMap { $0.rows as! [Product] })
    }
}
