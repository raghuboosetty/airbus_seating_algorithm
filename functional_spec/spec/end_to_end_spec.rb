require 'spec_helper'

RSpec.describe 'End To End Suite', type: :aruba do
  it "has aruba set up" do
    command = run "echo 'hello world'"
    stop_all_commands
    expect(command.output).to eq("hello world\n")
  end

  describe "full scenarios" do
    let(:commands) do
      [
          "[[3,2], [3,4], [2,3]] 21\n"
      ]
    end

    let(:expected) do
      <<-EOTXT
\nSeat Layout: [[3, 2], [3, 4], [2, 3]]
Number of Passengers: 21
[xx xx xx] [xx xx xx] [xx xx] 
[xx xx xx] [xx xx xx] [xx xx] 
           [xx xx xx] [xx xx] 
           [xx xx xx]         
[14 19 01] [02 20 03] [04 15] 
[16 21 05] [06 xx 07] [08 17] 
           [09 xx 10] [11 18] 
           [12 xx 13]         
EOTXT
    end

    it "input from file" do
      command = run("run_seating_airplane #{File.join(File.dirname(__FILE__), '..', 'fixtures', 'file_input.txt')}")
      stop_all_commands
      expect(command.stdout).to eq(expected)
    end

    it "interactive input" do
      command = run("run_seating_airplane")
      commands.each {|cmd| command.write(cmd)}
      stop_all_commands
      expect(command.stdout).to eq(expected)
    end
  end
end