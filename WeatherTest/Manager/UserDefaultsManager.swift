import Foundation

final class UserDefaultsManager {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(userDefaults: UserDefaults = .standard, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func save<T>(_ value: T, forKey key: String) where T: Codable {
        do {
            let data = try encoder.encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save value for key: \(key), error: \(error.localizedDescription)")
        }
    }
    
    func load<T>(forKey key: String, as type: T.Type) -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let value = try decoder.decode(T.self, from: data)
            return value
        } catch {
            return nil
        }
    }

    func delete(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
