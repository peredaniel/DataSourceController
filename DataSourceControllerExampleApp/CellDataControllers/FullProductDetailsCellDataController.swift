//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import DataSourceController

struct DisplayableVariant: Equatable {
    let name: String
    let options: String

    init(model: Variant) {
        name = model.name
        options = model.options.joined(separator: ", ")
    }
}

struct FullProductDetailsCellDataController: CellDataController {
    let reuseIdentifier = "FullProductDetailsCell"
    let productName: String
    let imageName: String
    let productPrice: String?
    let productOverview: String
    let productVariants: [DisplayableVariant]

    static func populate(with model: Any) -> CellDataController {
        guard let model = model as? Product else {
            return BasicCellDataController(titleText: "Incorrect model type", image: nil)
        }
        let displayableVariants = model.variants.map { DisplayableVariant(model: $0) }
        return FullProductDetailsCellDataController(
            productName: model.name,
            imageName: model.imageName,
            productPrice: model.price,
            productOverview: model.overview,
            productVariants: displayableVariants
        )
    }
}
