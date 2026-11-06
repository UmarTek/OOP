//
//  task_2.swift
//  Задание 2. Обёртывание исключений на слое репозитория.
//  Запуск: swift task_2.swift
//

import Foundation

enum OrderNotFoundError: Error, CustomStringConvertible {
    case orderNotFound(orderId: String)
    var description: String {
        switch self {
        case .orderNotFound(let id): return "Заказ '\(id)' не найден"
        }
    }
}

enum RepositoryError: Error, CustomStringConvertible {
    case operationFailed(operation: String, original: Error)

    var description: String {
        switch self {
        case .operationFailed(let op, let original):
            return "Ошибка репозитория в операции '\(op)': \(original)"
        }
    }

    var underlying: Error {
        switch self {
        case .operationFailed(_, let original): return original
        }
    }
}

// Имитация низкоуровневой ошибки БД
struct DatabaseError: Error, CustomStringConvertible {
    let message: String
    var description: String { "DatabaseError: \(message)" }
}

final class OrderRepository {
    private var hasSchema = false

    func createSchema() {
        hasSchema = true
    }

    func getOrder(_ orderId: String) throws -> [String: String] {
        // Имитация sqlite3.Error, если таблицы нет
        guard hasSchema else {
            throw DatabaseError(message: "no such table: orders")
        }
        // Имитация "заказа нет"
        throw OrderNotFoundError.orderNotFound(orderId: orderId)
    }
}

final class OrderService {
    let repo: OrderRepository
    init(repo: OrderRepository) { self.repo = repo }

    func fetch(_ orderId: String) throws -> [String: String] {
        do {
            return try repo.getOrder(orderId)
        } catch let repoError as RepositoryError {
            print("  [service] не удалось получить заказ: \(repoError)")
            throw repoError
        } catch {
            // Любая другая ошибка от репозитория — оборачиваем
            let wrapped = RepositoryError.operationFailed(operation: "get_order", original: error)
            print("  [service] не удалось получить заказ: операция=get_order")
            throw wrapped
        }
    }
}

// MARK: - Demo

func task2Demo() {
    print("=== Задание 2 ===")
    let repo = OrderRepository()
    let svc = OrderService(repo: repo)

    // 2.1 — таблицы нет -> DatabaseError -> RepositoryError
    do {
        _ = try svc.fetch("ORD-1")
    } catch let RepositoryError.operationFailed(op, original) {
        print("  [2.1] операция=\(op), причина=\(type(of: original))")
    } catch {
        print("  [2.1] неожиданная ошибка: \(error)")
    }

    // 2.2 — таблица есть, заказа нет -> OrderNotFoundError
    repo.createSchema()
    do {
        _ = try svc.fetch("ORD-1")
    } catch let OrderNotFoundError.orderNotFound(id) {
        print("  [2.2] Заказ '\(id)' не найден")
    } catch {
        print("  [2.2] неожиданная ошибка: \(error)")
    }
}

task2Demo()