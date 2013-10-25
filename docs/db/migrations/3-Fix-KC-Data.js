/*Run ONCE ONLY*/
db.business.update({},{$set:{'sources':[{'sourceType':'hoopla', "lastUpdated":new Date()}]}},{multi:true});
db.event.update({},{$set:{'sources':[{'sourceType':'hoopla', "lastUpdated":new Date()}]}},{multi:true});

/* Name normalization */
db.business.update({'name' : 'Kansas City Music Hall'},{$set:{'name' : 'Music Hall Kansas City'}});
db.business.update({'name' : 'Granada Theater'},{$set:{'name' : 'Granada'}});
db.business.update({'name' : 'The Blue Room'},{$set:{'name' : 'Blue Room'}});
db.business.update({'name' : 'Sporting Park'},{$set:{'name' : 'Sporting Park'}});
db.business.update({'name' : 'VooDoo Lounge'},{$set:{'name' : 'Voodoo Cafe and Lounge At Harrahs'}});
db.business.update({'name' : 'The Bottleneck'},{$set:{'name' : 'Bottleneck'}});
db.business.update({'name' : 'The Midland by AMC'},{$set:{'name' : 'Arvest Bank Theatre at The Midland'}});
db.business.update({'name' : 'record Bar'},{$set:{'name' : 'The Record Bar'}});
db.business.update({'name' : 'Trouser Mouse Bar & Grill'},{$set:{'name' : 'Trouser Mouse'}});
db.business.update({'name' : 'Lied Center of Kansas'},{$set:{'name' : 'Lied Center - KS'}});
db.business.update({'name' : 'Grand Ballroom'},{$set:{'name' : 'KC Convention Grand Ballroom'}});
db.business.update({'name' : 'Jackpot Saloon & Music Hall'},{$set:{'name' : 'Jackpot Music Hall'}});
db.business.update({'name' : 'All Souls Unitarian Universalist Church Grounds'},{$set:{'name' : 'All Soul Unitarian'}});
db.business.update({'name' : 'Aftershock Bar & Grill'},{$set:{'name' : 'Aftershock'}});
db.business.update({'name' : 'Municipal Auditorium (Arena)'},{$set:{'name' : 'Municipal Auditorium'}});
db.business.update({'name' : "Davey's Uptown Ramblers Club"},{$set:{'name' : 'Daveys Uptown Ramblers Club'}});
db.business.update({'name' : 'Ameristar Casino Hotel Kansas City'},{$set:{'name' : 'Ameristar Casino & Hotel - Kansas City'}});
db.business.update({'name' : 'The Kill Devil Club'},{$set:{'name' : 'Kill Devil Club'}});
db.business.update({'name' : 'Gem Theater'},{$set:{'name' : 'Gem Theatre-MO'}});

/* Location Fixes */
db.business.update({'name' : 'Sporting Park'}, {$set : {'location.geo.coordinates' : [-94.8242,39.1232]}});
db.business.update({'name' : 'Granada'}, {$set : {'location.geo.coordinates' : [-95.2359,38.9648]}});
