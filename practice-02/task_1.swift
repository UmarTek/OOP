import Foundation

// 1. Реализация структуры
struct Vector2D: Equatable {
    var x: Double
    var y: Double

    // Вычисляемое свойство длины вектора
    var length: Double {
        return sqrt(x * x + y * y)
    }

    // Изменяет текущий вектор (mutating)
    @discardableResult
    mutating func scale(by factor: Double) -> Bool {
        guard factor > 0 else { return false }
        x *= factor
        y *= factor
        return true
    }

    // Возвращает копию вектора без изменения оригинала
    func scaled(by factor: Double) -> Vector2D? {
        guard factor > 0 else { return nil }
        return Vector2D(x: x * factor, y: y * factor)
    }
}

// 2. Проверка работы и демонстрация значимого типа (Value Type)
var original = Vector2D(x: 3, y: 4)
var copy = original
copy.scale(by: 2)

// Проверки (если условие ложно, программа вызовет ошибку)
assert(original == Vector2D(x: 3, y: 4), "Оригинал изменился, хотя не должен был!")
assert(copy == Vector2D(x: 6, y: 8), "Копия не смасштабировалась!")
assert(original.length == 5, "Длина вектора рассчитана неверно!")

print("Все проверки успешно пройдены! Изменение копии никак не повлияло на оригинал.")
