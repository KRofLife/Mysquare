class UsersController < ApplicationController
  before_action :ensure_current_user, {only: [:edit, :update]}
  def show
    @user = User.find(params[:id])
    @deck_square = DeckSquare.where(user_id: @user)
    @deck_recipe = DeckRecipe.find_by(user_id: @user)
    @deck_squares = @user.deck_squares.includes([:square])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def favorites
    @user = User.find_by(id: params[:id])
    @favorites = Favorite.where(user_id: @user.id).page(params[:page]).reverse_order
  end

  def squares
    @user = User.find_by(id: params[:id])
    @squares = Square.where(user_id: @user.id).page(params[:page]).reverse_order
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
