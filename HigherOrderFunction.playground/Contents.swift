import Foundation

let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let sum = array.wwForEach { print($0) }
               .wwFilter { $0 % 2 == 0 }
               .wwMap { $0 * 2 }
               .wwReduce(0, +)

print("sum = \(sum)")

/// 簡單版的自定義高階函數 (Functional Programming) - Array[Element]
extension Array {
    
    /// 仿ForEach()
    func wwForEach(_ forEach: (Element) -> Void) -> [Element] {
        for item in self { forEach(item) }
        return self
    }
    
    /// 仿Filter()
    func wwFilter(_ filter: (Element) -> Bool) -> [Element] {
        var array = [Element]()
        for item in self { if filter(item) { array.append(item) } }
        return array
    }
    
    /// 仿Map()
    func wwMap(_ map: (Element) -> Element) -> [Element] {
        var array = [Element]()
        for item in self { array.append(map(item)) }
        return array
    }
    
    /// 仿Reduce()
    func wwReduce(_ initialValue: Element, _ reduce: (Element, Element) -> Element) -> Element {
        var sum = initialValue
        for (_, item) in self.enumerated() { sum = reduce(sum, item) }
        return sum
    }
}


