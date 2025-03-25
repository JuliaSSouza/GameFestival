import Foundation

struct Vendeur: Identifiable, Codable {
    let id: Int
    var name: String
    var email: String
    var phone: String
    
    enum CodingKeys: String, CodingKey {
        case id = "VendeurID"
        case name = "Nom"
        case email = "Email"
        case phone = "Telephone"
    }
}
