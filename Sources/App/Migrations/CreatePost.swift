// Sources/App/Migrations/CreatePost.swift
import Fluent

struct CreatePost: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("blogs")
            .id()
            .field("title", .string, .required)
            .field("content", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("blogs").delete()
    }
}
