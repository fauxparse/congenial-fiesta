# frozen_string_literal: true

class ProfilesController < ApplicationController
  authenticate except: %i[new create]

  def show; end

  def update
    current_participant.update_attributes(attributes)
    render :show
  end

  def connect
    if current_participant.identities.where(provider: provider).exists?
      redirect_to profile_path
    else
      session[:redirect] = profile_path
      redirect_to "/auth/#{params[:provider]}"
    end
  end

  def disconnect
    current_participant.identities.find_by(provider: provider)&.destroy \
      if current_participant.identities.many?
    redirect_to profile_path
  end

  private

  def provider
    params[:provider]
  end

  def attributes
    params.require(:participant).permit(:name, :email)
  end
end
