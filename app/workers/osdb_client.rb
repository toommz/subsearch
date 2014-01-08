require 'xmlrpc/client'

class OsdbClient
  def initialize
    @server = create_server
    @token = get_token
  end

  def search_subs(options = {})
    res = @server.call('SearchSubtitles', @token, [ options ])
    log_out
    res
  end

  private
  def create_server
    server = XMLRPC::Client.new('api.opensubtitles.org', '/xml-rpc')
    server.http_header_extra = {'accept-encoding' => 'identity'}
    server
  end

  def get_token
    res = @server.call('LogIn', '', '', '', 'OS Test User Agent')
    res['token']
  end

  def log_out
    @server.call('LogOut', @token)
  end
end
