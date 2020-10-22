import UIKit

//Challenge1
extension String {
    //some extension
    
    func withPrefix(_ prefixStr : String) -> String {
        
        return prefixStr + self
        
    }
}
print("Challenge1:")
print ("pet".withPrefix("car"))

//Challenge 2
extension String {
    
    var isNumeric : Bool {
        return (Double(self) != nil)
    }
    
}
print("Challenge2:")
print( "testString".isNumeric)
print( "5".isNumeric)

//Challenge3
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}
print("Challenge3:")
print("this\nis\na\ntest".lines)
