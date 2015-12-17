module Commands
  class Ls
    def initialize(current_path, path = nil)
      @current_path = current_path 
      @path = path
    end

    def perform
      if @path.nil?
        str = Dir[@current_path + '/*'].join('  ')
        puts str.gsub(@current_path + '/', '')
      else
        if File.directory?(@path) && !(Pathname.new @path).absolute?
          @path = File.absolute_path(@path)
        end
        if File.directory?(@path)
          Dir.chdir(@path)
          path_to_dir = Dir.pwd
          str = Dir[path_to_dir + '/*'].join('  ')
          puts str.gsub(path_to_dir + '/', '')
        elsif File.file?(@path)
          puts File.basename(@path)
        else
          puts "No such file or directory"
        end
      end
    end
  end
end
