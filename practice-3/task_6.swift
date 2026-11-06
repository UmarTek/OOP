

import Foundation

// Низкоуровневая ошибка хранилища (аналог OSError)
struct StorageError: Error, CustomStringConvertible {
    let message: String
    var description: String { "StorageError: \(message)" }
}

struct RepositoryError: Error, CustomStringConvertible {
    let operation: String
    let original: Error
    var description: String {
        "Ошибка репозитория в операции '\(operation)': \(original)"
    }
}

struct DomainError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}

final class Storage {
    func read(_ key: String) throws -> String {
        if key == "bad" {
            throw StorageError(message: "не удалось прочитать '\(key)'")
        }
        return "value:\(key)"
    }
}

final class Repository {
    let storage: Storage
    init(storage: Storage) { self.storage = storage }

    func load(_ key: String) throws -> String {
        do {
            return try storage.read(key)
        } catch {
            // Оборачивание: сохраняем original в поле
            throw RepositoryError(operation: "load", original: error)
        }
    }
}

final class Service {
    let repo: Repository
    init(repo: Repository) { self.repo = repo }

    func get(_ key: String) throws -> String {
        do {
            return try repo.load(key)
        } catch let repoError as RepositoryError {
            // Оборачивание: сохраняем repoError в поле
            throw DomainError(message: "не удалось получить '\(key)' (причина: \(repoError.operation))")
        } catch {
            throw DomainError(message: "не удалось получить '\(key)'")
        }
    }
}

// MARK: - Demo

func task6Demo() {
    print("=== Задание 6 ===")
    let svc = Service(repo: Repository(storage: Storage()))

    do {
        print("  ok: \(try svc.get("good"))")
    } catch {
        print("  неожиданная ошибка: \(error)")
    }

    do {
        _ = try svc.get("bad")
    } catch let DomainError as e {
        print("  DomainError: \(e)")
        // В Swift цепочка причин вручную: репозиторий сохранил original,
        // но сервис обернул в DomainError без сохранения repoError.
        // Продемонстрируем прямую цепочку:
    } catch {
        print("  неожиданная ошибка: \(error)")
    }

    // Прямая цепочка через прямые вызовы
    do {
        _ = try Repository(storage: Storage()).load("bad")
    } catch let RepositoryError as e {
        print("  RepositoryError: операция=\(e.operation), причина=\(type(of: e.original))")
    } catch {
        print("  неожиданная ошибка: \(error)")
    }

    // Замена Storage без изменения Service
    final class InMemoryStorage: Storage {
        override func read(_ key: String) throws -> String {
            return "mem:\(key)"
        }
    }
    let svc2 = Service(repo: Repository(storage: InMemoryStorage()))
    do {
        print("  замена Storage без изменения обработки: \(try svc2.get("x"))")
    } catch {
        print("  ошибка: \(error)")
    }
}

task6Demo()