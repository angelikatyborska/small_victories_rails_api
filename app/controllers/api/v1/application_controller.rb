class Api::V1::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found
    api_error(status: 404, errors: 'Not found.')
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end

    if errors.empty?
      head status: status
    else
      errors_json =
        if errors.is_a? String
          { errors: [errors] }
        else
          ActiveModel::ArraySerializer.new(errors, root: 'errors').to_json
        end

      render json: errors_json, status: status
    end
  end
end
