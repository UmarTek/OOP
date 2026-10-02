final class Temperature {
    // Хранение в градусах Цельсия. Изменение снаружи напрямую запрещено.
    private(set) var celsius: Double
    
    // Константа для абсолютного нуля
    private static let absoluteZeroCelsius: Double = -273.15

    // Вычисляемое свойство с get и set
    var fahrenheit: Double {
        get {
            // Формула перевода: (C * 9 / 5) + 32
            return (celsius * 9 / 5) + 32
        }
        set {
            // Переводим newValue (Фаренгейты) в Цельсии по формуле из условия
            let calculatedCelsius = (newValue - 32) * 5 / 9
            
            // Проверяем на соответствие абсолютному нулю с помощью уже написанного метода
            // Если значение некорректно, метод setCelsius вернет false и сохранит прежнее состояние
            _ = setCelsius(calculatedCelsius)
        }
    }

    // Проваливаемый инициализатор
    init?(celsius: Double) {
        // Проверка нижней границы температуры
        guard celsius >= Temperature.absoluteZeroCelsius else {
            return nil
        }
        self.celsius = celsius
    }

    // Единственный метод для явного изменения celsius снаружи
    @discardableResult
    func setCelsius(_ value: Double) -> Bool {
        guard value >= Temperature.absoluteZeroCelsius else {
            return false // Состояние сохраняется, возвращаем false
        }
        self.celsius = value
        return true
    }
}

// --- Минимальные проверки ---
let temperature = Temperature(celsius: 25)
assert(temperature?.fahrenheit == 77)

temperature?.fahrenheit = 32
assert(temperature?.celsius == 0)

let oldValue = temperature?.celsius
temperature?.fahrenheit = -500 // Ниже абсолютного нуля (~ -295.56°C), должно проигнорироваться
assert(temperature?.celsius == oldValue)

assert(Temperature(celsius: -300) == nil)

print("Все проверки успешно пройдены!")
