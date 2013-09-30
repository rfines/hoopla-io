var hooplaAdmin = {
  'email' : "hooplaAdmin@localruckus.com",
  'name' : 'Hoopla Admin',
  'password' : '$2a$12$jQIybFJWh2ELQpPbHmwoO.aJh5MlhovcwF97aUsmbWdQIpBZaQP8C', //Bcrypted version of h00plaAdmin**
  'encryptionMethod' : 'BCRYPT',
  'applications' : [ 
    { 'name' : 'hoopla-io-web', 'apiKey' : 'METkwI15Bg0heuRNaru6', 'apiSecret' : '6n0pRhok4WR8yx8VudUD7XshboNCz51oFXJvZA2y'},
    { 'name' : 'localruckus', 'apiKey' : 'XVoZHNOJ2kFdrApkq4wM', 'apiSecret' : 'dXzDtPBav3WGiXzBGhszOrMdEpLSVZChp7cdN2l7'}
  ]
}
db.user.save(hooplaAdmin);


var visitKC = {
  "_id" : ObjectId("524997f03df814cfaf00002b"),
  "accentColor" : "06A1AF",
  "businesses" : [ ],
  "height" : 545,
  "location" : {
    "address" : "Kansas City, MO 64105, USA",
    "geo" : {
      "coordinates" : [
        -94.5895294,
        39.1045785
      ],
      "type" : "Point"
    }
  },
  "name" : "VisitKC Widget",
  "radius" : 16093,
  "tags" : [ ],
  "user" : hooplaAdmin._id,
  "widgetStyle" : "dark",
  "widgetType" : "event-by-location",
  "width" : 220
}
db.widget.save(visitKC);