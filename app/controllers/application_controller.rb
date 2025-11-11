require "securerandom"

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :attach_cart_to_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_navigation_categories

  helper_method :current_cart

  private

  def current_cart
    @current_cart ||= begin
      cart = Cart.find_by(id: session[:cart_id]) if session[:cart_id].present?
      cart ||= Cart.create!(token: SecureRandom.uuid)
      session[:cart_id] = cart.id
      cart
    end
  end

  def attach_cart_to_user
    return unless user_signed_in?
    current_cart.update(user: current_user) if current_cart.user_id.blank?
  end

  def configure_permitted_parameters
    extra_params = %i[first_name last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_params)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_params)
  end

  def load_navigation_categories
    @navigation_categories = Category.order(:name).limit(12)
  rescue ActiveRecord::StatementInvalid
    @navigation_categories = []
  end
end
