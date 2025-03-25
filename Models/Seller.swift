import Foundation

struct Seller: Identifiable, Codable {
    let id: Int
    var name: String

    enum CodingKeys: String, CodingKey {
        case id = "VendeurID"
        case name = "Nom"
    }
}
