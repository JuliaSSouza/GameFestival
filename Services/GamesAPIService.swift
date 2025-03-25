import Foundation

class GamesAPIService {
    static let shared = GamesAPIService()
    private let baseURL = "https://awi-server.onrender.com"

    func fetchGames(completion: @escaping (Result<[GameItems], Error>) -> Void) {
        let gamesURL = URL(string: "\(baseURL)/stocks/jeux")!
        let vendorsURL = URL(string: "\(baseURL)/vendeurs")!
        let marquesURL = URL(string: "\(baseURL)/stocks/marques")!

        let group = DispatchGroup()
        
        var fetchedGames: [[String: Any]] = []
        var fetchedVendors: [Int: String] = [:]
        var fetchedGameNames: [Int: String] = [:]
        
        var fetchError: Error?

        group.enter()
        URLSession.shared.dataTask(with: gamesURL) { data, _, error in
            defer { group.leave() }
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                fetchedGames = json
            } else if let error = error {
                fetchError = error
            }
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: vendorsURL) { data, _, error in
            defer { group.leave() }
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                for vendor in json {
                    if let id = vendor["VendeurID"] as? Int, let name = vendor["Nom"] as? String {
                        fetchedVendors[id] = name
                    }
                }
            } else if let error = error {
                fetchError = error
            }
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: marquesURL) { data, _, error in
            defer { group.leave() }
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                for game in json {
                    if let id = game["JeuRef_id"] as? Int, let name = game["Nom"] as? String {
                        fetchedGameNames[id] = name
                    }
                }
            } else if let error = error {
                fetchError = error
            }
        }.resume()

        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
                return
            }
            
            let games = fetchedGames.compactMap { game -> GameItems? in
                guard let id = game["JeuID"] as? Int,
                      let refID = game["JeuRef_id"] as? Int,
                      let depotID = game["depot_ID"] as? Int,
                      let price = game["prix_unitaire"] as? Double,
                      let availableQuantity = game["quantite_disponible"] as? Int,
                      let saleStatus = game["mise_en_vente"] as? Bool else { return nil }

                let gameName = fetchedGameNames[refID] ?? "Inconnu"
                let sellerName = fetchedVendors[depotID] ?? "Inconnu"

                return GameItems(
                    id: id,
                    name: gameName,
                    price: "\(price) €",
                    seller: sellerName,
                    mis_en_vente: saleStatus,
                    quantite: availableQuantity
                )
            }

            completion(.success(games))
        }
    }

    func toggleSaleStatus(for gameID: Int, isSelling: Bool) {
        let endpoint = isSelling ? "mettre-en-vente" : "remettre"
        guard let url = URL(string: "\(baseURL)/stocks/jeux/\(gameID)/\(endpoint)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        URLSession.shared.dataTask(with: request).resume()
    }
}
