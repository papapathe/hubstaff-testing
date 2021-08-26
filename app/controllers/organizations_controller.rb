# frozen_string_literal: true

# Exposes API for interacting with Organizations.
class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
    render json: OrganizationSerializer.new(@organization).serializable_hash
  end
end
