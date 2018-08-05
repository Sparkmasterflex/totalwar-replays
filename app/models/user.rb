class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2, :steam]

  attr_writer :login

  validates :email,          presence: true, if: Proc.new { |u| u.steam_username.blank? }
  validates :steam_username, presence: true, if: Proc.new { |u| u.email.blank? }
  validates :email, :steam_username, uniqueness: true, allow_nil: true

  def login
    @login || email || steam_username
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email          = auth.info.email
      user.steam_username = auth.info.nickname
      user.password       = Devise.friendly_token[0,20]
      user.parse_and_set_names(auth.info)
    end
  end

  def parse_and_set_names info
    first_name = info[:first_name] if info.has_key?(:first_name)
    last_name  = info[:last_name]  if info.has_key?(:last_name)
    if first_name.nil? && last_name.nil?
      first_name, last_name = info[:name].split(" ")
    end
  end
end
