import Foundation

class StocksAPIService {
    static let shared = StocksAPIService()
    private let baseURL = "https://awi-server.onrender.com"
    
    func fetchDepots(completion: @escaping (Result<[Depot], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/stocks/depots") else { return }

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
                let decodedDepots = try JSONDecoder().decode([Depot].self, from: data)
                completion(.success(decodedDepots))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
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
}
