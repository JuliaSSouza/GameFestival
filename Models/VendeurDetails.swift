import Foundation

struct VendeurDetails: Codable {
    let id: Int
    let nom: String

    enum CodingKeys: String, CodingKey {
        case id = "VendeurID"
        case nom = "Nom"
    }
}
