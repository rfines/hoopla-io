module.exports.resize = (width, height, url) ->
  u = url
  t = u.split('/')
  a = t.indexOf('upload')
  t[a+1] = "c_fill,h_#{height},w_#{width}"
  t.join('/')