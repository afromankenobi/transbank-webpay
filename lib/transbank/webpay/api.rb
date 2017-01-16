module Transbank
  module Webpay
    class Api
      include Params

      def init_transaction(underscore_params = {})
        puts "Start initTransaction call"
        params = build_init_transaction_params(underscore_params)
        url    = config.wsdl_transaction_url
        resp = Request.new(url, :init_transaction, params).response

        puts "End initTransaction call"

        resp
      end

      def get_transaction_result(token)
        puts "Start getTransactionResult call"

        params = { tokenInput: token }
        url    = config.wsdl_transaction_url

        resp = Request.new(url, :get_transaction_result, params).response
        puts "End getTransactionResult call"
        resp
      end

      def acknowledge_transaction(token)
        puts "Start acknowledgeTransaction call"
        params = { tokenInput: token }
        url    = config.wsdl_transaction_url

        resp = Request.new(url, :acknowledge_transaction, params).response
        puts "End acknowledgeTransaction call"
        resp
      end

      def nullify(underscore_params = {})
        params = build_nullify_params(underscore_params)
        url    = config.wsdl_nullify_url
        Request.new(url, :nullify, params).response
      end

      private

      def config
        Transbank::Webpay.configuration
      end
    end
  end
end
