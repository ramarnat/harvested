module Harvest
  module API
    class Reports < Base

      def time_by_project(project, start_date, end_date, options = {})
        query = {:from => start_date.strftime("%Y%m%d"), :to => end_date.strftime("%Y%m%d")}
        query[:user_id] = options[:user].to_i if options[:user]
        query[:billable] = (options[:billable] ? "yes" : "no") unless options[:billable].nil?

        response = request(:get, credentials, "/projects/#{project.to_i}/entries", :query => query)
        Harvest::TimeEntry.parse(JSON.parse(response.body).map {|h| h["day_entry"]})
      end

      def time_by_user(user, start_date, end_date, options = {})
        query = {:from => start_date.strftime("%Y%m%d"), :to => end_date.strftime("%Y%m%d")}
        query[:project_id] = options[:project].to_i if options[:project]
        query[:billable] = (options[:billable] ? "yes" : "no") unless options[:billable].nil?

        response = request(:get, credentials, "/people/#{user.to_i}/entries", :query => query)
        Harvest::TimeEntry.parse(JSON.parse(response.body).map {|h| h["day_entry"]})
      end

      def expenses_by_user(user, start_date, end_date, options = {})
        start_date = ::Time.parse(start_date) if String === start_date
        end_date = ::Time.parse(end_date) if String === end_date
        updated_since = ::Time.parse(options[:updated_since]) if String === options[:updated_since]

        query = {:from => start_date.strftime("%Y%m%d"), :to => end_date.strftime("%Y%m%d")}
        query[:updated_since] = updated_since.strftime("%Y%m%d") unless options[:updated_since].nil?
        response = request(:get, credentials, "/people/#{user.to_i}/expenses", :query => query)
        Harvest::Expense.parse(response.parsed_response)
      end

      def expenses_by_project(project, start_date, end_date, options = {})
        start_date = ::Time.parse(start_date) if String === start_date
        end_date = ::Time.parse(end_date) if String === end_date
        updated_since = ::Time.parse(options[:updated_since]) if String === options[:updated_since]

        query = {:from => start_date.strftime("%Y%m%d"), :to => end_date.strftime("%Y%m%d")}
        query[:updated_since] = updated_since.strftime("%Y%m%d") unless options[:updated_since].nil?
        response = request(:get, credentials, "/projects/#{project.to_i}/expenses", :query => query)
        Harvest::Expense.parse(response.parsed_response)
      end


      def projects_by_client(client)
        response = request(:get, credentials, "/projects?client=#{client.to_i}")
        Harvest::Project.parse(response.parsed_response)
      end
    end
  end
end
