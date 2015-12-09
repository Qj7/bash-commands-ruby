module Commands
  class Find 
    def initialize(current_path, path = current_path)
      @current_path = current_path 
      @path = path
    end

    def perform
      if File.directory?(@path)
        while File.directory?(@path)
          puts str = Dir[@path + '/*'].join('  ')
          arr = @path.split('/')
          arr.pop
          @path = arr.join('/')
        end
      else
        puts "find: cannot find #{@path}: No such directory"
      end
    end
  end
end
