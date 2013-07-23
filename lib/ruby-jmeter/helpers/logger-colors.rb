require 'logger' 

class Logger
  module Colors
    VERSION = '1.0.0'

    NOTHING      = '0;0'
    BLACK        = '0;30'
    RED          = '0;31'
    GREEN        = '0;32'
    BROWN        = '0;33'
    BLUE         = '0;34'
    PURPLE       = '0;35'
    CYAN         = '0;36'
    LIGHT_GRAY   = '0;37'
    DARK_GRAY    = '1;30'
    LIGHT_RED    = '1;31'
    LIGHT_GREEN  = '1;32'
    YELLOW       = '1;33'
    LIGHT_BLUE   = '1;34'
    LIGHT_PURPLE = '1;35'
    LIGHT_CYAN   = '1;36'
    WHITE        = '1;37'

    SCHEMA = {
      STDOUT => %w[nothing green brown red purple cyan],
      STDERR => %w[nothing green yellow light_red light_purple light_cyan],
    }
  end
end

class Logger
  alias format_message_colorless format_message

  def format_message(level, *args)
    if Logger::Colors::SCHEMA[@logdev.dev]
      color = begin
        Logger::Colors.const_get \
          Logger::Colors::SCHEMA[@logdev.dev][Logger.const_get(level.sub "ANY","UNKNOWN")].to_s.upcase
      rescue NameError
        "0;0"
      end
      "\e[#{ color }m#{ format_message_colorless(level, *args) }\e[0;0m" 
    else
      format_message_colorless(level, *args)
    end
  end
end