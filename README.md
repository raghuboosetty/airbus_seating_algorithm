## Setup

First, install [Ruby](https://www.ruby-lang.org/en/documentation/installation/). 

Then run the following commands under the `airplane-seating-algorithm` dir.

```
$ ruby -v # confirm ruby version | ruby 2.5.1
$ gem install bundler # install bundler to manage dependencies
$ bin/setup

```

## Usage

You can run the program from `airplane-seating-algorithem` by giving 2 types of input: 
1. File as input 
2. Command line input

The format of it should be:<br/>
A 2D Array of seat layout in cols and row, followed by a space and total number of passengers<br/>
e.g: [[3,2], [3,4], [2,3]] 21

### File as input
```
# please add inputs with a new line seperator to the file_input.txt in root directory or pass any other file having input in similar format

$ bin/run_seating_airplane file_input.txt

```
### Command line input
```
# run the same command without file params will wait for command line input.
# please add inputs with a new line seperator in the format of example shown below
# hit 'q' to exit the program

$ bin/run_seating_airplane
$ [[3,2], [3,4], [2,3]] 21
$ q
```

## Functional Test

A fully functional test suite has beed added under `airplane-seating-algorithm/functional_spec` dir. You can run the full test suite from `airplane-seating-algorithm` dir by running
```
$ bin/run_functional_specs
```

## Algorithm Logic
1. Create empty seating layout in 3D array based on given 2D array. The 3rd dimension points to the number of the block. The 3D array has a structure like: [block_number, row_number, column_number]
2. Group Asile, Window and Center seats under each block based on given 2D array. The grouped seats are in 3D array format that holds the exact index of the seat in the structure mentioned in point 1.
3. Sort each of Asile, Window and Center seats from left to right and top to bottom
4. Combine all seats to form a ordered 3D array having the indexes of seating position
5. Allot the seats created in step 1 to passengers based on 3D positions created in step 4
6. Print the layout in the given format