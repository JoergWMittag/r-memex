require "rubygems"
require "highline"
require "pp"

require "node_container"
require "lastfm_generator"

class Controller
  attr_reader :nc
  
  def initialize
    @nc = NodeContainer.new
  end

  def new_container
    @nc = NodeContainer.new
  end
  
  def load_container(filename)
    @nc = NodeContainer.load(filename)
  end
  
  def save_container(filename)
    @nc.save(filename)
  end
  
  def import_container(username)
    puts username
  end
  
  def add_node(nodename)
    @nc.add_node(nodename)
  end
  
end

class View

  def initialize
    @term = HighLine.new
    @ctrl = Controller.new
    @exit = false
    main
  end  
  
  def browse
    @term.choose do |menu|
      menu.prompt = "Choose a browse command:"
      menu.layout = :one_line
      menu.choice(:back) do main end
      menu.choice(:exit) do @term.say("Bye bye...") end
    end
  end
  
  def edit
    @term.choose do |menu|
      menu.prompt = "Choose a edit command:"
      menu.layout = :one_line
      menu.choice(:add_node) do 
        @ctrl.add_node(@term.ask("Enter Node Name: "))
        edit
      end
      menu.choice(:add_tags) do
        @ctrl.add_tag(nodes, tags)
      end
      menu.choice(:edit_node) do edit end
      menu.choice(:list_nodes) do 
        @term.say(@ctrl.nc.to_s)
        edit 
      end
      menu.choice(:delete_node) do edit end
      menu.choice(:back) do main end
      menu.choice(:exit) do @term.say("Bye bye...") end
    end
  end

  def main
      @term.choose do |menu|
        menu.prompt = "Choose a command:"
        menu.layout = :one_line
        menu.choice(:new) do 
          @term.say("excellent choice") 
          main
        end
        menu.choice(:load) do 
          @ctrl.load_container(@term.ask("Enter Filename: ")) 
          main
        end
        menu.choice(:save) do 
          @ctrl.save_container(@term.ask("Enter desired Filename: "))
          main
        end
        menu.choice(:edit) do 
          @term.say("excellent choice") 
          edit
        end
        menu.choice(:browse) do 
          @term.say("excellent choice") 
          browse
        end
        menu.choice(:import) do
          username = @term.ask("Enter LastFM Username: ")
          @ctrl.import_container(username)
          main
        end
        menu.choice(:exit) do @term.say("Bye bye...") end 
    end
  end
  
  def list_nodes
    
  end

end

begin
  View.new
end