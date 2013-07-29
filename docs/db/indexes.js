db.postalCode.ensureIndex( { geo : "2dsphere" } )
db.business.ensureIndex( { geo : "2dsphere" } )
db.event.ensureIndex( { geo : "2dsphere" } )
db.postalCode.ensureIndex( {"code" : 1})