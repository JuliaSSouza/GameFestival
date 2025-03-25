import Foundation

struct Session: Codable {
    var nomSession: String
    var commission: Double
    var fraisDepot: Double
    var dateDebut: String
    var statut: Bool
    
    enum CodingKeys: String, CodingKey {
        case nomSession = "NomSession"
        case commission = "pourc_frais_vente"
        case fraisDepot = "pourc_frais_depot"
        case dateDebut = "DateDebut"
        case statut = "Statut"
    }
}
