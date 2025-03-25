import Foundation

class AddDepositAPIService {
    static let shared = AddDepositAPIService()
    private let baseURL = "https://awi-server.onrender.com"
    
    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/vendeurs") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let sellers = try JSONDecoder().decode([Seller].self, from: data)
                completion(.success(sellers))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchAvailableGames(completion: @escaping (Result<[GameBrand], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/stocks/marques") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let games = try JSONDecoder().decode([GameBrand].self, from: data)
                completion(.success(games))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchFraisDepot(completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sessions/active") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let fraisDepot = decodedData?["pourc_frais_depot"] as? Double {
                    completion(.success(fraisDepot / 100))
                } else {
                    completion(.failure(NSError(domain: "Invalid data", code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createDepot(depotData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/stocks/depot") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: depotData)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
}
