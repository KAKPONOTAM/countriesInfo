import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func getCountriesData(by urlStrings: URLStrings, completion: @escaping (CountriesData) -> ()) {
        let urlString = urlStrings.stringURL
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
