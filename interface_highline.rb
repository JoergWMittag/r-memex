require "rubygems"
require "highline"
require "pp"

require "node_container"
require "lastfm_generator"

class Controller
  attr_reader :nc, :changed, :selected
  attr_writer :changed, :selected

  
  def initialize
    @nc = NodeContainer.new
    @changed = false
    @selected = Array.new
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
  
  def select_by_tags(tags)
    return @selected = @nc.nodes_by_tag(tagstr_to_array(tags))
  end
  
  def tagstr_to_array(tagstring)
    return tagstring.split(",").collect! {|token| token.strip}
  end
  
end

class View

  attr_writer :term

  def initialize
    @term = HighLine.new
    @ctrl = Controller.new
  end

  def menu_main
      @term.choose do |menu|
        menu.prompt = "Choose a command:"
        menu.layout = :one_line
        menu.choice(:file) do menu_file end
        menu.choice(:select) do menu_select end
        menu.choice(:list) do 
          @term.say(@ctrl.nc.to_s)
          menu_main
        end
        menu.choice(:exit) do exit end 
      end
  end

  def menu_select
    @term.choose do |menu| 
      menu.prompt = "Choose a Selection command:"
      menu.layout = :one_line
      menu.choice(:list) do
        @term.say(@ctrl.selected.to_s)
        menu_select
      end
      menu.choice(:append) do
        menu_select
      end
      menu.choice(:remove) do
        menu_select
      end
      menu.choice(:edit) do
        @ctrl.selected.each {|node| edit_node(node)}
        menu_select
      end
      menu.choice(:back) do menu_main end
      menu.choice(:exit) do exit end
    end
  end

  def menu_file
    @term.choose do |menu|
      menu.prompt = "Choose a File command:"
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
      menu.choice(:import) do
        username = @term.ask("Enter LastFM Username: ")
        @ctrl.import_container(username)
        menu_main
      end
      menu.choice(:back) do menu_main end
      menu.choice(:exit) do exit end 
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

  def menu_edit(node)
    @term.say("Editing Node: %s" % node.name)
    @term.chose do |menu|
      menu.layout = :one_line
      menu.choice(:name) do end
      menu.choice(:location) do end
      menu.choice(:tag) do end
      menu.choicd(:delete) do end
    end
  end

end

begin
  if __FILE__ == $0
    view = View.new
    view.menu_main
  end
end