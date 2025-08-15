#!/bin/bash
# Simple Interest Calculator
# This script calculates simple interest based on principal, rate, and time
#
# Formula: Simple Interest = (Principal * Rate * Time) / 100
#
# Author: Coursera Learning Project
# Date: $(date '+%Y-%m-%d')
# License: Apache 2.0

# Function to display usage information
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Calculate simple interest based on principal, rate, and time"
    echo ""
    echo "Options:"
    echo "  -p, --principal AMOUNT    Principal amount (required)"
    echo "  -r, --rate RATE          Annual interest rate in percentage (required)"
    echo "  -t, --time TIME          Time period in years (required)"
    echo "  -h, --help              Display this help message"
    echo ""
    echo "Example:"
    echo "  $0 -p 1000 -r 5 -t 2"
    echo "  $0 --principal 1500 --rate 3.5 --time 3"
}

# Function to validate numeric input
is_number() {
    local input=$1
    if [[ $input =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to calculate simple interest
calculate_simple_interest() {
    local principal=$1
    local rate=$2
    local time=$3
    
    # Calculate simple interest: (P * R * T) / 100
    local interest=$(echo "scale=2; ($principal * $rate * $time) / 100" | bc -l)
    local total_amount=$(echo "scale=2; $principal + $interest" | bc -l)
    
    echo "========================================"
    echo "         SIMPLE INTEREST CALCULATOR"
    echo "========================================"
    echo "Principal Amount: \$$principal"
    echo "Interest Rate:    $rate% per annum"
    echo "Time Period:      $time years"
    echo "----------------------------------------"
    echo "Simple Interest:  \$$interest"
    echo "Total Amount:     \$$total_amount"
    echo "========================================"
}

# Initialize variables
PRINCIPAL=""
RATE=""
TIME=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--principal)
            PRINCIPAL="$2"
            shift 2
            ;;
        -r|--rate)
            RATE="$2"
            shift 2
            ;;
        -t|--time)
            TIME="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if bc (basic calculator) is available
if ! command -v bc &> /dev/null; then
    echo "Error: 'bc' command is required but not installed."
    echo "Please install bc using: sudo apt-get install bc (on Ubuntu/Debian)"
    echo "                       or: sudo yum install bc (on CentOS/RHEL)"
    exit 1
fi

# Interactive mode if no arguments provided
if [[ -z "$PRINCIPAL" && -z "$RATE" && -z "$TIME" ]]; then
    echo "Simple Interest Calculator - Interactive Mode"
    echo "============================================="
    
    # Get principal amount
    while true; do
        read -p "Enter principal amount: $" PRINCIPAL
        if is_number "$PRINCIPAL" && (( $(echo "$PRINCIPAL > 0" | bc -l) )); then
            break
        else
            echo "Error: Please enter a valid positive number for principal amount."
        fi
    done
    
    # Get interest rate
    while true; do
        read -p "Enter annual interest rate (%): " RATE
        if is_number "$RATE" && (( $(echo "$RATE >= 0" | bc -l) )); then
            break
        else
            echo "Error: Please enter a valid non-negative number for interest rate."
        fi
    done
    
    # Get time period
    while true; do
        read -p "Enter time period (years): " TIME
        if is_number "$TIME" && (( $(echo "$TIME > 0" | bc -l) )); then
            break
        else
            echo "Error: Please enter a valid positive number for time period."
        fi
    done
fi

# Validate required parameters
if [[ -z "$PRINCIPAL" || -z "$RATE" || -z "$TIME" ]]; then
    echo "Error: All parameters (principal, rate, time) are required."
    show_usage
    exit 1
fi

# Validate parameter values
if ! is_number "$PRINCIPAL" || (( $(echo "$PRINCIPAL <= 0" | bc -l) )); then
    echo "Error: Principal amount must be a positive number."
    exit 1
fi

if ! is_number "$RATE" || (( $(echo "$RATE < 0" | bc -l) )); then
    echo "Error: Interest rate must be a non-negative number."
    exit 1
fi

if ! is_number "$TIME" || (( $(echo "$TIME <= 0" | bc -l) )); then
    echo "Error: Time period must be a positive number."
    exit 1
fi

# Calculate and display the result
calculate_simple_interest "$PRINCIPAL" "$RATE" "$TIME"

# Exit successfully
exit 0
