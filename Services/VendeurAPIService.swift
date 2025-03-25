import Foundation

class VendeurAPIService {
    static let shared = VendeurAPIService()
    private let baseURL = "https://awi-server.onrender.com"
    
    // Fetch All Vendeurs
    func fetchVendeurs(completion: @escaping (Result<[Vendeur], Error>) -> Void) {
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
                let decodedVendeurs = try JSONDecoder().decode([Vendeur].self, from: data)
                completion(.success(decodedVendeurs))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Add Vendeur
    func addVendeur(vendeurRequest: [String: Any], completion: @escaping (Result<Vendeur, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/vendeurs") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: vendeurRequest)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let addedVendeur = try JSONDecoder().decode(Vendeur.self, from: data)
                completion(.success(addedVendeur))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Update Vendeur
    func updateVendeur(vendeur: Vendeur, completion: @escaping (Result<Vendeur, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/vendeurs/\(vendeur.id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(vendeur)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let updatedVendeur = try JSONDecoder().decode(Vendeur.self, from: data)
                completion(.success(updatedVendeur))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
