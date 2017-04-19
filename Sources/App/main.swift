import Vapor

let drop = Droplet()

let index = IndexController()
index.addRoutes(drop: drop)

drop.run()
