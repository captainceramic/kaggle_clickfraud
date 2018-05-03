#!/usr/bin/env bash

# Set up the data preprocessing

# Full train
echo "processing training data..."
./process_ffm_train.awk < data/train.csv > train.libffm

# Testing
echo "processing testing data..."
./process_ffm_test.awk < data/test.csv > test.libffm
