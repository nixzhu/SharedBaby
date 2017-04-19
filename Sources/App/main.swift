import Vapor
import BabyBrain

let drop = Droplet()

drop.get { req in
    let jsonString = "{}"
    if let (value, _) = parse(jsonString) {
        let upgradedValue = value.upgraded(newName: "Model")
        print(upgradedValue.swiftStructCode())
    } else {
        print("Invalid JSON!")
    }
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.resource("posts", PostController())

drop.run()
