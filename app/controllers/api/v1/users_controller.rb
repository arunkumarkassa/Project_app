class Api::V1::UsersController < ApplicationController
  def signup
    @user = User.new(user_params)
    if @user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def signin
    if params_present_and_valid?
      @user = find_user_by_credentials(params[:email], params[:country_code], params[:mobile_number])
      if @user.present? && @user.authenticate(params[:password])
        jwt_token = generate_jwt_token(@user.id)
        render json: { success: true, user: user_info(@user).merge(token: jwt_token) }, status: :ok
      elsif @user.present?
        render json: { success: false, error: "Incorrect password" }, status: :unauthorized
      else
        render json: { success: false, error: "No user found" }, status: :not_found
      end
    else
      render json: { success: false, error: "Fields are empty or invalid" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :full_name, :country_code, :mobile_number, :terms_and_conditions)
  end

  def params_present_and_valid?
    params[:password].present? && (params[:mobile_number].present? && params[:country_code].present? || params[:email].present?)
  end

  def find_user_by_credentials(email, country_code, mobile_number)
    if email.present?
      User.find_by(email: email)
    elsif country_code.present? && mobile_number.present?
      User.find_by(country_code: country_code, mobile_number: mobile_number)
    end
  end

  def generate_jwt_token(user_id)
    secret_key = Rails.application.credentials.secret_key_base
    JWT.encode({ user_id: user_id }, secret_key)
  end

  def user_info(user)
    {
      full_name: user.full_name,
      email: user.email,
      country_code: user.country_code,
      mobile_number: user.mobile_number
    }
  end
end
