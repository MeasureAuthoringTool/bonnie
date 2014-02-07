class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  # Validate password complexity
  validate :password_complexity
  def password_complexity
    if password.present?
      # Passwords must have characters from at least two groups, identified by these regexes (last one is punctuation)
      matches = [/[a-z]/, /[A-Z]/, /[0-9]/, /[^\w\s]/].select { |rx| rx.match(password) }.size
      unless matches >= 2
        errors.add :password, "must include characters from at least two groups (lower case, upper case, numbers, special characters)"
      end
    end
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :telephone

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Lockable
  field :failed_attempts,    :type => Integer, :default => 0
  field :unlock_token,       :type => String
  field :locked_at,          :type => Time

  field :first_name,    :type => String
  field :last_name,    :type => String
  field :telephone,    :type => String
  field :admin, type:Boolean, :default => false
  field :portfolio, type:Boolean, :default => false

  has_many :measures
  has_many :records

  scope :by_email, ->(email) { where({email: email}) }

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  def is_admin?
    admin || false
  end

  def grant_admin
    update_attribute(:admin, true)
  end

  def revoke_admin
    update_attribute(:admin, false)
  end

  def is_portfolio?
    portfolio || false
  end

  def grant_portfolio
    update_attribute(:portfolio, true)
  end

  def revoke_portfolio
    update_attribute(:portfolio, false)
  end

end
