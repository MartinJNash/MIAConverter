require 'MIAConverter'
require 'FileUtils'



conv = MIAConverter::Converter.new('./typing.mp4')
conv.start_seconds = 0.0
# conv.length_seconds = 5
conv.shot_gap = 0.5
conv.transition_time = 40

final_path = conv.process

# TODO:
# Process should take a block and report finished
# if start seconds is more than video length, throw exception

# MOVE THOSE FILES SOMEWHERE
FileUtils.mv(final_path, "./#{Time.now.to_i}-tt#{conv.transition_time}-gap#{conv.shot_gap}animated.gif")
# FileUtils.mv(conv.chopped_video_path, "./#{Time.now.to_i}chopped.mp4")
