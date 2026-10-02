final class Rectangle {
    // Внешний код может читать стороны (internal/public чтение), 
    // но менять их напрямую нельзя (private запись)
    private(set) var width: Double
    private(set) var height: Double

    // Вычисляемое свойство для площади
    var area: Double {
        return width * height
    }

    // Вычисляемое свойство для периметра
    var perimeter: Double {
        return 2 * (width + height)
    }

    // Вычисляемое свойство для проверки, является ли прямоугольник квадратом
    var isSquare: Bool {
        return width == height
    }

    // Проваливаемый инициализатор (failable initializer)
    init?(width: Double, height: Double) {
        // Стороны должны быть строго больше нуля
        guard width > 0, height > 0 else {
            return nil
        }
        self.width = width
        self.height = height
    }

    // Метод масштабирования сторон прямоугольника
    func scale(by factor: Double) -> Bool {
        // Коэффициент должен быть больше нуля
        guard factor > 0 else {
            return false
        }
        self.width *= factor
        self.height *= factor
        return true
    }
}

// --- Минимальные проверки ---
let rectangle = Rectangle(width: 3, height: 4)
assert(rectangle?.area == 12)
assert(rectangle?.perimeter == 14)
assert(rectangle?.isSquare == false)
assert(Rectangle(width: 0, height: 4) == nil)

assert(rectangle?.scale(by: 2) == true)
assert(rectangle?.area == 48)
assert(rectangle?.scale(by: -1) == false)

print("Все проверки успешно пройдены!")
