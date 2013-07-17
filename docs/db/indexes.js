db.postalcodes.ensureIndex( { geo : "2dsphere" } )
db.businesses.ensureIndex( { geo : "2dsphere" } )