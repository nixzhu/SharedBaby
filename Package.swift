import PackageDescription

let package = Package(
    name: "SharedBaby",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
        .Package(url: "https://github.com/nixzhu/Baby.git", majorVersion: 0, minor: 22)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

