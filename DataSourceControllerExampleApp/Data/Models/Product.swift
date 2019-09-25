//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

enum ProductType: String {
    case iPhone, iPad, AppleTV, AppleWatch, unknown
}

struct Variant: Decodable, Equatable {
    let name: String
    let options: [String]
}

struct Product: Decodable {
    let name: String
    let imageName: String
    let price: String
    let overview: String
    let type: ProductType
    let variants: [Variant]

    private enum CodingKeys: String, CodingKey {
        case name, imageName, price, overview, type, variants
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        imageName = try container.decode(String.self, forKey: .imageName)
        price = try container.decode(String.self, forKey: .price)
        overview = try container.decode(String.self, forKey: .overview)
        type = ProductType(rawValue: try container.decode(String.self, forKey: .type)) ?? .unknown
        variants = try container.decode([Variant].self, forKey: .variants)
    }
}
