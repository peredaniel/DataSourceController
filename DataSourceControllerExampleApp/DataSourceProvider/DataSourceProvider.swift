//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import DataSourceController

enum ListType {
    case basic, details, fullDetails

    var title: String {
        switch self {
        case .basic: return "Basic list product names and images"
        case .details: return "List with product names, images and prices"
        case .fullDetails: return "List with full product details"
        }
    }
}

class DataSourceProvider {
    private let dataModels = DataProvider.loadDataModels()

    func dataSourceController(for listType: ListType) -> DataSourceController {
        let controller = DataSourceController(sections: rowEntries)
        controller.register(
            dataController: BasicCellDataController.self,
            for: String.self
        )
        controller.register(
            dataController: CollectionHeaderDataController.self,
            for: SectionDataModel.self
        )
        switch listType {
        case .basic:
            controller.register(
                dataController: BasicCellDataController.self,
                for: Product.self
            )
        case .details:
            controller.register(
                dataController: DetailCellDataController.self,
                for: Product.self
            )
        case .fullDetails:
            controller.register(
                dataController: FullProductDetailsCellDataController.self,
                for: Product.self
            )
        }
        return controller
    }
}

extension DataSourceProvider {
    var rowEntries: [Section] {
        let phonesSection = Section(
            sectionData: SectionDataModel(header: "iPhones"),
            rows: dataModels.phones
        )
        let padsSection = Section(
            sectionData: SectionDataModel(header: "iPads"),
            rows: dataModels.pads
        )
        let tvsSection = Section(
            sectionData: SectionDataModel(header: "Apple TVs"),
            rows: dataModels.tvs
        )
        let watchesSection = Section(
            sectionData: SectionDataModel(header: "Apple Watches"),
            rows: dataModels.watches
        )
        return [phonesSection, padsSection, tvsSection, watchesSection]
    }
}
