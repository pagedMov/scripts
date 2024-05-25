This script takes the output of "playerctl metadata" and converts it into JSON format. I haven't extensively tested it, so there may be some fringe cases that break it. If something breaks, open an issue and I'll take a look at it.

You can execute it with no arguments to get the json output one time, or you can run it with the argument "--listen" to constantly output new JSON data any time a valid player changes state. Use it with your favorite widget manager to keep constant track of the currently playing song/video/whatever on your machine.
