# frozen_string_literal: true

module Api
  module V1
    class OrdersController < ApplicationController
      def process_file
        return render_missing_file_error unless file_present?

        result = ProcessFileService.call(params[:file])

        if result[:error]
          render json: result, status: :bad_request
        else
          render json: result
        end
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
