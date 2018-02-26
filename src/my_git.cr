
require "shell_out"

module My_Git

  module Log

    PATH = "tmp/out/changed.txt"
    RECORDS = {} of String => Int64
    CHANGED = {} of String => Int64

    def self.load
      return if !RECORDS.empty?

      Dir.mkdir_p(File.dirname(PATH))
      File.touch(PATH)
      File.each_line(PATH) { |line|
        pieces = line.split('|')
        RECORDS[pieces.first] = pieces.last.to_i64
      }
    end

    def self.changed?(file_name, epoch)
      !RECORDS[file_name]? || RECORDS[file_name] != epoch
    end

    def self.update
      Dir.mkdir_p(File.dirname(PATH))
      ls_files.each_line { |line|
        RECORDS[line] = File.stat(line).mtime.epoch
      }
      File.open(PATH, "w") { |f|
        RECORDS.each { |k, v| f.puts "#{k}|#{v}" }
      }
    end

    def self.ls_files
      shell_out("git ls-files --cached --others --exclude-standard")
    end

    def self.changed_files
      My_Git::Log.load
      files = [] of String
      ls_files.each_line { |line|
        if changed?(line, File.stat(line).mtime.epoch)
          files.push(line)
        end
      }
      files
    end

    def self.watch
      keep_running = true
      Signal::INT.trap {
        keep_running = false
        Signal::INT.reset
      }
      while keep_running
        My_Git::Log.changed_files.each { |f| yield f }
        My_Git::Log.update
        sleep 1
      end
    end

  end # === module Log

end # === module My_Git

