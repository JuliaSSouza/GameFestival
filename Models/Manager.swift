import Foundation

struct Manager: Codable {
    var id: Int
    var Nom: String
    var Prenom: String
    var Email: String
    
    enum CodingKeys: String, CodingKey {
        case id = "UtilisateurID"
        case Nom, Prenom, Email
    }
}
