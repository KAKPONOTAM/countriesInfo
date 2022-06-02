import Foundation
import UIKit
import RealmSwift

class CountriesProvider {
    private var realm = try? Realm()
    
    init() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        realm = try? Realm(configuration: config)
    }
    
    func getCountriesFromRealm() -> CountriesRealmData? {
        guard let countriesRealmData = realm?.objects(CountriesRealmData.self).first else { return nil }
        return countriesRealmData
    }
    
    func saveCountry(by countries: [CountryRealm]) {
        try? realm?.write {
            countries.forEach { realm?.add($0, update: .all) }
        }
    }
    
    func saveCountryRealmData(countryRealmData: CountriesRealmData) {
        try? realm?.write {
            realm?.add(countryRealmData, update: .all)
        }
    }
}
