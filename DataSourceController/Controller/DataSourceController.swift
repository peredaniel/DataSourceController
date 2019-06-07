//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import UIKit

public class Section {
    public var rows: [Any]
    public var sectionData: SectionDataModelType?

    public init(sectionData: SectionDataModelType? = nil, rows: [Any]) {
        self.sectionData = sectionData
        self.rows = rows
    }
}

struct ModelDataControllerPair {
    let model: Any.Type
    let dataController: CellDataController.Type

    func modelMatches(_ modelInstance: Any) -> Bool {
        return model == type(of: modelInstance)
    }
}

open class ModelDataControllerMap: NSObject {
    private var modelControllerMap: [ModelDataControllerPair] = []

    public func register(dataController: CellDataController.Type, for model: Any.Type) {
        let pair = ModelDataControllerPair(model: model, dataController: dataController)
        modelControllerMap.append(pair)
    }

    public func dataController(for modelObject: Any) -> CellDataController? {
        if let dataController = modelObject as? CellDataController {
            return dataController
        }

        let dataController = modelControllerMap.first { $0.modelMatches(modelObject) }?.dataController
        return dataController?.populate(with: modelObject)
    }
}

public class DataSourceController: ModelDataControllerMap {
    public weak var delegate: DataSourceControllerDelegate?

    internal var sections: [Section]

    public init(sections: [Section], delegate: DataSourceControllerDelegate? = nil) {
        self.sections = sections
        self.delegate = delegate
    }

    public convenience init(section: Section, delegate: DataSourceControllerDelegate? = nil) {
        self.init(sections: [section], delegate: delegate)
    }

    public convenience init(rows: [Any], delegate: DataSourceControllerDelegate? = nil) {
        self.init(sections: [Section(rows: rows)], delegate: delegate)
    }

    func data(for section: Int) -> SectionDataModelType? {
        guard (0..<sectionCount).contains(section) else { return nil }
        return sections[section].sectionData
    }

    var sectionCount: Int {
        return sections.count
    }

    func rowCount(for section: Int) -> Int {
        guard (0..<sectionCount).contains(section) else { return 0 }
        return sections[section].rows.count
    }

    public var totalRowCount: Int {
        return sections.flatMap { $0.rows }.count
    }

    func model(at indexPath: IndexPath) -> Any? {
        guard (0..<sectionCount).contains(indexPath.section),
            (0..<sections[indexPath.section].rows.count).contains(indexPath.row) else {
                return nil
        }
        return sections[indexPath.section].rows[indexPath.row]
    }
}
