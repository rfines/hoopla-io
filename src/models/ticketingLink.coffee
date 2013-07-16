mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

TicketingLinkSchema = new Schema
  ticketUrl: String
  ticketsAvailable: Number 
  ticketCost: Number

module.exports = 
  TicketingLink : mongoose.model('ticketingLink', TicketingLinkSchema)
  TicketingLinkSchema : TicketingLinkSchema
