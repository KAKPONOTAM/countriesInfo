import Foundation

struct CountriesData: Decodable {
    let next: String
    let countries: [Country]
}

struct Country: Decodable {
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let smallDescription: String
    let countryDescription: String
    let image: String
    let countryInfo: CountryInfo
    
    enum CodingKeys: String, CodingKey {
        case name, continent, capital, population
        case smallDescription = "description_small"
        case countryDescription = "description"
        case image
        case countryInfo = "country_info"
    }
}

struct CountryInfo: Decodable {
    let images: [String]
    let flag: String
}

