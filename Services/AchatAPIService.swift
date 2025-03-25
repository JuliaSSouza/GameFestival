import Foundation

class AchatAPIService {
    static let shared = AchatAPIService()
    private let baseURL = "https://awi-server.onrender.com"

    func fetchGamesForSale(completion: @escaping (Result<[GameItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/stocks/jeuxenvente") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0)))
                return
            }

            do {
                let decodedGames = try JSONDecoder().decode([GameItem].self, from: data)
                completion(.success(decodedGames))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/stocks/vendeurs") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0)))
                return
            }

            do {
                let decodedSellers = try JSONDecoder().decode([Seller].self, from: data)
                completion(.success(decodedSellers))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func finalizePurchase(purchaseData: [[String: Any]], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/achats/achat") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestData: [String: Any] = [
            "selectedGames": purchaseData
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            print("Erreur JSON: \(error)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Erreur: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                print("Erreur lors de la finalisation de l'achat.")
                completion(false)
                return
            }

            completion(true)
        }.resume()
    }
}
