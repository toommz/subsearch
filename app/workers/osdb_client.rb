require 'xmlrpc/client'

class OsdbClient
  def initialize
    @server = create_server
    @token = get_token
  end

  def search_subs(options = {})
    begin
      res = @server.call('SearchSubtitles', @token, [ options ])
      log_out
      res
    rescue XMLRPC::FaultException
      "An Error occured while communicating with OSDB server."
    end
  end

  private
  def create_server
    server = XMLRPC::Client.new('api.opensubtitles.org', '/xml-rpc')
    server.http_header_extra = {'accept-encoding' => 'gzip'}
    server.set_parser ZlibParserDecorator.new(server.send(:parser))
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

class ZlibParserDecorator
  def initialize(parser)
    @parser = parser
  end

  def parseMethodResponse(responseText)
    @parser.parseMethodResponse(Zlib::GzipReader.new(StringIO.new(responseText)).read)
  end

  def parseMethodCall(*args)
    @parser.parseMethodCall(*args)
  end
end
