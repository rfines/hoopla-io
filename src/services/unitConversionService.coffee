#miles = meters * 0.00062137

metersToMiles = (meters) ->
  return (parseFloat(meters) * 0.00062137)
    
milesToMeters = (miles) ->
  return (parseFloat(miles)/0.00062137)
  
module.exports =
  milesToMeters : milesToMeters
  metersToMiles : metersToMiles