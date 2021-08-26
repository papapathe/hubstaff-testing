# frozen_string_literal: true

class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
    render json: OrganizationSerializer.new(@organization).serializable_hash
  end
end
