import Foundation
import UIKit
import RealmSwift

class CountriesProvider {
    private var realm = try? Realm()
    private let imageLoader: ImageLoadable
    
    init(imageLoader: ImageLoadable) {
        self.imageLoader = imageLoader
        
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        realm = try? Realm(configuration: config)
    }
    
    func getImage(by country: Country, completion: @escaping (UIImage, String) -> ()) {
        guard let countryImageURL = URL(string: country.countryInfo.flag),
              let countryImageData = try? Data(contentsOf: countryImageURL) else { return }
    }
    
    private func getImageFromRealm(from key: String) -> CountryRealm? {
        guard let countries = realm?.object(ofType: CountryRealm.self, forPrimaryKey: key) else { return nil }
        return countries
    }
    
    private func saveCountry(by country: CountryRealm) {
        try? realm?.write {
            realm?.add(country, update: .modified)
        }
    }
}
