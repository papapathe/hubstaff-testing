class OrganizationsController < ApplicationController
  def show
    @organization = Organization.find(params[:id])
    render json: OrganizationSerializer.new(@organization).serialized_json
  end
end
