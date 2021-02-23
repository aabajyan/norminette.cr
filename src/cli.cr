require "json"
require "option_parser"
require "./norminette"

# rules = [] of String
OptionParser.parse do |parser|
  parser.banner = "Welcome to The Beatles App!"

  parser.on "-h", "--help", "Show help" do
    temp = Norminette::Sender.new ->(result : JSON::Any) do
      puts "Norminette usage:"
      puts result["display"]
    end

    temp.publish({action: "help"}.to_json)
    temp.sync
    exit
  end

  parser.on "-v", "--version", "Show version" do
    temp = Norminette::Sender.new ->(result : JSON::Any) do
      puts "Norminette.cr version #{Norminette::VERSION}:"
      puts "Norminette server version: #{result["display"]}"
    end

    temp.publish({action: "version"}.to_json)
    temp.sync
    exit
  end

  # parser.on "-R", "--rules Array", "Rules to disable" do |rule|
  #   rules << rule
  # end
end

Norminette::Validate.new(->(result : JSON::Any) do
  # , rules: @rules
  puts "Norme: #{result["filename"]}"
  puts result["display"] if result["display"].as_s?
end).check ARGV
