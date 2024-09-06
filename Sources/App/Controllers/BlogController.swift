// Sources/App/Controllers/PostController.swift
import Vapor

struct BlogController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let blogs = routes.grouped("blogs")
        blogs.get(use: getAll)
        blogs.post(use: create)
        blogs.get(":blogID", use: get)
        blogs.put(":blogID", use: update)
        blogs.delete(":blogID", use: delete)
    }

    func getAll(req: Request) throws -> EventLoopFuture<[Blog]> {
        return Blog.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Blog> {
        let blog = try req.content.decode(Blog.self)
        return blog.save(on: req.db).map { blog }
    }

    func get(req: Request) throws -> EventLoopFuture<Blog> {
        Blog.find(req.parameters.get("blogID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func update(req: Request) throws -> EventLoopFuture<Blog> {
        let updatedBlog = try req.content.decode(Blog.self)
        return Blog.find(req.parameters.get("blogID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { blog in
                blog.title = updatedBlog.title
                blog.content = updatedBlog.content
                return blog.save(on: req.db).map { blog }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Blog.find(req.parameters.get("blogID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { post in
                post.delete(on: req.db)
            }
            .transform(to: .noContent)
    }
}
