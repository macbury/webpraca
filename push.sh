#!/usr/bin/env bash

git push origin master

export branch=master

env DEPLOY='production' cap deploy
env DEPLOY='production' cap deploy:migrate
cap deploy:cleanup