import Foundation

enum DetailedViewControllerCellTypes: Int, CaseIterable {
    case capital
    case population
    case continent
    case description
    
    static func getRow(index: Int) -> DetailedViewControllerCellTypes {
        return allCases[index]
    }
    
    static func getRowsAmount() -> Int {
        return allCases.count
    }
    
    var title: String {
        switch self {
        case .capital:
            return "Capital"
        case .population:
            return "Population"
        case .continent:
            return "Continent"
        case .description:
            return ""
        }
    }
}
