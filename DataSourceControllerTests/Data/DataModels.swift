//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController
import Foundation

struct DataModels: Decodable {
    let phones: [Product]
    let pads: [Product]
    let tvs: [Product]
    let watches: [Product]
}

extension DataModels {
    init() {
        guard let url = DataModels.url(),
              let data = try? Data(contentsOf: url),
              let dataModels = try? JSONDecoder().decode(DataModels.self, from: data)
        else {
            self = DataModels(phones: [], pads: [], tvs: [], watches: [])
            return
        }
        self = dataModels
    }

    private static func url() -> URL? {
        return Bundle(for: MockDataSourceControllerDelegate.self)
            .url(forResource: "DataModels", withExtension: "json")
    }
}

extension DataModels {
    var allCases: [[Product]] {
        return [phones, pads, tvs, watches]
    }

    var singleSectionNoSectionData: Section {
        return Section(rows: phones)
    }

    var singleSectionWithSectionData: Section {
        let sectionData = SectionDataModel(header: "Header", footer: "Footer")
        return Section(sectionData: sectionData, rows: phones)
    }

    var multipleSectionsNoSectionData: [Section] {
        return allCases.map { Section(rows: $0) }
    }

    var multipleSectionsMixingSectionData: [Section] {
        let sectionData = SectionDataModel(header: "Header", footer: "Footer")
        var sections: [Section] = []
        for index in 0..<allCases.count {
            if index % 2 == 0 {
                sections.append(Section(sectionData: sectionData, rows: allCases[index]))
            } else {
                sections.append(Section(rows: allCases[index]))
            }
        }
        return sections
    }

    var multipleSectionsWithSectionData: [Section] {
        let sectionData = SectionDataModel(header: "Header", footer: "Footer")
        return allCases.map { Section(sectionData: sectionData, rows: $0) }
    }
}
