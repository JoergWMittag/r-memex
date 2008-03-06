require "rubygems"
require "ncurses"
require "node_container"

nc = nil

def help
  
end

def usage
  
end

def info
  
end

def load
  
end

def save
  
end

def new
  nc = NodeContainer.new
end

begin
  Ncurses.initscr
  Ncurses.cbreak                  # provide unbuffered input
  Ncurses.nonl                    # turn off newline translation
  Ncurses.stdscr.intrflush(false) # turn off flush-on-interrupt
  Ncurses.stdscr.keypad(true)     # turn on keypad mode
  cmd_window = Ncurses::WINDOW.new(1, Ncurses.COLS, Ncurses.LINES-1, 0)
  out_window = Ncurses::WINDOW.new(Ncurses.LINES-1, Ncurses.COLS, 0, 0)
  while(true)
    out_window.refresh
    cmd_window.mvaddstr(0, 0, ":")
    cmd_window.clrtoeol
    cmd_window.getstr(command="")
    case(command)
      when "help"
        out_window.mvaddstr(0, 0, "help\n")
      when "info"
        out_window.mvaddstr(0, 0, "info\n")
      when "new"
        out_window.mvaddstr(0, 0, "new\n")
      when "load"
        out_window.mvaddstr(0, 0, "laod\n")
      when "save"
        out_window.mvaddstr(0, 0, "save\n")
      when "exit"
        out_window.mvaddstr(0, 0, "exit\n")
        break
      else
        out_window.mvaddstr(0, 0, "usage\n")
      end
      out_window.refresh
  end
  
ensure
    Ncurses.echo
    Ncurses.nocbreak
    Ncurses.nl
    Ncurses.endwin
end
