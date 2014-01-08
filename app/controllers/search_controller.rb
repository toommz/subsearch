class SearchController < ApplicationController
  def index
  end

  def search
    hash, size = VideoHasher.compute_hash(params[:hidden_data])

    options = {
      'moviehash' => hash,
      'moviebytesize' => size.to_s
    }

    osdb_client = OsdbClient.new
    @subs = osdb_client.search_subs(options)

    respond_to do |format|
      format.js
    end
  end
end
