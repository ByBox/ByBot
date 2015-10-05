# Description:
#   FogBugz hubot helper
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   HUBOT_FOGBUGZ_BASE_URL
#   HUBOT_FOGBUGZ_TOKEN
#
# Commands:
#   bug <number> - provide helpful information about a FogBugz case
#   case <number> - provide helpful information about a FogBugz case
#
# Notes:
#   
#   curl 'HUBOT_FOGBUGZ_BASE_URL/api.asp' -F'cmd=logon' # -F'email=EMAIL' -F'password=PASSWORD'
#   and copy the data inside the CDATA[...] block.
#
#   Tokens only expire if you explicitly log them out, so you should be able to
#   use this token forever without problems.
#
# Author:
#   dstrelau

Parser = require('xml2js').Parser
env = process.env
util = require 'util'

module.exports = (robot) ->
  if env.HUBOT_FOGBUGZ_BASE_URL and env.HUBOT_FOGBUGZ_TOKEN
    robot.hear /\b(?:bugz?|case|FB)\s*(\d+)/i, (msg) ->
      msg.http("#{env.HUBOT_FOGBUGZ_BASE_URL}/api.asp")
        .query
          cmd: "search"
          token: env.HUBOT_FOGBUGZ_TOKEN
          q: msg.match[1]
          cols: "ixBug,sTitle,sStatus,sProject,sArea,sPersonAssignedTo,ixPriority,sPriority,sLatestTextSummary"
        .get() (err, res, body) ->
          if err
            msg.send "Error parsing response"
          (new Parser()).parseString body, (err,json) ->
            if json.response.error
              msg.send "Fogbugz returned error: #{json.response.error[0]._}"
            else
              truncate = (text,length=60,suffix="...") ->
                if text.length > length then (text.substr(0,length-suffix.length) + suffix) else text
              bug = json.response.cases?[0].case[0]
              if bug
                details = [
                  "#{env.HUBOT_FOGBUGZ_BASE_URL}/?#{bug.ixBug[0]}"
                  "  FogBugz #{bug.ixBug[0]}: #{bug.sTitle[0]}"
                  "  Priority: #{bug.ixPriority[0]} - #{bug.sPriority[0]}"
                  "  Project: #{bug.sProject[0]} (#{bug.sArea[0]})"
                  "  Status: #{bug.sStatus[0]}"
                  "  Assigned To: #{bug.sPersonAssignedTo[0]}"
                  "  Latest Comment: #{truncate bug.sLatestTextSummary[0]}"
                ]
                msg.send details.join("\n")
