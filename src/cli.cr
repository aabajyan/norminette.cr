require "json"
require "option_parser"
require "./norminette"

# TODO: Actually apply those into the request.
rules = [] of String
OptionParser.parse do |parser|
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
      puts result
      puts "Norminette.cr version #{Norminette::VERSION}:"
      puts "Norminette server version: #{result["display"]}"
    end

    temp.publish({action: "version"}.to_json)
    temp.sync
    exit
  end

  parser.on "-R Array", "--rule Array", "Apply Version" do |rule|
    rules << rule
  end
end

def print_norme(result : JSON::Any)
  puts "Norme: #{result["filename"]}"
  puts result["display"] if result["display"].as_s?
end

def print_error(file : String)
  puts "#{File.basename(file)} is not a valid file."
end

Norminette::Validate.new(rules, ->print_norme(JSON::Any), ->print_error(String)).check ARGV
