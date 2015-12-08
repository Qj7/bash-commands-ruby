module Commands
  class Cd 
    def initialize(current_path, path = nil)
      @current_path = current_path 
      @path = path
    end

    def perform
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
