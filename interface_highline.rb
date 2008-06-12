require "rubygems"
require "highline"
require "pp"

require "node_container"
require "lastfm_generator"

class Controller
  attr_reader :nc, :changed
  attr_writer :changed
  
  def initialize
    @nc = NodeContainer.new
    @changed = false
  end

  def new_container
    @nc = NodeContainer.new
    @changed = false
  end
  
  def load_container(filename)
    @nc = NodeContainer.load(filename)
    @changed = false
  end
  
  def save_container(filename)
    @nc.save(filename)
    @changed = false
  end
  
  def import_container(username)
    puts username
  end
  
  def add_node(nodename)
    @changed = true
    @nc.add_node(nodename)
  end
  
  def add_tag(nodename, tagname)
    @nc.nodes_by_name(nodename).collect {|node| node.add_tag(tagname)}
  end
  
end

class View

  def initialize
    @term = HighLine.new
    @ctrl = Controller.new
    @exit = false
    menu_main
  end  
  
  def menu_edit
    @term.choose do |menu|
      menu.prompt = "Choose a edit command:"
      menu.layout = :one_line
      menu.choice(:add_node) do 
        @ctrl.add_node(@term.ask("Enter Node Name: "))
        menu_edit
      end
      menu.choice(:add_tag) do
        @ctrl.add_tag(@term.ask("Enter Node Name: "), @term.ask("Enter Tag: "))
        menu_edit
      end
      #menu.choice(:edit_node) do menu_edit end
      menu.choice(:list_node) do 
        @term.say(@ctrl.nc.to_s)
        menu_edit 
      end
      #menu.choice(:delete_node) do menu_edit end
      menu.choice(:back) do menu_main end
      menu.choice(:exit) do exit end
    end
  end

  def menu_main
      @term.choose do |menu|
        menu.prompt = "Choose a command:"
        menu.layout = :one_line
        menu.choice(:new) do 
          @ctrl.new_container
          @term.say("new empty file") 
          menu_main
        end
        menu.choice(:load) do 
          @ctrl.load_container(@term.ask("Enter Filename: "))
          menu_main
        end
        menu.choice(:save) do 
          save
          menu_main
        end
        menu.choice(:edit) do 
          menu_edit
        end
        menu.choice(:import) do
          username = @term.ask("Enter LastFM Username: ")
          @ctrl.import_container(username)
          menu_main
        end
        menu.choice(:exit) do
          exit
        end 
    end
  end
  
  def save
    @ctrl.save_container(@term.ask("Enter desired Filename: "))
  end
    
  def exit
    if @ctrl.changed
        if @term.ask("file changed. do you wanna save it?")
            save
        end
    end
    @term.say("Bye bye...")
  end

end

begin
  View.new
end