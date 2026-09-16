final class Rectangle {
    private(set) var width: Double
    private(set) var height: Double
    
    var area: Double { return width * height }
    var perimeter: Double { return 2 * (width + height) }
    var isSquare: Bool { return width == height }
    
    init?(width: Double, height: Double) {
        if width > 0 && height > 0 {
            self.width = width
            self.height = height
        } else {
            return nil
        }
    }
    
    func scale(by factor: Double) -> Bool {
        if factor > 0 {
            self.width *= factor
            self.height *= factor
            return true
        } else {
            return false
        }
    }
}

// --- КРАТКИЙ ПРИМЕР РАБОТЫ ---

if let rect = Rectangle(width: 3, height: 4) {
    print("Создан прямоугольник: \(rect.width)x\(rect.height)")
    print("Площадь: \(rect.area), Периметр: \(rect.perimeter), Квадрат? \(rect.isSquare)")
    
    rect.scale(by: 2)
    print("\nУвеличили в 2 раза:")
    print("Новые размеры: \(rect.width)x\(rect.height), Новая площадь: \(rect.area)")
}
