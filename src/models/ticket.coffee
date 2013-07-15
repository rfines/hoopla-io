mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

TicketSchema = new Schema
  ticketUrl:
    type:String
    required: false
  ticketsAvailable: 
    type:Number
    required: false
  ticketCost:
    type: Number
    require:false
module.exports = 
  Ticket : mongoose.model('ticket', TicketSchema)
