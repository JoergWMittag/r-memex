require "rubygems"
require "ncurses"
require "node_container"

class Controller
  attr_reader :nc
  attr_writer :nc
  
  def initialize
    @nc = NodeContainer.new
  end
  
  def new_container
    @nc = NodeContainer.new
  end
  
  def add_node(node_str)
    @nc.add_node(node_str)
  end
  
  def load
    @nc = NodeContainer.load("save.bin")
  end
  
  def save
    @nc.save("save.bin")
  end
  
  
end

begin
  Ncurses.initscr
  Ncurses.cbreak                  # provide unbuffered input
  Ncurses.nonl                    # turn off newline translation
  Ncurses.stdscr.intrflush(false) # turn off flush-on-interrupt
  Ncurses.stdscr.keypad(true)     # turn on keypad mode
  cmd_window = Ncurses::WINDOW.new(1, Ncurses.COLS, Ncurses.LINES-1, 0)
  out_window = Ncurses::WINDOW.new(Ncurses.LINES-1, Ncurses.COLS, 0, 0)
  
  ctrl = Controller.new
  
  while(true)
    out_window.clear
    cmd_window.mvaddstr(0, 0, ":")
    cmd_window.clrtoeol
    cmd_window.getstr(command="")
    case(command)
      when "help"
        out_window.mvaddstr(0, 0, "help:\n")
      when "info"
        out_window.mvaddstr(0, 0, "info:\n")
        out_window.mvaddstr(1, 0, ctrl.nc.to_s)
      when "new"
        out_window.mvaddstr(0, 0, "new:\n")
        ctrl.new_container
      when "load"
        out_window.mvaddstr(0, 0, "laod:\n")
        ctrl.load
      when "save"
        out_window.mvaddstr(0, 0, "save:\n")
        ctrl.save
      when "exit"
        out_window.mvaddstr(0, 0, "exit:\n")
        break
      else
        out_window.mvaddstr(0, 0, "usage:\n")
      end
      out_window.refresh
  end
  
ensure
    Ncurses.echo
    Ncurses.nocbreak
    Ncurses.nl
    Ncurses.endwin
end
