#!/bin/sh
bf.ss e input_large.asc output_large.enc 1234567890abcdeffedcba0987654321
bf.ss d output_large.enc output_large.asc 1234567890abcdeffedcba0987654321
