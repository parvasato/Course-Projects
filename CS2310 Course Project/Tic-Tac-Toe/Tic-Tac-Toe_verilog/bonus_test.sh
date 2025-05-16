#!/bin/bash

# Verilog testbench file
inpfile=$1
line=1
flag=0
errors=0

# Define the file path
file="output.txt"

echo -e "\n \n *************************************************** Starting Test Simulations !!! *************************************************** \n \n"

for ((i=1; i<=8; i++))
do
    # Plugging in the above random values in the Verilog file
    sed -i "$line s/.*/ \`define D_WIDTH $i/" $inpfile

    # Running the behavioral simulation
    iverilog $inpfile -o dump.vvp
    vvp dump.vvp > $file

    # Extract passed cases (x1) and total cases (x2)
    x1=$(grep "Number of Test cases passed:" "$file" | awk -F'[( /)]' '{print $3}')
    x2=$(grep "Number of Test cases passed:" "$file" | awk -F'[( /)]' '{print $5}')

    # Convert x1 and x2 to integers
    x1_int=$(echo "$x1" | awk '{print int($1)}')
    x2_int=$(echo "$x2" | awk '{print int($1)}')

    # Compare x1 and x2
    if [ "$x1_int" -ne "$x2_int" ]; then
        echo -e "\n Test case failed for DATA_WIDTH = $i !!! \n"
        flag=1
        errors=errors+1
    fi

    if [ "$flag" -eq 0 ]; then
        echo -e "\n ------------------- Tests passed for DATA_WIDTH = $i !!! ------------------- \n"
    fi
done

if [ "$errors" -eq 0 ]; then
    echo -e "\n \n *************************************************** All tests ( 8 / 8 ) passed !!! *************************************************** \n \n"
else
    echo -e "\n \n **************************************************** Failed ( $errors / 8 ) test cases !!! **************************************************** \n \n"
fi

rm output.txt dump.vvp N_bit_mul.vcd


