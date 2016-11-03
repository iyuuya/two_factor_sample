class Users::SessionsController < Devise::SessionsController
  # ID/PASSの認証も、認証コードの認証も :create アクションでやってくる
  # Deviseの通常認証処理が行われる前に処理を挟む
  prepend_before_action :authenticate_with_two_factor, only: [:create]

  private
  def authenticate_with_two_factor
    # strong parameters
    user_params = params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)

    # ID/PASSの認証時はemailからユーザーを取得
    if user_params[:email]
      user = User.find_by(email: user_params[:email])

    # 認証コードの認証時はセッションに保存されたIDからユーザーを取得
    elsif user_params[:otp_attempt].present? && session[:otp_user_id]
      user = User.find(session[:otp_user_id])
    end
    self.resource = user

    # 2段階認証が有効なユーザーでなければ、returnして通常のDeviseの認証処理に渡す
    return unless user && user.otp_required_for_login

    # ID/PASSの認証時
    if user_params[:email]
      # パスワードを確認
      if user.valid_password?(user_params[:password])
        # ユーザーIDをセッションに保存して、認証コード入力画面をレンダリング
        session[:otp_user_id] = user.id
        render :two_factor and return
      end
      # パスワードが違っていた場合は通常のDevise認証処理に渡す

    # 認証コードの認証時
    elsif user_params[:otp_attempt].present? && session[:otp_user_id]
      # 認証コードが合っているか確認
      if user.validate_and_consume_otp!(user_params[:otp_attempt])
        # セッションのユーザーIDを削除して、サインイン
        session.delete(:otp_user_id)
        # 認証済みのユーザーのサインインをするDeviseのメソッド
        sign_in(user) and return
      else
        # 認証コード入力画面を再度レンダリング
        flash.now[:alert] = 'Invalid two-factor code.'
        render :two_factor and return
      end
    end
  end
end
