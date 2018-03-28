# frozen_string_literal: true

class PitchesController < ApplicationController
  authenticate except: :new

  def index; end
end
