module.exports.resize = (width, height, url, cropType) ->
  u = url
  t = u.split('/')
  a = t.indexOf('upload')
  p = ['f_auto','q_85']
  p.push "h_#{height}" if height
  p.push "w_#{width}" if width
  if cropType and cropType is 'circle'
    p.push 'c_thumb'
    p.push 'g_face'
    p.push "r_max"
  else
    p.push 'c_fill'
  t[a+1] = p.join(',')
  final = t.join('/')
  if cropType and cropType is 'circle'
    final = final.replace('.jpg', '.png')
  final

module.exports.getId = (url) ->
  t = url.split('/')
  final = t[t.length-1]
  return final
  