#!/bin/bash

sudo docker build -t test . && sudo docker run --rm -it test bash
