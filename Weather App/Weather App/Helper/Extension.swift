
import Foundation
import UIKit

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

extension TimeInterval {
    
    func timeFromTimeInterval(dateFormat: String,timeZone:Int = 0) -> String {
        let dateText = Date(timeIntervalSince1970: self)
        let formater = DateFormatter()
        formater.timeZone = TimeZone(secondsFromGMT: timeZone)
        formater.dateFormat = dateFormat
        return formater.string(from: dateText)
    }
}

extension UIViewController {
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
