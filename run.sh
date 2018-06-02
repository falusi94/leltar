#!/bin/sh

export RAILS_ENV=production
rails runner 'Item.reindex'
rails runner 'Group.reindex'

rails s &>> .log
