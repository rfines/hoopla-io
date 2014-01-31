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
db.user.save(overkcApi);
var pittApi = {
  'email' : "admin@hoopla.io",
  'name' : 'Curation Interface',
  'password' : "$2a$12$WgPsqg/zG8Q4PXWxRGJ4luq7qcHITsNB40DyDM0ihaDxivhzWtJV6", //Bcrypted version of h00plaAdmin**
  'encryptionMethod' : 'BCRYPT',
  'applications' : [ { 'name' : 'Curation Platform', 'apiKey' : 'iB3KkMy8CteQFyBrZiLh', 'apiSecret' : 'eys8Aky5oZZki9QzDOp2kXecgZVJB1bFAZgtkaoo'}]
}
db.user.save(pittApi);
db.user.update({'email' : "hemant.v.tiwari@sprint.com"}, {$set:{'applications' : [ { 'name' : 'Sprint Api','legacyKey':'CjV94IobahVjMt9', 'apiKey' : 'GgTK2l1KV6ApWi5pLEtM', 'apiSecret' : 'PM0T8wV1BpboudLillneCVPppuuSAbgSaK7HykKJ', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@crossroads.com"}, {$set:{'applications': [ { 'name' : 'Crossroads Api','legacyKey':'SpclFmVso48IfP5', 'apiKey' : 'fKsdRDgHSm9tvkl7wALE', 'apiSecret' : 'prWmZRV2NhJUl8hMqcxgFVQZBZwdVxyBu3TIIUhJ', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@foundation.com"}, {$set:{'applications':[ { 'name' : 'Over KC','legacyKey':'w1QdT7jt4jPXi8m', 'apiKey' : 'O6yDIDTM1R32QuIysg26', 'apiSecret' : 'thDE0852guiWr96TUgZ5pwryd7vME85Ty2tro2Ul', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@overkc.com"}, {$set:{'applications':[ { 'name' : 'Over KC','legacyKey':'w1QdT7jt4jPXi8m', 'apiKey' : 'O6yDIDTM1R32QuIysg26', 'apiSecret' : 'thDE0852guiWr96TUgZ5pwryd7vME85Ty2tro2Ul', 'privileges':'STANDARD'}]}});
db.user.update({'email' : "info@pittsburgh.ks"}, {$set:{'applications':[ { 'name' : 'Pittsburg KS','legacyKey':'9CXVnIllv6RbSrK', 'apiKey' : 'iB3KkMy8CteQFyBrZiLh', 'apiSecret' : 'eys8Aky5oZZki9QzDOp2kXecgZVJB1bFAZgtkaoo', 'privileges':"STANDARD"}]}});
db.user.update({ 'email' : "hooplaAdmin@localruckus.com"}, {$set:{'applications':[ { 'name' : 'hoopla-io-curation', 'apiKey' : 'IlbOPvcJV4rDaWonBEsJ', 'apiSecret' : 'eEWztl1vDGaElxTNzlqJu8kVaI3R1Le2NN7tRNC2','privileges':'PRIVILEGED'},{ 'name' : 'hoopla-io-web', 'apiKey' : 'METkwI15Bg0heuRNaru6', 'apiSecret' : '6n0pRhok4WR8yx8VudUD7XshboNCz51oFXJvZA2y', 'privileges':'PRIVILEGED'},{ 'name' : 'localruckus', 'apiKey' : 'XVoZHNOJ2kFdrApkq4wM', 'apiSecret' : 'dXzDtPBav3WGiXzBGhszOrMdEpLSVZChp7cdN2l7', 'privileges':'STANDARD'}]}});
db.user.update({'email':"trey.rhedrick@gmail.com"},{$set:{'applications':[{'name':'TreyApp', 'apiKey':'xTAb2m27Hoik5bt8POnt', 'apiSecret':'hnZK4ODMIBPm9TUI8VBDapVGTFTCwmZzL3x0OieS', 'privileges':'STANDARD'}]}});
db.user.update({'email':"jwatkins@mmgyglobal.com"},{$set:{'applications':[{'name':'mmgyglobal', 'apiKey':'HTeZAI0GkXJDZFoeXOqQ', 'apiSecret':'GqzVQHMUvqlfArIILuyJCTKGi2oNVgBTREq1fQaE', 'privileges':'STANDARD'}]}});

//manhattan ks businesses
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("528fa6b2f55ac402000004d4") }]}}});

db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aba5") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aba6") },{'role':'OWNER', "business":ObjectId("52b870e51980c40200000d09") },{'role':'OWNER', "business":ObjectId("52509380546ce302000006f8") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("52b875481980c40200000e57") },{'role':'OWNER', "business":ObjectId("527957354f5cef02000000a7") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abca") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abd7") },{'role':'OWNER', "business":ObjectId("52aa0c8c3bb2760200001b53") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abd0") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("527957334f5cef020000007e") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abb9") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abbf") },{'role':'OWNER', "business":ObjectId("52c1e35b54506902000012dc") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abc3") },{'role':'OWNER', "business":ObjectId("52b87f2b1980c402000010a4") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("52508db8546ce302000003fe") },{'role':'OWNER', "business":ObjectId("52b86fd61980c40200000ceb") },{'role':'OWNER', "business":ObjectId("52bddafb5ccfbf02000013da") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aba3") },{'role':'OWNER', "business":ObjectId("52bdab195ccfbf0200000a1d") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abbc") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("52b350143e448d02000019f3") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abc6") },{'role':'OWNER', "business":ObjectId("52b878af1980c40200000e97") },{'role':'OWNER', "business":ObjectId("5279574b4f5cef02000001ac") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abc5") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abc4") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abd5") },{'role':'OWNER', "business":ObjectId("52ab475edbdf6f020000142e") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abc9") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abaa") },{'role':'OWNER', "business":ObjectId("52a8f9c33bb2760200000074") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abce") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abab") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abd6") },{'role':'OWNER', "business":ObjectId("528fa406f55ac40200000490") },{'role':'OWNER', "business":ObjectId("528ceb085daafe0200001954") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abac") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aae5") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("528fad6df55ac402000005be") },{'role':'OWNER', "business":ObjectId("52c3db0a8b88c6020000009a") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abcb") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abbe") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abcd") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abd1") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abad") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abbd") },{'role':'OWNER', "business":ObjectId("52b87a411980c40200000eb5") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aba9") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abc7") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abbb") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abcc") },{'role':'OWNER', "business":ObjectId("528cf1895daafe0200001a5f") },{'role':'OWNER', "business":ObjectId("5279574c4f5cef02000001b2") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aba4") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abae") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abd2") }]}}});
db.user.update({"email":"manhattanks@localruckus.com"},{$set:{'businessPrivileges':[{'role':'OWNER', "business":ObjectId("5250965d546ce30200000787") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abd4") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400abc8") }]}});

//pittsburgh ks businesses
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") },{'role':'OWNER', "business":ObjectId("") }]}}});

//to remove from info@
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400aba5") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400aba6") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52b870e51980c40200000d09") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52509380546ce302000006f8") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400aba8") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52b875481980c40200000e57") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("527957354f5cef02000000a7") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abca") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abd7") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52aa0c8c3bb2760200001b53") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abd0") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("527957334f5cef020000007e") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abb9") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abbf") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52c1e35b54506902000012dc") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abc3") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52b87f2b1980c402000010a4") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52508db8546ce302000003fe") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52b86fd61980c40200000ceb") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52bddafb5ccfbf02000013da") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400aba3") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52bdab195ccfbf0200000a1d") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abbc") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52b350143e448d02000019f3") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abc6") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52b878af1980c40200000e97") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5279574b4f5cef02000001ac") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abc5") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abc4") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abd5") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52ab475edbdf6f020000142e") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abc9") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abaa") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52a8f9c33bb2760200000074") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abce") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abab") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abd6") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("528fa406f55ac40200000490") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("528ceb085daafe0200001954") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abac") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400aae5") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("528fad6df55ac402000005be") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abcb") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52c3db0a8b88c6020000009a") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abbe") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abcd") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abd1") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abad") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abbd") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("52b87a411980c40200000eb5") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400aba9") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abc7") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abbb") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abcc") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("528cf1895daafe0200001a5f") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5279574c4f5cef02000001b2") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400aba4") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abae") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abd2") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5250965d546ce30200000787") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abd4") }}});
db.user.update({"email":"info@localruckus.com"},{$pull:{'businessPrivileges':{"business":ObjectId("5249ba439c23c5a0f400abc8") }}});


db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5255bfe12d52130200000a12") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa89") },{'role':'OWNER', "business":ObjectId("52cdf1610587f002000018f0") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab8d") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa84") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa57") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aad9") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aafb") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa56") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa41") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab93") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa87") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa88") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab88") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab05") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab92") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa47") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa4d") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab8c") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aad8") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa42") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa1e") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa5d") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa67") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab89") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab06") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa71") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab8a") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("52a8e87e682fbc02000028c5") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa3f") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa43") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa55") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("52b470be3e9c870200000c95") },{'role':'OWNER', "business":ObjectId("52b4752c3e9c870200000d01") },{'role':'OWNER', "business":ObjectId("52b473063e9c870200000cd4") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab8b") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab30") },{'role':'OWNER', "business":ObjectId("5258276d5e49a8020000039a") },{'role':'OWNER', "business":ObjectId("526e6684a02b7a02000003a8") },{'role':'OWNER', "business":ObjectId("52a10619b6309502000002ec") }]}}});
db.user.update({"email":"pittsburgks@localruckus.com"},{$push:{'businessPrivileges':{$each:[{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa54") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab0c") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab66") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aabe") },{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400ab91") }]}}});

db.event.update({"_id":ObjectId("526f22646502a402000007bf")}, {"business":ObjectId("528fa6b2f55ac402000004d4")});
db.user.update({"email":"shelbyhobbs@gus.pittstate.edu"},{$push:{'businessPrivileges':{'role':'OWNER', "business":ObjectId("52a8e87e682fbc02000028c5") }}});
db.user.update({"email":"apeterson@pplonline.org"},{$push:{'businessPrivileges':{'role':'OWNER', "business":ObjectId("5249ba439c23c5a0f400aa55") }}});