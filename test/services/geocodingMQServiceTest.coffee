service = require('../../src/services/geocodingMQService')

describe "Geocoding using MapQuest Service", ->
  it 'should select a point location if applicable', (done) ->
    l = service.bestLocation([
      {geocodeQualityCode : 'A1XXX'}, {geocodeQualityCode : 'P1XXX'}
    ])
    l.should.be.eql {geocodeQualityCode : 'P1XXX'}
    done()

  it 'should select a address location if point is not available', (done) ->
    l = service.bestLocation([
      {geocodeQualityCode : 'L1XXX'}, {geocodeQualityCode : 'A1XXX'}
    ])
    l.should.be.eql {geocodeQualityCode : 'L1XXX'}
    done()   

  it 'should be undefined if no locations are available', (done) ->
    l = service.bestLocation([])
    l.should.not.exist
    done()        
