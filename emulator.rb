require 'fileutils'
require_relative 'commands/ls'
require_relative 'commands/cd'
require_relative 'commands/mv'
require_relative 'commands/rm'
require_relative 'commands/find'

class Emulator
  attr_accessor :home

  def initialize(home)
    @home = home
  end

  def run
    loop do
      print @home + ' > '
      line = gets.chomp
      command, *args = line.split(' ')
      case  command 
      when 'cd'
       @home = Commands::Cd.new(@home, *args).perform 
      when 'ls'
        Commands::Ls.new(@home, *args).perform
      when 'mv'
        Commands::Mv.new(*args).perform
      when 'cp'
        Commands::Cp.new(*args).perform
      when 'rm'
        Commands::Rm.new(*args).perform
      when 'find'
        Commands::Find.new(@home, *args).perform
      when 'exit'
        exit
      end
    end
  end
end

Emulator.new(ENV['HOME']).run
