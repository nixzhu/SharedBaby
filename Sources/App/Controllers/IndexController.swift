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
        let isPublic = string(forKey: "isPublic") == "on"
        let jsonDictionaryName = string(forKey: "json_dictionary_name") ?? "[String: Any]"
        let ouputModel: String
        if let (value, _) = parse(jsonString) {
            let upgradedValue = value.upgraded(newName: modelName)
            let meta = Meta(isPublic: isPublic, jsonDictionaryName: jsonDictionaryName)
            ouputModel = upgradedValue.swiftStructCode(meta: meta)
        } else {
            ouputModel = jsonString.isEmpty ? "" : "Invalid JSON!"
        }
        return try drop.view.make("index", [
            "jsonString": jsonString,
            "modelName": modelName,
            "jsonDictionaryName": jsonDictionaryName,
            "isPublic": isPublic ? "checked" : "",
            "model": ouputModel,
            "hidden": ouputModel.isEmpty ? "hidden" : "",
            "date": "\(Date())"
            ]
        )
    }
}
