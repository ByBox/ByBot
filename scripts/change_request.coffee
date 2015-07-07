# Description:
#   Displays change request template.
#
# Commands:
#   hubot change request - Reply with change request template
#   hubot change request template - Reply with change request template

crypto = require 'crypto'

module.exports = (robot) ->

  forceTwoDigits = (val) ->
    if val < 10
      return "0#{val}"
    return val

  formatDate = (date) ->
    year = date.getFullYear()
    month = forceTwoDigits(date.getMonth()+1)
    day = forceTwoDigits(date.getDate())
    hour = forceTwoDigits(date.getHours())
    minute = forceTwoDigits(date.getMinutes())
    second = forceTwoDigits(date.getSeconds())
    return "#{day}/#{month}/#{year} #{hour}:#{minute}:#{second}"
    
  hexSha1 = (string) ->
    hash = crypto.createHash 'sha1'
    hash.update string
    hash.digest 'hex'
      
  robot.respond /change request( template)?$/i, (msg) ->
    username = msg.message.user.name
    currentDateTime = formatDate(new Date)
    identifier = hexSha1 "#{username}#{currentDateTime}"
    identifier = identifier.substr(1,8)
  
    msg.send """Hi @ChangeRequests.
Request ID: #{identifier}
Name: #{username}
Date: #{currentDateTime}
Approval required for [application/service/site name]:
Reason for change:
Impact:
Tested [e.g. locally or "need help (from @user) to test"]:"""
