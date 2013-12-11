require 'RMagick'
require 'streamio-ffmpeg'

module MIAConverter

	# Converts a video to an animated GIF.



	class Converter
		
		# Path to original file
		attr_accessor :original_file

		# Number of seconds into original video to start animated GIF
		attr_accessor :start_seconds

		# Number of seconds of original video represented in animated GIF
		attr_accessor :length_seconds

		# seconds apart to take video screenshots
		attr_accessor :shot_gap

		# Time between animated GIF frame transitions
		attr_accessor :transition_time


		def initialize(original_file, options={})

			@original_dir = Dir.pwd

			@original_file = File.expand_path original_file
			@init_time = Time.now

			# DEFAULTS
			@shot_gap = 0.5
			@start_seconds = 0
			@transition_time = 20
			@length_seconds = 20

			# Set instance variables from options dictionary
			options.each {|key,value| self.instance_variable_set("@#{key}", value) }
		end

		# Tests if the passed in original file exists
		def original_file_valid?
			File.exists? @original_file
		end


		# Processes input video
		# * extracts relevant parts of original video
		# * produces screenshots
		# * turns screenshots into an animated GIF
		def process
			extract_relevant_parts_of_video
			create_still_images
			create_animated_image
		end








		# Returns path to /tmp/MIAConverter. 
		# Creates foler if necessary.
		def base_folder
			temp_folder_path = "/tmp/MIAConverter"
			Dir.mkdir(temp_folder_path) unless Dir.exists?(temp_folder_path)
			temp_folder_path
		end

		# Returns path to temporary folder for this run of the converter object.
		# Creates folder if necessary.
		def get_temp_folder
			current_tmp_path = "#{base_folder}/#{time_second_string}"
			Dir.mkdir(current_tmp_path) unless Dir.exists?(current_tmp_path)
			current_tmp_path
		end

		# Returns images folder for this run of the converter object.
		# Creates folder if necessary.
		def get_images_folder
			images_folder_path = "#{get_temp_folder}/images"
			Dir.mkdir(images_folder_path) unless Dir.exists?(images_folder_path)
			images_folder_path
		end

		# Returns number string based on time object was created.
		def time_second_string
			@init_time.to_f.to_s.sub('.', '-')
		end

    def animated_gif_file_name
    	"animated.gif"
    end

    def chopped_video_path
    	chopped_path = "#{get_temp_folder}/chopped.mp4"
    end

    def animated_gif_path
    	"#{get_temp_folder}/#{animated_gif_file_name}"
    end

    # Alias for get_images_folder
    def screenshots_folder_path
    	get_images_folder
    end

    # Array of all .jpg filenames in images folder
    def still_image_paths
    	Dir["#{get_images_folder}/*.jpg"]
    end

		




		# 
		# Make video shorter, so we have only relevant parts
		# 
    def extract_relevant_parts_of_video
      orig_movie = FFMPEG::Movie.new(@original_file)
      throw "Start Seconds beyond end of video" if @start_seconds > orig_movie.duration
      @chopped_movie = orig_movie.transcode(chopped_video_path, duration: @length_seconds + 1, seek_time: @start_seconds)

      chopped_video_path
    end


    def create_still_images
    	img_folder = get_images_folder # call once

			# BUILD UP THE LIST OF SEEK_TIMES
	    seek_times = (0.0...@length_seconds).step(@shot_gap).to_a.select do |time|
	    	time <= @chopped_movie.duration || time <= @length_seconds
	    end

    	# SCREEN GRABS
    	seek_times.each.with_index do |time, idx|
    		padded_string = "%010i" % idx
    		file_name = "#{img_folder}/shot-#{padded_string}.jpg"
  			@chopped_movie.screenshot(file_name, seek_time: time)
    	end

    	still_image_paths
    end


    def create_animated_image
    	animation = Magick::ImageList.new(*still_image_paths)
    	animation.delay = @transition_time    	
      animation.write(animated_gif_path)

    	animated_gif_path
    end

	end
end