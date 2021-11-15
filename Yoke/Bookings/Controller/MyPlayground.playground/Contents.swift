import UIKit


func miniMaxSum(arr: [Int]) -> Void {
    let max = arr.sorted()
    let min = max.reversed()
    print(max, min)

}

guard let arrTemp = readLine()?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression) else { fatalError("Bad input") }

let arr: [Int] = arrTemp.split(separator: " ").map {
    if let arrItem = Int($0) {
        return arrItem
    } else { fatalError("Bad input") }
}

guard arr.count == 5 else { fatalError("Bad input") }

miniMaxSum(arr: arr)
