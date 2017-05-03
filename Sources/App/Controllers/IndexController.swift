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
        let modelType = string(forKey: "modelType") ?? "struct"
        let declareVariableProperties = string(forKey: "isVariable") == "on"
        let jsonDictionaryName = string(forKey: "json_dictionary_name") ?? "[String: Any]"
        let propertyMapString = string(forKey: "property_map") ?? ""
        var propertyMap: [String: String] = [:]
        propertyMapString.components(separatedBy: ",").forEach {
            let parts = $0.components(separatedBy: ":")
            if parts.count == 2 {
                propertyMap[parts[0]] = parts[1]
            }
        }
        let arrayObjectMapString = string(forKey: "array_object_map") ?? ""
        var arrayObjectMap: [String: String] = [:]
        arrayObjectMapString.components(separatedBy: ",").forEach {
            let parts = $0.components(separatedBy: ":")
            if parts.count == 2 {
                arrayObjectMap[parts[0]] = parts[1]
            }
        }
        let ouputModel: String
        if let (value, _) = parse(jsonString) {
            let upgradedValue = value.upgraded(newName: modelName, arrayObjectMap: arrayObjectMap)
            let indentation = Indentation(level: 0, unit: "    ")
            let meta = Meta(
                isPublic: isPublic,
                modelType: modelType,
                declareVariableProperties: declareVariableProperties,
                jsonDictionaryName: jsonDictionaryName,
                propertyMap: propertyMap,
                arrayObjectMap: arrayObjectMap
            )
            ouputModel = upgradedValue.swiftCode(indentation: indentation, meta: meta)
        } else {
            ouputModel = jsonString.isEmpty ? "" : "Invalid JSON!"
        }
        return try drop.view.make("index", [
            "jsonString": jsonString,
            "modelName": modelName,
            "jsonDictionaryName": jsonDictionaryName,
            "propertyMap": propertyMapString,
            "arrayObjectMap": arrayObjectMapString,
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
