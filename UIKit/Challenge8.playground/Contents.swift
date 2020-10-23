import UIKit

//Challenge1
extension UIView {
    func bounceOut(duration time : Double) {
        return UIView.animate(withDuration: time) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

//Challenge2
extension Int {
    func times(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

5.times{ print("Hello!")}

//Challenge3
// extension 3: remove an item from an array
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let location = self.firstIndex(of: item) {
            self.remove(at: location)
        }
    }
}

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)
print(numbers)
