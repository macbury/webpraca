#!/usr/bin/env bash

git push origin deploy

export branch=deploy

env DEPLOY='production' cap deploy
env DEPLOY='production' cap deploy:migrate
cap deploy:cleanup