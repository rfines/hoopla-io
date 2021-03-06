db.postalCode.ensureIndex( { geo : "2dsphere" } )
db.business.ensureIndex( { 'location.geo' : "2dsphere" } )
db.event.ensureIndex( { 'location.geo' : "2dsphere" } )
db.postalCode.ensureIndex( {"code" : 1})
db["event"].ensureIndex({"business": 1}, {"background": true})
db.user.ensureIndex( { "email": 1 }, { unique: true } )
db["event"].ensureIndex({"promotionRequests": 1}, {"background": true})
db["business"].ensureIndex({"legacyId": 1}, {"background": true})
db["user"].ensureIndex({"applications.apiSecret": 1, "applications.apiKey": 1}, {"background": true})
db["media"].ensureIndex({"user": 1}, {"background": true});
db["user"].ensureIndex({"authTokens.authToken": 1, "authTokens.apiKey": 1}, {"background": true});