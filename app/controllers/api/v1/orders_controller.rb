# frozen_string_literal: true

module Api
  module V1
    class OrdersController < ApplicationController
      def process_file
        return render_missing_file_error unless file_present?

        order_ids = params[:order_ids]&.split(',')&.map(&:to_i)
        start_date = params[:start_date]
        end_date = params[:end_date]

        result = ProcessFileService.call(params[:file], order_ids: order_ids, start_date: start_date, end_date: end_date)

        if result.is_a?(Hash) && result[:error]
          render json: { error: result[:error] }, status: :bad_request
        else
          render json: { 
            message: 'File processed successfully', 
            data: result 
          }, status: :ok
        end
      rescue StandardError => e
        Rails.logger.error "Error processing file: #{e.message}"
        render json: { 
          error: 'Internal server error while processing file' 
        }, status: :internal_server_error
      end

      private

      def file_present?
        params[:file].present?
      end

      def render_missing_file_error
        render json: { 
          error: 'File parameter is required' 
        }, status: :bad_request
      end
    end
  end
end