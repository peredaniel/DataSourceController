//  Copyright © 2019 Pedro Daniel Prieto Martínez. All rights reserved.

struct AppleStoreProducts: Decodable {
    let phones: [Product]
    let pads: [Product]
    let tvs: [Product]
    let watches: [Product]
}
