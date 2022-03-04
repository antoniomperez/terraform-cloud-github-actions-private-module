#!/bin/sh -l

echo "Starting publih a module in $1 Terraform organization"
time=$(date)
echo "::set-output name=time::$time"