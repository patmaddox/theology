require 'set'

def experiment(description)
  e = Experiment.new(description)
  yield(e) if block_given?
  e
end

class PrintReporter
  def report
    puts "PrintReporter reporting for duty"
  end
end

class Experiment
  @@available_reporters = {
    "print reporter" => PrintReporter.new
  }

  def initialize(description)
    @description = description
    @reporters = Set.new
  end

  def run
    @reporters.each(&:report)
  end

  def objectives(*names)

  end

  def tactics(*names)

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
