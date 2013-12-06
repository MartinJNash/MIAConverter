require File.expand_path(File.dirname(__FILE__) + '/spec_helper')



sp_path = File.expand_path(File.dirname(__FILE__) + '/../example/typing.mp4')

# TO TEST RELATIVE PATH
# Dir.chdir File.dirname(__FILE__)
# sp_path = "sp17-08.mp4"



describe MIAConverter do

	before(:all) do
		@converter = MIAConverter::Converter.new(
			sp_path, 
			start_seconds: 5, 
			length_seconds: 10,
			transition_time: 15
		)
	end



	context "new object setup" do

		it "should make a new converter object" do
			MIAConverter::Converter.new('').should_not be_nil
		end

		it "should take #segment_length option at creation time" do
			@converter.length_seconds.should == 10
		end

		it "should take #transition_time option at creation time" do
			@converter.transition_time.should == 15
		end

		it "should take #start_time option at creation time" do
			@converter.start_seconds.should == 5
		end

	end




	context "file creation" do

		before :all do

			@converter.length_seconds = 5
			@converter.start_seconds = 5
			@converter.transition_time = 25
			@converter.shot_gap = 0.5

			@short_path = @converter.extract_relevant_parts_of_video
			@images = @converter.create_still_images
			@animated_image_path = @converter.create_animated_image

		end


		it "should create a temporary fodler to use every time" do
			Dir.exists?(@converter.get_temp_folder).should == true
		end

		it "should create shorter video to work on" do
			File.exists?(@short_path).should == true
		end

		it "should create still images" do
			@images.count.should > 0
		end

		it "should create an animated gif" do
			File.exists?(@animated_image_path).should == true
		end

	end


end