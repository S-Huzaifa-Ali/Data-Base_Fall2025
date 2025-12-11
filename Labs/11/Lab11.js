// 1.
use inventoryDB

// 2.
db.furniture.insertMany([
    { name: "Table",  color: "Brown", dimensions: [80, 120] },
    { name: "Chair",  color: "Brown", dimensions: [40, 45] },
    { name: "Sofa",   color: "Gray",  dimensions: [200, 90] }
])

// 3.
db.furniture.insertOne({
    name: "Desk",
    color: "Brown",
    dimensions: [50, 100]
})

// 4.
db.furniture.find({ "dimensions.0": { $gt: 30 } })

// 5.
db.furniture.find({
    color: "Brown",
    name: { $in: ["Table", "Chair"] }
})

// 6.
db.furniture.updateOne(
    { name: "Table" },
    { $set: { color: "Ivory" } }
)

// 7.
db.furniture.updateMany(
    { color: "Brown" },
    { $set: { color: "Dark Brown" } }
)

// 8.
db.furniture.deleteOne({ name: "Chair" })

// 9.
db.furniture.deleteMany({ dimensions: [12, 18] })

// 10.
db.furniture.aggregate([
    { $group: { _id: "$color", count: { $sum: 1 } } }
])

// 11.
db.furniture.createIndex({ name: "text" })

// 12.
db.furniture.find({ $text: { $search: "table" } })
