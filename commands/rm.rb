module Commands
  class Rm 
    def initialize(path = nil)
      @path = path 
    end

    def perform
      puts "You need to select path" if @path.nil?
      if File.file?(@path) || File.directory?(@path)
        if File.file?(@path)
          check = 'file'
        else
          check = 'directory'
        end
        puts "Are you sure you want to remove #{check}: #{@path} (Y/n))?"
        answer = gets.chomp
        if answer == 'Y' || answer == 'y' || answer == 'Yes' || answer == 'yes'
          if File.file?(@path)
            FileUtils.rm(@path)
          else 
            FileUtils.rmdir(@path)
          end
        end
      else
        puts "rm: cannot remove #{@path}: No such file or directory"
      end
    end
  end
end

