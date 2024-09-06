// Sources/App/routes.swift
import Vapor

func routes(_ app: Application) throws {
    let blogController = BlogController()
    app.middleware.use(CORSMiddleware())
    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    
    app.get("blogs", use: blogController.getAll)
    app.post("blogs", use: blogController.create)
    app.get("blogs", ":blogID", use: blogController.get)
    app.put("blogs", ":blogID", use: blogController.update)
    app.delete("blogs", ":blogID", use: blogController.delete)
}


// Add your routes here