# frozen_string_literal: true

module GraphErrorable
  extend ActiveSupport::Concern

  # Errors we consider safe to bubble up to the user.
  ERROR_ALLOWLIST = [].freeze

  class_methods do
    def rescue_from(error_type)
      super(error_type) do |err, obj, args, ctx, field|
        raise err if (Rails.env.test? || Rails.env.development?) && ctx[:prevent_rescue]

        yield(err, obj, args, ctx, field) if block_given?
      end
    end
  end

  included do
    rescue_from(ActiveRecord::RecordNotFound) do |err, _obj, _args, _ctx, _field|
      id_part = " with #{err.primary_key} \"#{err.id}\"" if err.primary_key.present? && err.id.present?
      raise GraphQL::ExecutionError.new("Couldn't find #{err.model}#{id_part}", extensions: {code: :not_found})
    end

    rescue_from(ActiveRecord::RecordInvalid) do |err, _obj, _args, _ctx, _field|
      raise GraphQL::ExecutionError.new("Validation Error: #{err.record.errors.full_messages.join(", ")}", extensions: {code: :unprocessable_entity})
    end

    rescue_from(ActiveModel::ValidationError) do |err, _obj, _args, _ctx, _field|
      raise GraphQL::ExecutionError.new("Validation Error: #{err.model.errors.full_messages.join(", ")}", extensions: {code: :unprocessable_entity})
    end

    ERROR_ALLOWLIST.each do |error_type|
      rescue_from(error_type) do |err, _obj, _args, _ctx, _field|
        raise GraphQL::ExecutionError.new(err)
      end
    end

    rescue_from(::StandardError) do |err, _obj, _args, _ctx, _field|
      Rails.logger.error err.message
      Rails.logger.error err.backtrace.join("\n")

      Sentry.capture_exception(err)

      raise GraphQL::ExecutionError.new(
        "The server encountered an unexpected condition that prevented it from fulfilling the request",
        extensions: {code: :server_error}
      )
    end
  end
end
