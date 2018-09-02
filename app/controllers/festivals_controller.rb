# frozen_string_literal: true

class FestivalsController < ApplicationController
  def show; end

  private

  def festival
    FestivalPresenter.new(super)
  end
end
