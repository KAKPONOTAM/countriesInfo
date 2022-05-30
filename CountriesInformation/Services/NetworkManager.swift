import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func getCountriesData(page: Int, completion: @escaping (CountriesData) -> ()) {
        let urlString = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page\(page).json"
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if error == nil,
               let data = data {
                do {
                    let countriesData = try JSONDecoder().decode(CountriesData.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(countriesData)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        dataTask.resume()
    }
}
