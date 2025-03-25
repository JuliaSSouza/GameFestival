import Foundation

class DashboardAPIService {
    static let shared = DashboardAPIService()
    private let baseURL = "https://awi-server.onrender.com"

    func fetchDashboardData(completion: @escaping (Result<DashboardData, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/dashboard") else { return }

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
                let decodedData = try JSONDecoder().decode(DashboardData.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
