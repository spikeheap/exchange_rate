# frozen_string_literal: true

# ActiveRecord-style migrations
Sequel.extension :migration

# Add helpers for when we're not sure if a record exists or not
Sequel::Model.plugin :update_or_create

# Adds ActiveRecord-style #validates_presence helpers
Sequel::Model.plugin :validation_helpers
