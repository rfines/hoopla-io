db.postalCode.ensureIndex( { geo : "2dsphere" } )
db.business.ensureIndex( { 'location.geo' : "2dsphere" } )
db.event.ensureIndex( { 'location.geo' : "2dsphere" } )
db.postalCode.ensureIndex( {"code" : 1})