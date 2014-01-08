class SearchController < ApplicationController
  def index
  end

  def search
    @hash = VideoHasher.compute_hash(params[:hidden_data])
    respond_to do |format|
      format.js
    end
  end
end
