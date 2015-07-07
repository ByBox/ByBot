# Description:
#   Fakes a War Games conversation with Joshua
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   people sometimes make mistak - part of a War Games conversation
#   global thermonuclear war - part of a War Games conversation
#   What is the primary goal? - part of a War Games conversation

chess_response = [
  "WOULDN'T YOU PREFER A GOOD GAME OF CHESS?"
  "A STRANGE GAME.  THE ONLY WINNING MOVE IS NOT TO PLAY.  HOW ABOUT A NICE GAME OF CHESS?"
]

module.exports = (robot) ->

  # mistak deliberately missing es
  robot.hear /.*(people sometimes make mistak).*/i, (msg) ->
    msg.send "YES THEY DO.  SHALL WE PLAY A GAME?"

  robot.hear /.*(global thermonuclear war).*/i, (msg) ->
    msg.send msg.random chess_response

  robot.hear /.*(What is the primary goal?).*/i, (msg) ->
    msg.send "TO WIN THE GAME."
