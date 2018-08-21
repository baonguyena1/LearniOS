//: Playground - noun: a place where people can play

import UIKit

//func async(completion:@escaping ((_ success: Bool) -> Void)) {
//    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
//        let result = arc4random_uniform(2) == 0
//        print(result)
//        completion(result)
//    }
//}
//
//async { (success) in
//    print(success)
//}

//func async2() -> Bool {
//    let semaphone = DispatchSemaphore(value: 1)
//    var result = false
//    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
//        result = arc4random_uniform(2) == 0
//        semaphone.signal()
//    }
//    semaphone.wait(timeout: .distantFuture)
//    return result
//}
//
//let result = async2()
//print(result)

//let string = "Table 01 A 02.2"
//let results = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
////Int(results.last!)
//let arr = ["1", "10", "01", "0001", "1.1", "2-2", "2"]
//arr.sorted(by: <)

/**
 lấy substring đến số cuối cùng
 nếu trùng tên, hoac ten chứa nhau -> so sánh số
 nếu số bằng thì chuyển số qua string rồi so sánh (cho case 1 vs 01, 001)
 không trùng tên so sánh string
 **/
//let inputs = ["In-Queue", "Table A1", "Table A01", "Table A2", "Table A10", "Table A1-1", "Table A11 A02", "Table A1.1"]
//
//let results = inputs.sorted {
//
//    let firstStringNumber = $0.components(separatedBy: CharacterSet.decimalDigits.inverted).last!
//    let secondStringNumber = $1.components(separatedBy: CharacterSet.decimalDigits.inverted).last!
//
//    let firstIndexEnd = $0.index($0.endIndex, offsetBy: -firstStringNumber.count)
//    let firstStringWithOutLatestNumber = String($0[..<firstIndexEnd])
//    let secondIndexEnd = $1.index($1.endIndex, offsetBy: -secondStringNumber.count)
//    let secondStringWithoutLatestNumber = String($1[..<secondIndexEnd])
//
//    let compareResult = firstStringWithOutLatestNumber.compare(secondStringWithoutLatestNumber)
//    let containString = firstStringWithOutLatestNumber.contains(secondStringWithoutLatestNumber) || secondStringWithoutLatestNumber.contains(firstStringWithOutLatestNumber)
//
//    if compareResult == .orderedSame || containString {
//
//        let firstNumber = Int(firstStringNumber)!
//        let secondNumber = Int(secondStringNumber)!
//        if firstNumber == secondNumber {
//            return firstStringNumber.compare(secondStringNumber) == .orderedAscending
//        }
//        return firstNumber < secondNumber
//    }
//    return compareResult == .orderedAscending
//}
//
//print(results)
//
//let a = "aaa"
//let b = "aaabbb"
//a.contains(b)
//b.contains(a)

let semaphone = DispatchSemaphore(value: 1)
for i in 0...10 {
    semaphone.wait()
    let second = Int(arc4random_uniform(3))
    print("START", i)
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(second)) {
        print("END", i)
        semaphone.signal()
    }
}
print("----------")
