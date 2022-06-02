import Foundation
import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    
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
    
    func loadImage(from urlString: String) -> Data {
        guard let countryImageURL = URL(string: urlString),
              let countryImageData = try? Data(contentsOf: countryImageURL) else { return Data() }
        
        return countryImageData
    }
}
