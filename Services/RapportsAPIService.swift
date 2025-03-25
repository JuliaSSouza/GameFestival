import Foundation

class RapportsAPIService {
    static let shared = RapportsAPIService()
    private let baseURL = "https://awi-server.onrender.com"
    
    func fetchBilan(vendeurID: Int, sessionID: Int, completion: @escaping (Result<BilanVendeurSession, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sessions/bilan/\(vendeurID)/\(sessionID)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([String: BilanVendeurSession].self, from: data)
                    if let bilan = response["BilanVendeurSession"] {
                        completion(.success(bilan))
                    } else {
                        completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Aucun Bilan trouvé."])))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
