
require "../src/my_git"

case ARGV.first?
when "watch"
  My_Git::Log.watch { |f|
    puts f
  }

when "ls-changed"
  My_Git::Log.changed_files.each { |f| puts f }

else
  STDERR.puts "!!! Unknown arguments: #{ARGV.inspect}"
  exit 2
end
