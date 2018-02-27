
require "../src/my_git"

case
when ARGV.first? == "dev" && ARGV.last? == "watch"
  puts "... watching"
  loop {
    My_Git::Files.compile { |f|
      case f
      when "compile!"
        DA_Process.out!("my_git.cr", %w[dev run], input: STDOUT)
      else
        puts "--- file change: #{f}"
      end
    }
    sleep 0.5
  }

when "ls-changed"
  My_Git::Log.changed_files.each { |f| puts f }

else
  STDERR.puts "!!! Unknown arguments: #{ARGV.inspect}"
  exit 2
end
