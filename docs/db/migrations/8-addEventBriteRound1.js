db.aggregationJob.save({name: 'EVENTBRITE-KC', provider: 'eventbrite', postalCode: '64105'})
db.aggregationJob.save({name: 'EVENTBRITE-STL', provider: 'eventbrite', postalCode: '63112'})

// Verify: db.event.count({'sources.sourceType' : 'eventbrite'});