//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

struct AppleStoreProducts: Decodable {
    let phones: [Product]
    let pads: [Product]
    let tvs: [Product]
    let watches: [Product]
}
