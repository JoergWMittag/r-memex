require "rubygems"
require "ncurses"
require "node_container"

class Controller
  attr_accessor :nc, :selected

  
  def initialize
    @nc = NodeContainer.new
    @selected = Array.new
  end
  
  def new_container
    @nc = NodeContainer.new
  end
  
  def add_node(node_str)
    @nc.add_node(node_str)
  end
  
  def add_tag(tag_str)
    selected.each { |node| node.add_tag(tag_str) }
  end
  
  def load(string)
    @nc = NodeContainer.load(string)
  end
  
  def save(string)
    @nc.save(string)
  end
  
  def get_node(str)
    @selected = @nc.nodes.find_all { |node| node.name == str}
  end
end

def get_opt(cmd, out, msg)
  out.addstr(msg)
  out.refresh
  cmd.clear
  cmd.getstr(str="")
  return str
end

def main_command
  
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
        str = get_opt(cmd_window, out_window)
        out_window.mvaddstr(1, 0, str+"\n")
      when "info"
        out_window.mvaddstr(0, 0, "info:\n")
        out_window.mvaddstr(1, 0, ctrl.nc.to_s)
      when "new"
        out_window.mvaddstr(0, 0, "new:\n")
        ctrl.new_container
      when "load"
        out_window.mvaddstr(0, 0, "laod:\n")
        str = get_opt(cmd_window, out_window)
        ctrl.load(str)
      when "save"
        out_window.mvaddstr(0, 0, "save:\n")
        str = get_opt(cmd_window, out_window)
        ctrl.save(str)
      when "add_node"
        out_window.mvaddstr(0, 0, "add_node:\n")
        str = get_opt(cmd_window, out_window, "enter node name!\n")
        ctrl.add_node(str)
        out_window.addstr("node: " + str + " added!")
      when "select_node"
        out_window.mvaddstr(0, 0, "select_nodes:\n")
        name = get_opt(cmd_window, out_window, "enter node name\n")
        result = ctrl.get_node(name)
        if result.size == 0
          out_window.addstr("no nodes selected")
        elsif result.size == 1
          out_window.addstr("one node selected\n" + result[0].to_s)
        else
          out_window.addstr(result.size.to_s + " nodes selectd :\n" + result.to_s + "\n")
        end
      when "add_tag"
        out_window.mvaddstr(0, 0, "tag_node:\n")
        if ctrl.selected.size == 0
          out_window.add_str("no nodes selected\n")
        else
          str = get_opt(cmd_window, out_window, "enter a tag\n")
          ctrl.add_tag(str)
          out_window.addstr("Tag: \"" + str + "\" added to " + ctrl.selected.size.to_s + " selected nodes")
        end
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
