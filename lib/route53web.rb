require 'sinatra/base'
require 'sinatra/reloader'
require 'route53'

module Route53
  class Web < Sinatra::Base
    class << self
      attr_accessor :config
    end

    use Rack::Logger
    register Sinatra::Reloader if development?

    dir = File.dirname(File.expand_path(__FILE__))
    File.open('/tmp/wtf','w').write("dir: #{dir}")
    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    set :static, true
    set :logging, true

    RECORD_TYPES = %w(
      A/AAAA
      CNAME
      NS
      MX
      TXT
      SOA
    )
    #  SOA
    #  SRV
    #)

    helpers do
      def config
        self.class.config
      end
      def logger
        request.logger
      end
      def z( name )
        z = @zones.find { |z| z.name == name }
        raise "No such zone: #{name}" unless z
        z
      end
      def r( zone, record_type )
        record_type = record_type.gsub('|', '/')
        zone.get_records.select { |r| record_type.split('/').include?(r.type) }
      end
      def url_path( *path_parts )
        [path_prefix, path_parts].join('/').squeeze('/')
      end

      def path_prefix
        request.env['SCRIPT_NAME']
      end
    end

    before do
      @route53 = Route53::Connection.new( config[:access], config[:secret] )
      @zones = @route53.get_zones
    end

    get '/' do
      haml :index
    end

    get '/zone/:zone' do
      session[:zone] = params[:zone]
      {
        :ok => true,
        :zone => haml(
          :_zone,
          :locals => {
            :zone => z( params[:zone] )
          }
        )
      }.to_json
    end

    get '/zone/:zone/records/:kind' do
      records = r( z( params[:zone] ), params[:kind] )
      {
        :ok => true,
        :records => haml(
          :"records/_#{records.first.type.downcase}",
          :locals => {
            :records => records
          }
        )
      }.to_json
    end
  end
end
