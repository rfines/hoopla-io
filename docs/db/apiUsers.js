var sprintApi = {
  'email' : "hemant.v.tiwari@sprint.com",
  'name' : 'Hemant Tiwari',
  'password' : '$2a$12$GBlls7hyXo4APvF9POYUy.9kzB2.YdonSMVriSOSvHVdE2K0vDLAW', //Bcrypted version of 'sprintAdmin'
  'encryptionMethod' : 'BCRYPT',
  'applications' : [ { 'name' : 'Sprint Api','legacyKey':'CjV94IobahVjMt9', 'apiKey' : 'GgTK2l1KV6ApWi5pLEtM', 'apiSecret' : 'PM0T8wV1BpboudLillneCVPppuuSAbgSaK7HykKJ'}]
}
db.user.save(sprintApi);
var crossroadsApi = {
  'email' : "info@crossroads.com",
  'name' : 'Crossroads',
  'password' : '$2a$12$0sDeE3gINOdaE1bfihcopeCFGarLjhQHugtcBrSVkMvyXxJyVM7Be', //Bcrypted version of h00plaAdmin**
  'encryptionMethod' : 'BCRYPT',
  'applications' : [ { 'name' : 'Crossroads Api','legacyKey':'SpclFmVso48IfP5', 'apiKey' : 'fKsdRDgHSm9tvkl7wALE', 'apiSecret' : 'prWmZRV2NhJUl8hMqcxgFVQZBZwdVxyBu3TIIUhJ'}]
}
db.user.save(crossroadsApi);
var foundationApi = {
  'email' : "info@foundation.com",
  'name' : 'Foundation CMS',
  'password' : "$2a$12$ha8qDAa2o3rIN593/9T6Cen4FFk6nbkCmlSZPeYunGWpnZwfjGeCK", //Bcrypted version of h00plaAdmin**
  'encryptionMethod' : 'BCRYPT',
  'applications' : [ { 'name' : 'Foundation CMS','legacyKey':'37dob3sE7T34wqa', 'apiKey' : '7oweEKySiclCJTwvSbUS', 'apiSecret' : 'Z9i1Pm3NQn4v9tE3QJUHUfxQ7wqenzSU0dUhF3Gb'}]
}
db.user.save(foundationApi);
var overkcApi = {
  'email' : "info@overkc.com",
  'name' : 'Over KC',
  'password' : "$2a$12$e91kOBPSL42mAZJEtM20aea0RAl0ysG325xPp4cA18/f.6MCeyFIO", //Bcrypted version of h00plaAdmin**
  'encryptionMethod' : 'BCRYPT',
  'applications' : [ { 'name' : 'Over KC','legacyKey':'w1QdT7jt4jPXi8m', 'apiKey' : 'O6yDIDTM1R32QuIysg26', 'apiSecret' : 'thDE0852guiWr96TUgZ5pwryd7vME85Ty2tro2Ul'}]
}
db.user.save(overkcApi);
var pittApi = {
  'email' : "info@pittsburgh.ks",
  'name' : 'Pittsburg Ks',
  'password' : "$2a$12$WgPsqg/zG8Q4PXWxRGJ4luq7qcHITsNB40DyDM0ihaDxivhzWtJV6", //Bcrypted version of h00plaAdmin**
  'encryptionMethod' : 'BCRYPT',
  'applications' : [ { 'name' : 'Pittsburg KS','legacyKey':'9CXVnIllv6RbSrK', 'apiKey' : 'iB3KkMy8CteQFyBrZiLh', 'apiSecret' : 'eys8Aky5oZZki9QzDOp2kXecgZVJB1bFAZgtkaoo'}]
}
db.user.save(pittApi);
db.user.update({'email' : "Hemant.V.Tiwari@sprint.com"}, {$set:{'applications' : [ { 'name' : 'Sprint Api','legacyKey':'CjV94IobahVjMt9', 'apiKey' : 'GgTK2l1KV6ApWi5pLEtM', 'apiSecret' : 'PM0T8wV1BpboudLillneCVPppuuSAbgSaK7HykKJ', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@crossroads.com"}, {$set:{'applications': [ { 'name' : 'Crossroads Api','legacyKey':'SpclFmVso48IfP5', 'apiKey' : 'fKsdRDgHSm9tvkl7wALE', 'apiSecret' : 'prWmZRV2NhJUl8hMqcxgFVQZBZwdVxyBu3TIIUhJ', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@foundation.com"}, {$set:{'applications':[ { 'name' : 'Over KC','legacyKey':'w1QdT7jt4jPXi8m', 'apiKey' : 'O6yDIDTM1R32QuIysg26', 'apiSecret' : 'thDE0852guiWr96TUgZ5pwryd7vME85Ty2tro2Ul', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@overkc.com"}, {$set:{'applications':[ { 'name' : 'Over KC','legacyKey':'w1QdT7jt4jPXi8m', 'apiKey' : 'O6yDIDTM1R32QuIysg26', 'apiSecret' : 'thDE0852guiWr96TUgZ5pwryd7vME85Ty2tro2Ul', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@pittsburgh.ks"}, {$set:{'applications':[ { 'name' : 'Pittsburg KS','legacyKey':'9CXVnIllv6RbSrK', 'apiKey' : 'iB3KkMy8CteQFyBrZiLh', 'apiSecret' : 'eys8Aky5oZZki9QzDOp2kXecgZVJB1bFAZgtkaoo', 'privileges':"STANDARD"}]}});
db.user.update({ 'email' : "hooplaAdmin@localruckus.com"}, {$set:{'applications':[ { 'name' : 'hoopla-io-web', 'apiKey' : 'METkwI15Bg0heuRNaru6', 'apiSecret' : '6n0pRhok4WR8yx8VudUD7XshboNCz51oFXJvZA2y', 'privileges':'PRIVILEGED'},{ 'name' : 'localruckus', 'apiKey' : 'XVoZHNOJ2kFdrApkq4wM', 'apiSecret' : 'dXzDtPBav3WGiXzBGhszOrMdEpLSVZChp7cdN2l7', 'privileges':'STANDARD'}]}});