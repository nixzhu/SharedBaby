import Foundation
import Vapor
import HTTP
import BabyBrain

final class IndexController {

    func addRoutes(drop: Droplet) {
        drop.get("/", handler: index)
    }

    func index(request: Request) throws -> ResponseRepresentable {
        func string(forKey key: String) -> String? {
            if let string = request.query?[key]?.string {
                return string.isEmpty ? nil : string
            } else {
                return nil
            }
        }
        let jsonString = string(forKey: "json_string") ?? ""
        let modelName = string(forKey: "model_name") ?? "Model"
        let ouputModel: String
        if let (value, _) = parse(jsonString) {
            let upgradedValue = value.upgraded(newName: modelName)
            ouputModel = upgradedValue.swiftStructCode()
        } else {
            ouputModel = "Invalid JSON!"
        }
        return try drop.view.make("index", [
            "jsonString": jsonString,
            "modelName": modelName,
            "model": ouputModel,
            "hidden": ouputModel.isEmpty ? "hidden" : "xxx",
            "date": "\(Date())"
            ]
        )
    }
}
