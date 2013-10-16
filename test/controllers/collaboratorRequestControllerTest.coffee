sinon = require 'sinon'
describe "Operations for Collaboration Requests", ->
  controller = {}
  emailService = {
    send : (options, cb) ->
      cb()
  }
  req = {}
  res = {}  

  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/collaboratorRequestController')
    controller.collaborator = require('../../src/models/collaboratorRequest').CollaboratorRequest
    mockUser ={
      businessPrivileges: [],
      email:'user1@localruckus.com',
      _id: '564762914',
      save: (cb) ->
        cb(null, {})
    }
    mockBusiness = {
      _id:'51e59041d4b51b0000000003',
      name:"Zona Rosa",
      save: (cb)->
        cb(null, {})
    }

    mockBusinessModel ={
      findOne:(query, fields, opts, cb) =>
        cb null, mockBusiness
    }

    mockModel = {
      findOne:(query, fields, opts,cb) =>
        cb(null, mockUser)
    }
    controller.collaborator = class Collaborator
      constructor: () ->
        return {
          save: (cb) ->
            cb() if cb
        } 
    controller.user = mockModel
    controller.business = mockBusinessModel
    controller.emailService = emailService
          
    req = 
      body : {email:'user1@localruckus.com', business: '51e59041d4b51b0000000003'}
    res = 
      send: ( (status, body) ->)        
    done()

  it 'should add a business privileges to a user', (done) ->
    responseSpy = sinon.spy(res, 'send')
    controller.addCollaborator req, res, (err, message) ->
      responseSpy.calledWith(200).should.be.true
      done()

  it 'should not add a business privileges to a user when no business is passed', (done) ->
    req = 
      body: {email:'user1@localruckus.com'}
    controller.addCollaborator req, res, (err, message) ->
      err.statusCode.should.be.equal 400
      done()
      
  it 'should send an email to a user that is not found', (done) ->
    mailSpy = sinon.spy(emailService, 'send')
    mockModel = {
      findOne:(query, fields, opts,cb) =>
        cb(null, {})
    }
    controller.user = mockModel
    options = 
      message: 
        'to' : [{email:'user1@localruckus.com'}]
        'global_merge_vars' : [{name : 'REGISTER_URL', content : "http://localhost:3000/register"},{name:'BUSINESS_NAME', content:"Zona Rosa"}]
      template_name : 'add-business-collaborator'
      template_content : []
    controller.addCollaborator req, res, (err, message) ->
      mailSpy.calledWith(options).should.be.true
      done()