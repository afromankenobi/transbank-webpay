module Transbank
  module Webpay
    class Request
      attr_accessor :client, :document, :action, :params

      def initialize(wsdl_url, action, params = {})
        @params = params
        @action = action
        @document = Document.new(action, params)
        @client = Client.new wsdl_url

        Rails.logger.debug 'Request'
        Rails.logger.debug Hash.from_xml(document.unsigned_xml)["Envelope"]["Body"]
        Rails.logger.debug '---------------------'
      end

      def response
        rescue_exceptions = Transbank::Webpay.configuration.rescue_exceptions

        @response ||= begin
          Response.new client.post(document.to_xml), action, params
        rescue match_class(rescue_exceptions) => error
          ExceptionResponse.new error, action, params
        end
      end

      private

      def match_class(exceptions)
        m = Module.new
        (class << m; self; end).instance_eval do
          define_method(:===) do |error|
            (exceptions || []).include? error.class
          end
        end
        m
      end
    end
  end
end
