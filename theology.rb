require 'set'

def experiment(description)
  e = Experiment.new(description)
  yield(e) if block_given?
  e
end

class Experiment
  @@available_reporters = {
    "print reporter" => lambda { puts "reporting for duty" }
  }

  @@available_tactics = {
    "create /tmp/experiment" => lambda { puts "creating /tmp/experiment" },
    "delete /tmp/experiment" => lambda { puts "deleting /tmp/experiment" }
  }

  @@available_objectives = {
    "create a file" => lambda { puts "define: create a file" },
    "delete a file" => lambda { puts "define: delete a file" }
  }

  def initialize(description)
    @description = description
    @reporters = Set.new
    @tactics = Set.new
    @objectives = Set.new
  end

  def run
    @objectives.each(&:call)
    @tactics.each(&:call)
    @reporters.each(&:call)
  end

  def objectives(*names)
    names.each {|n| @objectives.add @@available_objectives.fetch(n) }
  end

  def tactics(*names)
    names.each {|n| @tactics.add @@available_tactics.fetch(n) }
  end

  def reporters(*names)
    names.each {|n| @reporters.add @@available_reporters.fetch(n) }
  end
end

experiment "create and delete a file" do |e|
  e.objectives "create a file", "delete a file"
  e.tactics "create /tmp/experiment", "delete /tmp/experiment"
  e.reporters "print reporter"
  e.run
end
