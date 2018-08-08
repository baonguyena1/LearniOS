import UIKit

var str = "Hello, playground"

/// Make array 2D
struct Array2D<T> {
    public let columns: Int
    public let rows: Int
    fileprivate var array: [T]
    
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        self.array = Array(repeating: initialValue, count: rows * columns)
    }
    
    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row * columns + column]
        }
        
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row * columns + column] = newValue
        }
    }
    
    func prettyPrint() {
        for i in 0..<rows {
            print("[", terminator: "")
            for j in 0..<columns {
                if j == columns - 1 {
                    print("\(self[j, i])", terminator: "")
                } else {
                    print("\(self[j, i])", terminator: " ")
                }
            }
            print("]")
        }
    }
}

var matrix = Array2D(columns: 3, rows: 3, initialValue: 0)
matrix.prettyPrint()
matrix[0, 0] = 0
matrix[1, 0] = 1
matrix[2, 0] = 2

matrix[0, 1] = 3
matrix[1, 1] = 4
matrix[2, 1] = 5

matrix[0, 2] = 6
matrix[1, 2] = 7
matrix[2, 2] = 8
//matrix[0, 0] = 1
//matrix[1, 0] = 2
//
//matrix[0, 1] = 3
//matrix[1, 1] = 4
//
//matrix[0, 2] = 5
//matrix[1, 2] = 6
//
//matrix[0, 3] = 7
//matrix[1, 3] = 8
//matrix[2, 3] = 9

print(matrix.array)
matrix.prettyPrint()
