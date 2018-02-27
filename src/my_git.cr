
require "da_process"
require "inspect_bang"

module My_Git

  module Files

    PATH = "tmp/out/changed.txt"
    PATH_DO_COMPILE = "tmp/out/do_compile"
    RECORDS = {} of String => Int64
    CHANGED = {} of String => Int64

    def self.load_changes
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

    def self.update_log
      Dir.mkdir_p(File.dirname(PATH))
      ls_files.each_line { |line|
        RECORDS[line] = File.stat(line).mtime.epoch
      }
      File.open(PATH, "w") { |f|
        RECORDS.each { |k, v| f.puts "#{k}|#{v}" }
      }
    end

    def self.ls_files
      DA_Process.output!("git ls-files --cached --others --exclude-standard")
    end

    def self.changed_files
      load_changes
      files = [] of String
      ls_files.each_line { |line|
        if changed?(line, File.stat(line).mtime.epoch)
          files.push(line)
        end
      }
      files
    end

    def self.compile_files
    end

    def self.compile
      return false if !File.exists?(PATH_DO_COMPILE)
      changed_files.each { |f| yield f }
      yield "compile!"
      File.delete(PATH_DO_COMPILE)
      update_log

      true
    end # === def self.watch

  end # === module Log

end # === module My_Git

