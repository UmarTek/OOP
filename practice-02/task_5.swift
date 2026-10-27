import Foundation

// Задание 5. Смешанная модель интернет-заказа
struct Money: Equatable {
    let amount: Decimal
    let currency: String

    init?(amount: Decimal, currency: String) {
        // Инвариант: сумма денег неотрицательна, код валюты непустой
        guard amount >= 0, !currency.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        self.amount = amount
        self.currency = currency
    }
}

struct Product: Equatable {
    let id: UUID
    let name: String
    let price: Money

    init?(id: UUID = UUID(), name: String, price: Money) {
        // Инвариант: имя товара непустое
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        self.id = id
        self.name = name
        self.price = price
    }
}

struct OrderItem: Equatable {
    let product: Product
    var quantity: Int

    init?(product: Product, quantity: Int) {
        // Инвариант: количество положительное
        guard quantity > 0 else { return nil }
        self.product = product
        self.quantity = quantity
    }

    var subtotal: Decimal {
        return product.price.amount * Decimal(quantity)
    }
}

final class ShoppingCart {
    let id: UUID
    private(set) var items: [OrderItem] = []

    // total всегда динамически вычисляется из текущих позиций
    var total: Decimal {
        return items.reduce(0) { $0 + $1.subtotal }
    }

    init(id: UUID = UUID()) {
        self.id = id
    }

    @discardableResult
    func add(_ product: Product, quantity: Int = 1) -> Bool {
        guard quantity > 0 else { return false }
        
        // Повторное добавление товара увеличивает количество существующей позиции
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
            return true
        } else {
            if let newItem = OrderItem(product: product, quantity: quantity) {
                items.append(newItem)
                return true
            }
            return false
        }
    }

    @discardableResult
    func remove(productID: UUID) -> Bool {
        if let index = items.firstIndex(where: { $0.product.id == productID }) {
            items.remove(at: index)
            return true
        }
        return false
    }
}

// --- Проверки (assert) ---

// Валидация инвариантов
assert(Money(amount: -10, currency: "USD") == nil)
assert(Money(amount: 100, currency: "  ") == nil)

let usd = Money(amount: 10, currency: "USD")!
assert(Product(name: "", price: usd) == nil)

let laptop = Product(name: "Laptop", price: Money(amount: 1000, currency: "USD")!)!
let mouse = Product(name: "Mouse", price: Money(amount: 50, currency: "USD")!)!

// Создаем корзину и тестируем ссылки
let cart1 = ShoppingCart()
let cartRef1 = cart1
let cartRef2 = cart1

// Доказываем, что две ссылки видят общий список
assert(cartRef1 === cartRef2)
cartRef1.add(laptop, quantity: 1)
assert(cartRef2.items.count == 1)
assert(cartRef2.total == 1000)

// Проверка инварианта: увеличение количества при повторном добавлении
cartRef2.add(laptop, quantity: 2)
assert(cartRef1.items[0].quantity == 3)
assert(cartRef1.total == 3000)

// Добавляем другой товар
cartRef1.add(mouse, quantity: 1)
assert(cartRef1.total == 3050)

// Создаем вторую корзину с такими же товарами
let cart2 = ShoppingCart()
cart2.add(laptop, quantity: 3)
cart2.add(mouse, quantity: 1)

// Покажем, что это другой экземпляр, несмотря на идентичное содержимое данных
assert(cart1 !== cart2)
assert(cart1.total == cart2.total)

print("Task 5 completed successfully.")

/*
 Объяснение выбора struct / class:
 Money, Product, OrderItem — структуры, так как они представляют собой неизменяемые данные (значения).
 ShoppingCart — класс, так как корзина должна передаваться по ссылке между экранами приложения (каталог, 
 экран корзины, экран оформления заказа), сохраняя общее динамическое состояние и мутируя его глобально.
*/
