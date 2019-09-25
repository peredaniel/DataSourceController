//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import DataSourceController
import XCTest

class SectionManagerTests: XCTestCase {
    let dataModels = DataModels()

    // MARK: - Add single section

    func testAddSectionValidIndex() {
        let section = dataModels.singleSectionWithSectionData
        let controller = DataSourceController(section: section)

        let newSectionIndex = 0
        let newSection = Section(sectionData: SectionDataModel(header: "New header", footer: "New footer"), rows: dataModels.pads)
        let sectionCount = 1

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, sectionCount + 1)
            XCTAssertNotEqual(controller.sections[newSectionIndex].rows as! [Product], self.dataModels.phones)
            XCTAssertEqual(controller.sections[newSectionIndex].rows as! [Product], newSection.rows as! [Product])
            XCTAssertNotNil(controller.data(for: newSectionIndex))
            XCTAssertEqual(controller.data(for: newSectionIndex)?.header, newSection.sectionData?.header)
            XCTAssertEqual(controller.data(for: newSectionIndex)?.footer, newSection.sectionData?.footer)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.add(section: newSection, at: newSectionIndex, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testAddSectionOutOfBoundsIndex() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let newSectionIndex = sections.count + 1
        let newSection = Section(sectionData: SectionDataModel(header: "New header", footer: "New footer"), rows: dataModels.pads)
        let sectionCount = sections.count

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, sectionCount + 1)
            XCTAssertEqual(controller.sections.last!.rows as! [Product], newSection.rows as! [Product])
            XCTAssertNotNil(controller.data(for: controller.sectionCount - 1))
            XCTAssertEqual(controller.data(for: controller.sectionCount - 1)?.header, newSection.sectionData?.header)
            XCTAssertEqual(controller.data(for: controller.sectionCount - 1)?.footer, newSection.sectionData?.footer)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.add(section: newSection, at: newSectionIndex, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - Update full section

    func testUpdateSectionValidIndex() {
        let section = dataModels.singleSectionWithSectionData
        let controller = DataSourceController(section: section)

        let newSection = Section(sectionData: SectionDataModel(header: "New header", footer: "New footer"), rows: dataModels.pads)

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:section:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateSection = { index in
            XCTAssertEqual(index, 0)
            XCTAssertNotEqual(controller.sections[index].rows as! [Product], self.dataModels.phones)
            XCTAssertEqual(controller.sections[index].rows as! [Product], newSection.rows as! [Product])
            XCTAssertNotNil(controller.data(for: index))
            XCTAssertEqual(controller.data(for: 0)?.header, newSection.sectionData?.header)
            XCTAssertEqual(controller.data(for: 0)?.footer, newSection.sectionData?.footer)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(section: newSection, at: 0, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testUpdateSectionOutOfBoundsIndex() {
        let section = dataModels.singleSectionWithSectionData
        let controller = DataSourceController(section: section)

        let newSection = Section(sectionData: SectionDataModel(header: "New header", footer: "New footer"), rows: dataModels.pads)

        controller.update(section: newSection, at: 2, notify: true)

        XCTAssertEqual(controller.sections[0].rows as! [Product], dataModels.phones)
        XCTAssertNotNil(controller.data(for: 0))
        XCTAssertNotEqual(controller.data(for: 0)?.header, newSection.sectionData?.header)
        XCTAssertNotEqual(controller.data(for: 0)?.footer, newSection.sectionData?.footer)
    }

    // MARK: - Update section data

    func testUpdateSectionDataValidIndex() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let originalRows = sections[sectionIndex].rows as! [Product]
        let newSectionData = SectionDataModel(header: "New header", footer: "New footer")

        for index in 0..<controller.sectionCount {
            XCTAssertNil(controller.data(for: index))
        }

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:section:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateSection = { index in
            XCTAssertEqual(index, sectionIndex)
            XCTAssertNotNil(controller.data(for: index))
            XCTAssertEqual(controller.sections[index].rows as! [Product], originalRows)
            XCTAssertEqual(controller.data(for: index)?.header, newSectionData.header)
            XCTAssertEqual(controller.data(for: index)?.footer, newSectionData.footer)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(sectionData: newSectionData, at: sectionIndex, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testUpdateSectionDataOutOfBoundsIndex() {
        let sections = dataModels.multipleSectionsNoSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = sections.count + 1
        let newSectionData = SectionDataModel(header: "New header", footer: "New footer")

        controller.update(sectionData: newSectionData, at: sectionIndex, notify: true)

        for index in 0..<controller.sectionCount {
            XCTAssertNil(controller.data(for: index))
        }
    }

    // MARK: - Update all sections

    func testUpdateAllSections() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let newSections = [dataModels.singleSectionNoSectionData]

        for index in 0..<controller.sectionCount {
            XCTAssertNotNil(controller.data(for: index))
        }

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, newSections.count)
            XCTAssertNil(controller.data(for: 0))
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.update(allSections: newSections)
        waitForExpectations(timeout: 1.0)
    }

    // MARK: - Remove single section

    func testRemoveSectionValidIndex() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = Int.random(in: 0..<sections.count)
        let sectionCount = sections.count

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, sectionCount - 1)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.remove(sectionAt: sectionIndex, notify: true)
        waitForExpectations(timeout: 1.0)
    }

    func testRemoveSectionOutOfBoundsIndex() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let sectionIndex = sections.count + 1
        let sectionCount = sections.count

        controller.remove(sectionAt: sectionIndex, notify: true)
        XCTAssertEqual(controller.sectionCount, sectionCount)
    }

    // MARK: - Remove all sections

    func testAllSections() {
        let sections = dataModels.multipleSectionsWithSectionData
        let controller = DataSourceController(sections: sections)

        let mutationExpectation = expectation(description: "dataSourceWasMutated(_:) has been called")
        let delegate = MockDataSourceControllerDelegate()
        delegate.didMutateDataSource = {
            XCTAssertEqual(controller.sectionCount, 0)
            mutationExpectation.fulfill()
        }
        controller.delegate = delegate

        controller.removeAllSections(notify: true)
        waitForExpectations(timeout: 1.0)
    }
}
