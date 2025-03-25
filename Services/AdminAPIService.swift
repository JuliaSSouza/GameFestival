import Foundation

class AdminAPIService {
    static let shared = AdminAPIService()
    private let baseURL = "https://awi-server.onrender.com"
    
    // MARK: - Fetch All Sessions
    func fetchSessions(completion: @escaping (Result<[Session], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sessions") else { return }
        
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
                let sessions = try JSONDecoder().decode([Session].self, from: data)
                completion(.success(sessions))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Fetch Active Session
    func fetchActiveSession(completion: @escaping (Result<Session, Error>) -> Void) {
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
                let session = try JSONDecoder().decode(Session.self, from: data)
                completion(.success(session))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Create a New Session
    func createSession(name: String, commission: Double, fraisDepot: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sessions") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "NomSession": name,
            "pourc_frais_depot": fraisDepot,
            "pourc_frais_vente": commission
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    // MARK: - Close Session
    func closeSession(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sessions/close") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: [:])
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    // MARK: - Fetch Managers
    func fetchManagers(completion: @escaping (Result<[Manager], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/managers") else { return }
        
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
                let managers = try JSONDecoder().decode([Manager].self, from: data)
                completion(.success(managers))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Add Manager
    func addManager(manager: Manager, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/managers") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "Nom": manager.Nom,
            "Prenom": manager.Prenom,
            "Email": manager.Email,
            "MdP": "Password"  // Assuming password is passed somewhere else
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
}
