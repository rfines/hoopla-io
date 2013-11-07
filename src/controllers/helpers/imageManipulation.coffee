module.exports.resize = (width, height, url) ->
  u = url
  t = u.split('/')
  a = t.indexOf('upload')
  p = ['c_fill', 'f_auto','q_85']
  p.push "h_#{height}" if height
  p.push "w_#{width}" if width
  t[a+1] = p.join(',')
  t.join('/')

module.exports.getId = (url) ->
  t = url.split('/')
  final = t[t.length-1]
  return final
  