//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import Foundation
import UIKit

enum DataProvider {
    private enum Constant {
        static let assetName = "ProductsData"
    }

    static func loadDataModels() -> AppleStoreProducts {
        guard let data = NSDataAsset(name: Constant.assetName)?.data,
              let dataModels = try? JSONDecoder().decode(AppleStoreProducts.self, from: data)
        else {
            return .fallback
        }
        return dataModels
    }
}

private extension AppleStoreProducts {
    static var fallback: AppleStoreProducts {
        AppleStoreProducts(phones: [], pads: [], tvs: [], watches: [])
    }
}
