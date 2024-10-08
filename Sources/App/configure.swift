import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "gab",
        password: Environment.get("DATABASE_PASSWORD") ?? "gab",
        database: Environment.get("DATABASE_NAME") ?? "pwapd",
        tls: .disable
        )
    ), as: .psql)

    app.migrations.add(CreatePost())



    // register routes
    try routes(app)
}
