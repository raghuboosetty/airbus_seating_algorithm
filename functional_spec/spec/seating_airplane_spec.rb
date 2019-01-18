require "spec_helper"

RSpec.describe "SeatingAirplane", type: :aruba do

  describe "initialize" do
    context "given correct input params" do
      it "returns new seating airplane instance" do
        airplane = SeatingAirplane.new([[3,2], [3,4], [2,3]], 21)
        expect(airplane.seat_layout).to eql([[3,2], [3,4], [2,3]])
        expect(airplane.number_of_passengers).to eql(21)
        expect(airplane.seat_layout_with_passengers).to eql([[["xx", "xx", "xx"], ["xx", "xx", "xx"]], [["xx", "xx", "xx"], ["xx", "xx", "xx"], ["xx", "xx", "xx"], ["xx", "xx", "xx"]], [["xx", "xx"], ["xx", "xx"], ["xx", "xx"]]])
        expect(airplane.seat_types).to eql({:asile=>[], :window=>[], :center=>[]})
      end
    end

    context "given no input params" do
      it "throws missing argument exception" do
        expect { SeatingAirplane.new }.to raise_error(ArgumentError)
      end
    end
  end

  describe "group_seat_types" do
    let(:airplane) { SeatingAirplane.new([[3,2], [3,4], [2,3]], 21) }
    context "given correct initialize params" do
      it "groups seat types for each block" do
        airplane.group_seat_types
        expect(airplane.seat_types[:asile]).to_not be_empty
        expect(airplane.seat_types[:window]).to_not be_empty
        expect(airplane.seat_types[:center]).to_not be_empty

        expect(airplane.seat_types[:asile].count).to eql(13)
        expect(airplane.seat_types[:window].count).to eql(5)
        expect(airplane.seat_types[:center].count).to eql(6)

        expect(airplane.seat_types[:asile]).to eql([[0, 0, 2], [0, 1, 2], [1, 0, 0], [1, 0, 2], [1, 1, 0], [1, 1, 2], [1, 2, 0], [1, 2, 2], [1, 3, 0], [1, 3, 2], [2, 0, 0], [2, 1, 0], [2, 2, 0]])
        expect(airplane.seat_types[:window]).to eql([[0, 0, 0], [0, 1, 0], [2, 0, 1], [2, 1, 1], [2, 2, 1]])
        expect(airplane.seat_types[:center]).to eql([[0, 0, 1], [0, 1, 1], [1, 0, 1], [1, 1, 1], [1, 2, 1], [1, 3, 1]])
      end
    end
  end

  describe "sort_seats" do
  let(:airplane) { SeatingAirplane.new([[3,2], [3,4], [2,3]], 21) }
    context "given correct input params" do
      it "sort the seat type from left to right and top to bottom on seat indexes" do
        airplane.group_seat_types
        expect(airplane.sort_seats(airplane.seat_types[:asile])).to eql([[0, 0, 2], [1, 0, 0], [1, 0, 2], [2, 0, 0], [0, 1, 2], [1, 1, 0], [1, 1, 2], [2, 1, 0], [1, 2, 0], [1, 2, 2], [2, 2, 0], [1, 3, 0], [1, 3, 2]])
        expect(airplane.sort_seats(airplane.seat_types[:window])).to eql([[0, 0, 0], [2, 0, 1], [0, 1, 0], [2, 1, 1], [2, 2, 1]])
        expect(airplane.sort_seats(airplane.seat_types[:center])).to eql([[0, 0, 1], [1, 0, 1], [0, 1, 1], [1, 1, 1], [1, 2, 1], [1, 3, 1]])
      end
    end
  end

  describe "allot!" do
    let(:airplane) { SeatingAirplane.new([[3,2], [3,4], [2,3]], 21) }
    context "given correct input params" do
      it "should allot passengers to the seats in the order of asile, window and center" do
        airplane.allot!
        expect(airplane.seat_layout_with_passengers).to_not be_empty
        expect(airplane.seat_layout_with_passengers).to eql([[["14", "19", "01"], ["16", "21", "05"]], [["02", "20", "03"], ["06", "xx", "07"], ["09", "xx", "10"], ["12", "xx", "13"]], [["04", "15"], ["08", "17"], ["11", "18"]]])
      end
    end
  end

  describe "print_layout" do
    let(:airplane) { SeatingAirplane.new([[3,2], [3,4], [2,3]], 21) }
    let(:expected_before) do
      <<-EOTXT
\nSeat Layout: [[3, 2], [3, 4], [2, 3]]
Number of Passengers: 21
[xx xx xx] [xx xx xx] [xx xx] 
[xx xx xx] [xx xx xx] [xx xx] 
           [xx xx xx] [xx xx] 
           [xx xx xx]         
EOTXT
    end
    let(:expected_after) do
      <<-EOTXT
[14 19 01] [02 20 03] [04 15] 
[16 21 05] [06 xx 07] [08 17] 
           [09 xx 10] [11 18] 
           [12 xx 13]         
EOTXT
    end    
    context "given correct input params" do
      it "should print layout of seating" do
        expect do
          airplane.print_layout
        end.to output(expected_before).to_stdout
        
        airplane.allot!

        expect do
          airplane.print_layout
        end.to output(expected_after).to_stdout
      end
    end
  end
end
