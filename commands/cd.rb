module Commands
  class Cd 
    def initialize(current_path, path = nil)
      @current_path = current_path 
      @path = path
    end

    def perform
      @current_path if @path.nil?
      if File.directory?(@path) && !(Pathname.new @path).absolute?
        @path = File.absolute_path(@path)
      end
      if File.directory?(@path)
        Dir.chdir(@path)
	@current_path = @path
      else
        puts "No such directory"
      end
      @current_path
    end
  end
end
