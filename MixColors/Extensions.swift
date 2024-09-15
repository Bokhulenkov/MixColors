import UIKit

// MARK: - Задаем свой идентификатор
extension UIView {
    var id: String? {
        get {
            return accessibilityIdentifier
        }
        set {
            self.accessibilityIdentifier = newValue
        }
    }
    
//    метод для поиска uiview с заданным идентификатором
    func view(withId id: String) -> UIView? {
        if self.id == id {
            return self
        }
        for view in self.subviews {
            if let view = view.view(withId: id) {
                return view
            }
        }
        return nil
    }
}
