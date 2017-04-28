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
        let jsonString = string(forKey: "json_string") ?? "{\n  \"name\": \"NIX\",\n  \"age\": 18, \n  \"detail\": {\n    \"is_dog_lover\": true,\n    \"skills\": [\n      {\n      \"language\": \"Swift\",\n      \"platform\": \"iOS\"\n      },\n      {\n      \"language\": \"C\",\n      \"platform\": null\n      }\n    ]\n  }\n}"
        let modelName = string(forKey: "model_name") ?? "Model"
        let isPublic = string(forKey: "isPublic") == "on"
        let modelType = string(forKey: "modelType") ?? "struct"
        let declareVariableProperties = string(forKey: "isVariable") == "on"
        let jsonDictionaryName = string(forKey: "json_dictionary_name") ?? "[String: Any]"
        let ouputModel: String
        if let (value, _) = parse(jsonString) {
            let upgradedValue = value.upgraded(newName: modelName)
            let indentation = Indentation(level: 0, unit: "    ")
            let meta = Meta(
                isPublic: isPublic,
                modelType: modelType,
                declareVariableProperties: declareVariableProperties,
                jsonDictionaryName: jsonDictionaryName
            )
            ouputModel = upgradedValue.swiftStructCode(indentation: indentation, meta: meta)
        } else {
            ouputModel = jsonString.isEmpty ? "" : "Invalid JSON!"
        }
        return try drop.view.make("index", [
            "jsonString": jsonString,
            "modelName": modelName,
            "jsonDictionaryName": jsonDictionaryName,
            "isPublic": isPublic ? "checked" : "",
            "modelType": modelType,
            "isStructSelected": modelType == "struct" ? "selected" : "",
            "isClassSelected": modelType == "class" ? "selected" : "",
            "isVariable": declareVariableProperties ? "checked" : "",
            "model": ouputModel,
            "hidden": ouputModel.isEmpty ? "hidden" : "",
            "date": "\(Date())"
            ]
        )
    }
}
