module Harvest
  module API
    class Invoices < Base
      api_model Harvest::Invoice
      include Harvest::Behavior::Crud
      
      def all(user = nil)
        query = {:page => 1}
        response = request(:get, credentials, api_model.api_path, :query => query)
        invoices = api_model.parse(response.parsed_response)
        get_more(invoices, query)
      end

      def time(start_date, end_date = ::Time.now)
        start_date = ::Time.parse(start_date) if String === start_date
        end_date = ::Time.parse(end_date) if String === end_date
        query = {:from => start_date.strftime("%Y%m%d"), :to => end_date.strftime("%Y%m%d"), :page => 1}
        response = request(:get, credentials, api_model.api_path, :query => query)
        invoices = api_model.parse(response.parsed_response)
        get_more(invoices, query)
      end
      
      def create(*)
        raise "Creating and updating invoices are not implemented due to API issues"
      end
      
      def update(*)
        raise "Creating and updating invoices are not implemented due to API issues"
      end
      
      def get_more(invoices, query)
        more_invoices = HARVEST_ITEMS_PER_PAGE
        until invoices.size < more_invoices do
            query[:page] = query[:page]+1
            more_invoices = more_invoices+HARVEST_ITEMS_PER_PAGE
	        response = request(:get, credentials, api_model.api_path, :query => query)
	        invoices.concat(api_model.parse(response.parsed_response))
	    end
	    return invoices
	  end      
      private :get_more

    end
  end
end