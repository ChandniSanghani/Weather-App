
import Foundation

extension Double {
    func doubleToString() -> String {
        return String(format: "%.0f", self)
    }
}

extension String {
    
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
