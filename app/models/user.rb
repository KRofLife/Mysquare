class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :squares, dependent: :destroy
  has_many :deck_squares, -> { order(position: :asc) }
  has_many :favorites, dependent: :destroy
  has_many :square_comments, dependent: :destroy
  has_many :deck_recipes, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followings, through: :relationships, source: :followed

  attachment :profile_image
  validates :name, presence: true
  validates :introduction, length: { maximum: 200 }

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def sort
    @user = User.find(params[:id])
    deck_square = @user.deck_square.call(params[:from].to_i)
    deck_square.insert_at(params[:to].to_i + 1)
    head :ok
  end

  def self.guest
    find_or_create_by!(email: 'mysquare.guest@guest.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      # SecureRandom.urlsafe_base64でランダムに作成
      user.name = "ゲストユーザー"
    end
  end
end
