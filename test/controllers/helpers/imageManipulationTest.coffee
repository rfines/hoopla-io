sinon = require 'sinon'

describe "Image Manipulation Library", ->
  it "should transform an image url to use the height and width parameters", (done)->
    imageManipulation = require '../../../src/controllers/helpers/imageManipulation'
    out = imageManipulation.resize(200, 200,"http://res.cloudinary.com/durin-software/image/upload/v1375113455/p3ux4buvr7ayhbeykoiq.jpg")
    out.should.be.equal "http://res.cloudinary.com/durin-software/image/upload/c_fill,h_200,w_200/p3ux4buvr7ayhbeykoiq.jpg"
    done()