//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

import Foundation
import UIKit

enum DataProvider {
    private enum Constant {
        static let assetName = "ProductsData"
    }

    static func loadDataModels() -> AppleStoreProducts {
        guard let data = NSDataAsset(name: Constant.assetName)?.data,
            let dataModels = try? JSONDecoder().decode(AppleStoreProducts.self, from: data) else {
            return AppleStoreProducts.fallback
        }
        return dataModels
    }
}

private extension AppleStoreProducts {
    static var fallback: AppleStoreProducts {
        return AppleStoreProducts(phones: [], pads: [], tvs: [], watches: [])
    }
}
