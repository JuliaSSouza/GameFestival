import Foundation

struct Sessionrapport: Identifiable, Codable {
    var id: Int
    var name: String

    enum CodingKeys: String, CodingKey {
        case id = "idSession"
        case name = "NomSession"
    }
}
